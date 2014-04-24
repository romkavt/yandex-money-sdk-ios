//
// Created by Alexander Mertvetsov on 27.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseRequest.h"

/// Completion of block is used to get the ID of an installed copy of the application.
/// @param instanceId - ID of an installed copy of the application.
typedef void (^YMAInstanceHandler)(NSString *instanceId, NSError *error);

/// Completion block used by several methods of YMASession.
/// @param error - Error information or nil.
typedef void (^YMAHandler)(NSError *error);

///
/// Session object to access Yandex.Money.
///
@interface YMASession : NSObject

/// ID of an installed copy of the application. Used when you perform requests as parameter.
@property(nonatomic, copy) NSString *instanceId;

/// Register your application using clientId and obtaining instanceId.
/// @param clientId - application Identifier.
/// @param block - completion of block is used to get the ID of an installed copy of the application.
- (void)authorizeWithClientId:(NSString *)clientId completion:(YMAInstanceHandler)block;

/// Perform some request and obtaining response in block.
/// @param request - request inherited from YMABaseRequest.
/// @param block - completion of block is used to get the response.
- (void)performRequest:(YMABaseRequest *)request completion:(YMARequestHandler)block;

@end