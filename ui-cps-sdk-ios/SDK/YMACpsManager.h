//
//  YMACpsManager.h
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 30.01.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ymcpssdk-ios/ymcpssdk.h>

typedef void (^YMAStartPaymentHandler)(NSString *requestId, NSError *error);

typedef void (^YMAFinishPaymentHandler)(YMAAsc *asc, NSError *error);

typedef void (^YMAMoneySourceHandler)(YMAMoneySource *moneySource, NSError *error);

@interface YMACpsManager : NSObject

@property(nonatomic, strong, readonly) NSArray *moneySources;

- (id)initWithClientId:(NSString *)clientId;

- (void)updateInstanceWithCompletion:(YMAHandler)block;

- (void)saveMoneySourceWithRequestId:(NSString *)requestId completion:(YMAMoneySourceHandler)block;

- (void)removeMoneySource:(YMAMoneySource *)moneySource;

- (void)startPaymentWithPatternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams completion:(YMAStartPaymentHandler)block;

- (void)finishPaymentWithRequestId:(NSString *)requestId completion:(YMAFinishPaymentHandler)block;

- (void)finishPaymentWithRequestId:(NSString *)requestId moneySourceToken:(NSString *)moneySourceToken andCsc:(NSString *)csc completion:(YMAFinishPaymentHandler)block;

@end
