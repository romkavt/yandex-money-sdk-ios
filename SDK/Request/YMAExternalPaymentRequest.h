//
// Created by Александр Мертвецов on 28.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseRequest.h"

extern NSString *const kP2PPaymentParameterTo;
extern NSString *const kP2PPaymentParameterIdentifierType;
extern NSString *const kP2PPaymentParameterAmount;
extern NSString *const kP2PPaymentParameterAmountDue;

@interface YMAExternalPaymentRequest : YMABaseRequest

+ (instancetype)externalPaymentWithPatternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams;

@end