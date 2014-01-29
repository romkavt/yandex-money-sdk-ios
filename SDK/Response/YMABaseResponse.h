//
//  YMABaseResponse.h
//
//  Created by Александр Мертвецов on 01.11.13.
//  Copyright (c) 2013 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMABaseResponse;

typedef enum {
    YMAResponseStatusSuccess,
    YMAResponseStatusRefused,
    YMAResponseStatusInProgress,
    YMAResponseStatusExtAuthRequired
} YMAResponseStatus;

typedef void (^YMAResponseHandler)(YMABaseResponse *response, NSError *error);

@interface YMABaseResponse : NSOperation

- (id)initWithData:(NSData *)data andCompletionHandler:(YMAResponseHandler)handler;

@property(nonatomic, assign, readonly) YMAResponseStatus status;
@property(nonatomic, assign, readonly) NSUInteger nextRetry;

@end
