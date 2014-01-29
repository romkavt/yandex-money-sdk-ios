//
//  YMAConnectionOperation.h
//
//  Created by Александр Мертвецов on 31.10.13.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^YMAConnectionHandler)(NSURLRequest *request, NSURLResponse *response, NSData *responseData, NSError *error);

@interface YMAConnectionOperation : NSOperation <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

+ (instancetype)connectionOperationWithRequest:(NSURLRequest *)request needFollowRedirects:(BOOL)needFollowRedirects andCompletionHandler:(YMAConnectionHandler)handler;

- (id)initWithRequest:(NSURLRequest *)request needFollowRedirects:(BOOL)needFollowRedirects andCompletionHandler:(YMAConnectionHandler)handler;

@end
