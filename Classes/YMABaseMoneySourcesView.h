//
//  YMABaseMoneySourcesView.h
//  ui-cps-sdk-ios
//
//  Created by Alexander Mertvetsov on 05.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ymcpssdk.h>
#import "YMABaseCpsViewDelegate.h"

@protocol YMABaseMoneySourcesViewDelegate <YMABaseCpsViewDelegate>

- (void)didSelectedMoneySource:(YMAMoneySource *)moneySource;

- (void)removeMoneySource:(YMAMoneySource *)moneySource;

- (void)paymentFromNewCard;

@end

@interface YMABaseMoneySourcesView : UIView

@property(nonatomic, weak) id <YMABaseMoneySourcesViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame paymentInfo:(YMAPaymentRequestInfo *)paymentInfo andMoneySources:(NSArray *)moneySources;

@end
