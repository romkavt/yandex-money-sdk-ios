//
//  YMAInstanceManager.h
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 30.01.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ymcpssdk-ios/ymcpssdk.h>

typedef void (^YMAPaymentSuccessHandler)(NSString *requestId, NSError *error);

typedef void (^YMAMoneySourceHandler)(YMAMoneySource *moneySource, NSError *error);

@interface YMAInstanceManager : NSObject

@property(nonatomic, strong, readonly) NSArray *moneySources;
@property(nonatomic, strong, readonly) YMASession *session;

- (id)initWithClientId:(NSString *)clientId;

- (void)updateInstanceWithCompletion:(YMAHandler)block;

- (void)saveMoneySourceWithRequestId:(NSString *)requestId complition:(YMAMoneySourceHandler)block;

- (void)removeMoneySource:(YMAMoneySource *)moneySource;

@end
