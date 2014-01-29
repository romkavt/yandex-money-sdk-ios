//
//  YMAConnection.m
//
//  Created by Александр Мертвецов on 31.10.13.
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

    NSOperation *operation = [[YMAConnectionOperation alloc] initWithRequest:self.request needFollowRedirects:self.isNeedFollowRedirects andCompletionHandler:handler];

    [queue addOperation:operation];
}

+ (void)sendAsynchronousRequest:(NSURLRequest *)request needFollowRedirects:(BOOL)isNeedFollowRedirects withQueue:(NSOperationQueue *)queue
              completionHandler:(YMAConnectionHandler)handler; {
    NSOperation *operation = [[YMAConnectionOperation alloc] initWithRequest:request needFollowRedirects:isNeedFollowRedirects andCompletionHandler:handler];

    [queue addOperation:operation];
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

        NSString *encodedValue = [paramValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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

- (void)setShouldHandleCookies:(BOOL)shouldHandleCookies {
    self.request.HTTPShouldHandleCookies = shouldHandleCookies;
}

- (BOOL)shouldHandleCookies {
    return self.request.HTTPShouldHandleCookies;
}

@end
