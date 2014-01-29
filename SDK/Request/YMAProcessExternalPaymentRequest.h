//
// Created by Александр Мертвецов on 28.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseRequest.h"

@interface YMAProcessExternalPaymentRequest : YMABaseRequest

+ (instancetype)processExternalPaymentWithRequestId:(NSString *)requestId successUri:(NSString *)successUri failUri:(NSString *)failUri requestToken:(BOOL)requestToken;

+ (instancetype)processExternalPaymentWithRequestId:(NSString *)requestId successUri:(NSString *)successUri failUri:(NSString *)failUri moneySourceToken:(NSString *)moneySourceToken andCsc:(NSString *)csc;

@end