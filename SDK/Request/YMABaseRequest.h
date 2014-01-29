//
//  YMABaseRequest.h
//
//  Created by Александр Мертвецов on 01.11.13.
//  Copyright (c) 2013 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMABaseRequest;
@class YMABaseResponse;

typedef void (^YMARequestHandler)(YMABaseRequest *request, YMABaseResponse *response, NSError *error);

@interface YMABaseRequest : NSObject

@property(nonatomic, strong, readonly) NSURL *requestUrl;
@property(nonatomic, strong, readonly) NSDictionary *parameters;

- (void)buildResponseWithData:(NSData *)data queue:(NSOperationQueue *)queue andCompletionHandler:(YMARequestHandler)handler;

@end
