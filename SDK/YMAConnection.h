//
//  YMAConnection.h
//
//  Created by Александр Мертвецов on 31.10.13.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAConnectionOperation.h"

@interface YMAConnection : NSObject

@property(nonatomic, assign) BOOL isNeedFollowRedirects;
@property(nonatomic, copy) NSString *requestMethod;
@property(nonatomic, assign) BOOL shouldHandleCookies;

+ (instancetype)connectionWithUrl:(NSURL *)url;

- (id)initWithUrl:(NSURL *)url;

- (void)sendAsynchronousWithQueue:(NSOperationQueue *)queue
                completionHandler:(YMAConnectionHandler)handler;

+ (void)sendAsynchronousRequest:(NSURLRequest *)request needFollowRedirects:(BOOL)isNeedFollowRedirects withQueue:(NSOperationQueue *)queue
              completionHandler:(YMAConnectionHandler)handler;

- (void)addValue:(NSString *)value forHeader:(NSString *)header;

- (void)addPostParams:(NSDictionary *)postParams;

- (void)addBodyData:(NSData *)bodyData;

@end
