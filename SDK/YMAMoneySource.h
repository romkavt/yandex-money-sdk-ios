//
// Created by Александр Мертвецов on 29.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    YMAMoneySourceUnknown,
    YMAMoneySourcePaymentCard
} YMAMoneySourceType;

typedef enum {
    YMAPaymentCardUnknown,
    YMAPaymentCardTypeVISA,
    YMAPaymentCardTypeMasterCard,
    YMAPaymentCardTypeAmericanExpress,
    YMAPaymentCardTypeJCB
} YMAPaymentCardType;

@interface YMAMoneySource : NSObject

+ (instancetype)moneySourceWithType:(YMAMoneySourceType)type cardType:(YMAPaymentCardType)cardType panFragment:(NSString *)panFragment moneySourceToken:(NSString *)moneySourceToken;

@property(nonatomic, assign, readonly) YMAMoneySourceType type;
@property(nonatomic, assign, readonly) YMAPaymentCardType cardType;
@property(nonatomic, copy, readonly) NSString *panFragment;
@property(nonatomic, copy, readonly) NSString *moneySourceToken;

@end