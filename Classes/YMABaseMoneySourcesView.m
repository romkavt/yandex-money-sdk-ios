//
//  YMABaseMoneySourcesView.m
//  ui-cps-sdk-ios
//
//  Created by Alexander Mertvetsov on 05.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMABaseMoneySourcesView.h"

@implementation YMABaseMoneySourcesView

- (id)initWithFrame:(CGRect)frame paymentInfo:(YMAExternalPaymentInfoModel *)paymentInfo andMoneySources:(NSArray *)moneySources {
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

@end
