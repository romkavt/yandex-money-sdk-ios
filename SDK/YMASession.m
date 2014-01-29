//
// Created by mertvetcov on 27.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMASession.h"
#import "YMAConnection.h"

typedef enum {
    YMAStatusCodeOkHTTP = 200,
    YMAStatusCodeInvalidRequestHTTP = 400,
    YMAStatusCodeInvalidTokenHTTP = 401,
    YMAStatusCodeInsufficientScopeHTTP = 403,
    YMAStatusCodeInternalServerErrorHTTP = 500
} YMAConnectHTTPStatusCodes;

static NSString *const kInstanceUrl = @"https://money.yandex.ru/api/instance-id";

static NSString *const kParameterInstanceId = @"instance_id";
static NSString *const kParameterClientId = @"client_id";
static NSString *const kParameterStatus = @"status";
static NSString *const kValueParameterStatusSuccess = @"success";
static NSString *const kHeaderWWWAuthenticate = @"WWW-Authenticate";
static NSString *const kHeaderContentType = @"Content-Type";
static NSString *const kMethodPost = @"POST";
static NSString *const kValueContentTypeDefault = @"application/x-www-form-urlencoded;charset=UTF-8";

@interface YMASession ()

@property(nonatomic, strong) NSOperationQueue *requestQueue;
@property(nonatomic, strong) NSOperationQueue *responseQueue;

@end

@implementation YMASession

#pragma mark -
#pragma mark *** Singleton methods ***
#pragma mark -

+ (id)sharedManager {
    static YMASession *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });

    return sharedMyManager;
}

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

- (void)authorizeWithClientId:(NSString *)clientId completion:(YMInstanceHandler)block {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:clientId forKey:kParameterClientId];

    //TODO use EPR API urls
    NSURL *url = [NSURL URLWithString:kInstanceUrl];

    [self performRequestWithParameters:parameters useUrl:url andCompletionHandler:^(NSURLRequest *request, NSURLResponse *response, NSData *responseData, NSError *error) {
        if (error) {
            block(nil, error);
            return;
        }

        NSInteger statusCode = ((NSHTTPURLResponse *) response).statusCode;

        id responseModel = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];

        //TODO use domain const
        NSError *unknownError = [NSError errorWithDomain:NSLocalizedString(@"technicalError", "technicalError") code:0 userInfo:parameters];

        if (error || !responseModel) {
            block(nil, (error) ? error : unknownError);
            return;
        }

        if (statusCode == YMAStatusCodeOkHTTP) {

            NSString *status = [responseModel objectForKey:kParameterStatus];

            if (![status isEqual:kValueParameterStatusSuccess]) {

                block(nil, unknownError);
                return;
            }

            self.instanceId = [responseModel objectForKey:@"instance_id"];

            block(self.instanceId, self.instanceId ? nil : unknownError);

            return;
        }

        NSString *errorKey = [responseModel objectForKey:@"error"];

        (errorKey) ? block(nil, [NSError errorWithDomain:errorKey code:statusCode userInfo:parameters]) : block(nil, unknownError);
    }];
}

- (void)performRequest:(YMABaseRequest *)request completion:(YMARequestHandler)block {

    //TODO use domain const
    NSError *unknownError = [NSError errorWithDomain:NSLocalizedString(@"technicalError", "technicalError") code:0 userInfo:@{@"request" : request}];

    if (!request)
        block(request, nil, unknownError);

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:request.parameters];

    [parameters setObject:self.instanceId forKey:kParameterInstanceId];

    [self performRequestWithParameters:parameters useUrl:request.requestUrl andCompletionHandler:^(NSURLRequest *urlRequest, NSURLResponse *urlResponse, NSData *responseData, NSError *error) {

        if (error) {
            block(request, nil, error);
            return;
        }

        NSInteger statusCode = ((NSHTTPURLResponse *) urlResponse).statusCode;
        //TODO use domain const
        NSError *technicalError = [NSError errorWithDomain:NSLocalizedString(@"technicalError", "technicalError") code:statusCode userInfo:@{@"request" : urlRequest, @"response" : urlResponse}];

        switch (statusCode) {
            case YMAStatusCodeOkHTTP:
                [request buildResponseWithData:responseData queue:self.responseQueue andCompletionHandler:block];
                break;
            case YMAStatusCodeInsufficientScopeHTTP:
            case YMAStatusCodeInvalidTokenHTTP:
                //TODO use domain const
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
    connection.shouldHandleCookies = NO;
    connection.isNeedFollowRedirects = NO;
    [connection addValue:kValueContentTypeDefault forHeader:kHeaderContentType];

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