//
// Created by Alexander Mertvetsov on 27.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMASession.h"
#import "YMAConnection.h"
#import "YMAConstants.h"

typedef NS_ENUM(NSInteger, YMAConnectHTTPStatusCodes) {
    YMAStatusCodeOkHTTP = 200,
    YMAStatusCodeInvalidRequestHTTP = 400,
    YMAStatusCodeInvalidTokenHTTP = 401,
    YMAStatusCodeInsufficientScopeHTTP = 403,
    YMAStatusCodeInternalServerErrorHTTP = 500
};

static NSString *const kInstanceUrl = @"https://money.yandex.ru/api/instance-id";

static NSString *const kParameterInstanceId = @"instance_id";
static NSString *const kParameterClientId = @"client_id";
static NSString *const kParameterStatus = @"status";
static NSString *const kValueParameterStatusSuccess = @"success";
static NSString *const kHeaderWWWAuthenticate = @"WWW-Authenticate";
static NSString *const kHeaderContentType = @"Content-Type";
static NSString *const kHeaderUserAgent = @"User-Agent";
static NSString *const kMethodPost = @"POST";
static NSString *const kValueUserAgentDefault = @"Yandex.Money.SDK/iOS";
static NSString *const kValueContentTypeDefault = @"application/x-www-form-urlencoded;charset=UTF-8";

@interface YMASession ()

@property(nonatomic, strong) NSOperationQueue *requestQueue;
@property(nonatomic, strong) NSOperationQueue *responseQueue;

@end

@implementation YMASession

- (id)init {
    self = [super init];

    if (self) {
        _requestQueue = [[NSOperationQueue alloc] init];
        _responseQueue = [[NSOperationQueue alloc] init];
    }

    return self;
}

#pragma mark -
#pragma mark *** Public methods ***
#pragma mark -

- (void)authorizeWithClientId:(NSString *)clientId completion:(YMAInstanceHandler)block {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:clientId forKey:kParameterClientId];

    NSURL *url = [NSURL URLWithString:kInstanceUrl];

    [self performRequestWithParameters:parameters useUrl:url andCompletionHandler:^(NSURLRequest *request, NSURLResponse *response, NSData *responseData, NSError *error) {
        if (error) {
            block(nil, error);
            return;
        }

        NSInteger statusCode = ((NSHTTPURLResponse *) response).statusCode;

        id responseModel = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];

        NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:parameters];

        if (error || !responseModel) {
            block(nil, (error) ? error : unknownError);
            return;
        }

        if (statusCode == YMAStatusCodeOkHTTP) {

            NSString *status = [responseModel objectForKey:kParameterStatus];
            
            if ([status isEqual:kValueParameterStatusSuccess]) {
                
                self.instanceId = [responseModel objectForKey:@"instance_id"];
                
                block(self.instanceId, self.instanceId ? nil : unknownError);
                
                return;
            }
        }

        NSString *errorKey = [responseModel objectForKey:@"error"];

        (errorKey) ? block(nil, [NSError errorWithDomain:errorKey code:statusCode userInfo:parameters]) : block(nil, unknownError);
    }];
}

- (void)performRequest:(YMABaseRequest *)request completion:(YMARequestHandler)block {
    NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"request" : request}];

    if (!request || !self.instanceId) {
        block(request, nil, unknownError);
        return;
    }
        
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:request.parameters];
   
    [parameters setObject:self.instanceId forKey:kParameterInstanceId];

    [self performRequestWithParameters:parameters useUrl:request.requestUrl andCompletionHandler:^(NSURLRequest *urlRequest, NSURLResponse *urlResponse, NSData *responseData, NSError *error) {

        if (error) {
            block(request, nil, error);
            return;
        }

        NSInteger statusCode = ((NSHTTPURLResponse *) urlResponse).statusCode;
        NSError *technicalError = [NSError errorWithDomain:kErrorKeyUnknown code:statusCode userInfo:@{@"request" : urlRequest, @"response" : urlResponse}];

        switch (statusCode) {
            case YMAStatusCodeOkHTTP:
                [request buildResponseWithData:responseData queue:self.responseQueue andCompletion:block];
                break;
            case YMAStatusCodeInsufficientScopeHTTP:
            case YMAStatusCodeInvalidTokenHTTP:
                block(request, nil, [NSError errorWithDomain:[self valueOfHeader:kHeaderWWWAuthenticate forResponse:urlResponse] code:statusCode userInfo:@{@"request" : urlRequest, @"response" : urlResponse}]);
                break;
            case YMAStatusCodeInvalidRequestHTTP:
                block(request, nil, technicalError);
                break;
            default:
                block(request, nil, unknownError);
                break;
        }
    }];
}

#pragma mark -
#pragma mark *** Private methods ***
#pragma mark -

- (void)performRequestWithParameters:(NSDictionary *)parameters useUrl:(NSURL *)url andCompletionHandler:(YMAConnectionHandler)handler {
    YMAConnection *connection = [[YMAConnection alloc] initWithUrl:url];
    connection.requestMethod = kMethodPost;
    [connection addValue:kValueContentTypeDefault forHeader:kHeaderContentType];
    [connection addValue:kValueUserAgentDefault forHeader:kHeaderUserAgent];

    [connection addPostParams:parameters];

    [connection sendAsynchronousWithQueue:self.requestQueue completionHandler:handler];
}

- (NSString *)valueOfHeader:(NSString *)headerName forResponse:(NSURLResponse *)response {
    NSDictionary *headers = [((NSHTTPURLResponse *) response) allHeaderFields];

    for (NSString *header in headers.allKeys) {
        if ([header caseInsensitiveCompare:headerName] == NSOrderedSame)
            return [headers objectForKey:header];
    }

    return nil;
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self, @{@"instanceId" : self.instanceId}];
}

@end