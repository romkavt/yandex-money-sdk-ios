//
// Created by mertvetcov on 27.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseRequest.h"

/**
 @abstract Completion block

 @discussion

 @param err
    Error information or nil.

 @param token
    Token
 */

typedef void (^YMInstanceHandler)(NSString *instanceId, NSError *error);

/**
 @abstract Completion block used by several methods of YMASession.

 @discussion
 A block with this signature is called by several of methods of YMASession to signal whether or not the method finished execution successful.
 On success err is nil, otherwise it contains information about the error which occurred.

 @param err
    Error information or nil.
 */

typedef void (^YMHandler)(NSError *error);

@interface YMASession : NSObject

@property(nonatomic, copy) NSString *instanceId;

+ (instancetype)sharedManager;

- (void)authorizeWithClientId:(NSString *)clientId completion:(YMInstanceHandler)block;

- (void)performRequest:(YMABaseRequest *)request completion:(YMARequestHandler)block;

@end