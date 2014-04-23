//
//  YMAConnection.m
//
//  Created by Alexander Mertvetsov on 31.10.13.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAConnection.h"

static NSInteger const kRequestTimeoutIntervalDefault = 60;
static NSString *const kHeaderContentLength = @"Content-Length";

@interface YMAConnection ()

@property(nonatomic, strong) NSMutableURLRequest *request;

@end

@implementation YMAConnection

- (id)initWithUrl:(NSURL *)url {
    self = [super init];
    
    if (self) {
        _request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kRequestTimeoutIntervalDefault];
    }
    
    return self;
}

+ (instancetype)connectionWithUrl:(NSURL *)url {
    return [[YMAConnection alloc] initWithUrl:url];
}

- (void)sendAsynchronousWithQueue:(NSOperationQueue *)queue completionHandler:(YMAConnectionHandler)handler {
    
    [self.request addValue:[NSString stringWithFormat:@"%lu", (unsigned long) [self.request.HTTPBody length]] forHTTPHeaderField:kHeaderContentLength];
    
    [NSURLConnection sendAsynchronousRequest:self.request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        handler(self.request, response, data, connectionError);
    }];
}

- (void)addValue:(NSString *)value forHeader:(NSString *)header {
    [self.request addValue:value forHTTPHeaderField:header];
}

- (void)addPostParams:(NSDictionary *)postParams {
    if (!postParams)
        return;
    
    NSMutableArray *bodyParams = [[NSMutableArray alloc] init];
    
    for (NSString *key in postParams.allKeys) {
        
        id value = [postParams objectForKey:key];
        NSString *paramValue = nil;
        
        if ([value isKindOfClass:[NSNumber class]])
            paramValue = [value stringValue];
        else
            paramValue = value;
        
        NSString *encodedValue = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                        (__bridge CFStringRef)paramValue,
                                                                                                        NULL,
                                                                                                        (CFStringRef)@";/?:@&=+$,",
                                                                                                        kCFStringEncodingUTF8));
        
        NSString *encodedKey = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                      (__bridge CFStringRef)key,
                                                                                                      NULL,
                                                                                                      (CFStringRef)@";/?:@&=+$,",
                                                                                                      kCFStringEncodingUTF8));
        [bodyParams addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
    }
    
    NSString *bodyString = [bodyParams componentsJoinedByString:@"&"];
    self.request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)addBodyData:(NSData *)bodyData {
    self.request.HTTPBody = bodyData;
}

#pragma mark -
#pragma mark *** Getters and setters ***
#pragma mark -

- (void)setRequestMethod:(NSString *)requestMethod {
    self.request.HTTPMethod = requestMethod;
}

- (NSString *)requestMethod {
    return self.request.HTTPMethod;
}

@end
