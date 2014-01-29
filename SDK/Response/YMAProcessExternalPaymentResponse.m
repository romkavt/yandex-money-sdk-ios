//
// Created by Александр Мертвецов on 29.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAProcessExternalPaymentResponse.h"
#import "YMAAsc.h"
#import "YMAMoneySource.h"

static NSString *const kParameterAcsUrl = @"acs_uri";
static NSString *const kParameterAcsParams = @"acs_params";
static NSString *const kParameterMoneySource = @"money_source";
static NSString *const kParameterType = @"type";
static NSString *const kParameterPaymentCardType = @"payment_card_type";
static NSString *const kParameterPanFragment = @"pan_fragment";
static NSString *const kParameterMoneySourceToken = @"money_source_token";

static NSString *const kMoneySourceTypePaymentCard = @"payment-card";

static NSString *const kPaymentCardTypeVISA = @"VISA";
static NSString *const kPaymentCardTypeMasterCard = @"MasterCard";
static NSString *const kPaymentCardTypeAmericanExpress = @"AmericanExpress";
static NSString *const kPaymentCardTypeJCB = @"JCB";

@implementation YMAProcessExternalPaymentResponse

#pragma mark -
#pragma mark *** Private methods ***
#pragma mark -

- (YMAPaymentCardType)paymentCardTypeByString:(NSString *)string {
    if ([string isEqual:kPaymentCardTypeVISA])
        return YMAPaymentCardTypeVISA;

    if ([string isEqual:kPaymentCardTypeMasterCard])
        return YMAPaymentCardTypeMasterCard;

    if ([string isEqual:kPaymentCardTypeAmericanExpress])
        return YMAPaymentCardTypeAmericanExpress;

    if ([string isEqual:kPaymentCardTypeJCB])
        return YMAPaymentCardTypeJCB;

    return YMAPaymentCardUnknown;
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (void)parseJSONModel:(id)responseModel {
    NSString *acsUrl = [responseModel objectForKey:kParameterAcsUrl];

    if (acsUrl) {
        NSDictionary *acsParams = [responseModel objectForKey:kParameterAcsParams];
        _asc = [YMAAsc ascWithUrl:[NSURL URLWithString:acsUrl] andParams:acsParams];
    }

    NSDictionary *moneySource = [responseModel objectForKey:kParameterMoneySource];

    if (moneySource) {
        NSString *type = [moneySource objectForKey:kParameterType];

        if ([type isEqual:kMoneySourceTypePaymentCard]) {
            NSString *paymentCardTypeString = [moneySource objectForKey:kParameterPaymentCardType];
            YMAPaymentCardType paymentCardType = [self paymentCardTypeByString:paymentCardTypeString];

            NSString *panFragment = [moneySource objectForKey:kParameterPanFragment];
            NSString *moneySourceToken = [moneySource objectForKey:kParameterMoneySourceToken];

            _moneySource = [YMAMoneySource moneySourceWithType:YMAMoneySourcePaymentCard cardType:paymentCardType panFragment:panFragment moneySourceToken:moneySourceToken];

        } else
            _moneySource = [YMAMoneySource moneySourceWithType:YMAMoneySourceUnknown cardType:YMAPaymentCardUnknown panFragment:nil moneySourceToken:nil];
    }

}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"asc" : [self.asc description],
                                              @"moneySource" : [self.moneySource description]
                                      }];
}

@end