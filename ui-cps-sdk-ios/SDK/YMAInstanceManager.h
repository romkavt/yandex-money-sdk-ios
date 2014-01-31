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

typedef void (^YMAMoneySourceHandler)(YMAMoneySource *requestId, NSError *error);

@interface YMAInstanceManager : NSObject

- (id)initWithClientId:(NSString *)clientId;

- (void)updateInstanceWithCompletion:(YMAHandler)block;

- (void)processPaymentWithParams:(NSDictionary *)paymentParams completion:(YMAPaymentSuccessHandler)block;

- (void)processPaymentWithParams:(NSDictionary *)paymentParams moneySourceToken:(NSString *)moneySourceToken csc:(NSString *)csc completion:(YMAHandler)block;

- (void)saveMoneySourceWithRequestId:(NSString *)requestId complition:(YMAMoneySourceHandler)block;

@end
