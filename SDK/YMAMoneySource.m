//
// Created by Александр Мертвецов on 29.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAMoneySource.h"

@implementation YMAMoneySource

- (id)initWithType:(YMAMoneySourceType)type cardType:(YMAPaymentCardType)cardType panFragment:(NSString *)panFragment moneySourceToken:(NSString *)moneySourceToken {
    self = [super init];

    if (self) {
        _type = type;
        _cardType = cardType;
        _panFragment = [panFragment copy];
        _moneySourceToken = [moneySourceToken copy];
    }

    return self;
}

+ (instancetype)moneySourceWithType:(YMAMoneySourceType)type cardType:(YMAPaymentCardType)cardType panFragment:(NSString *)panFragment moneySourceToken:(NSString *)moneySourceToken {
    return [[YMAMoneySource alloc] initWithType:type cardType:cardType panFragment:panFragment moneySourceToken:moneySourceToken];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"type" : [NSNumber numberWithInt:self.type],
                                              @"cardType" : [NSNumber numberWithInt:self.cardType],
                                              @"panFragment" : self.panFragment,
                                              @"moneySourceToken" : self.moneySourceToken
                                      }];
}

@end