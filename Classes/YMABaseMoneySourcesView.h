//
//  YMABaseMoneySourcesView.h
//  ui-cps-sdk-ios
//
//  Created by Alexander Mertvetsov on 05.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMAMoneySourceModel.h"
#import "YMAExternalPaymentInfoModel.h"
#import "YMABaseCpsViewDelegate.h"

@protocol YMABaseMoneySourcesViewDelegate <YMABaseCpsViewDelegate>

- (void)didSelectedMoneySource:(YMAMoneySourceModel *)moneySource;

- (void)removeMoneySource:(YMAMoneySourceModel *)moneySource;

- (void)paymentFromNewCard;

@end

@interface YMABaseMoneySourcesView : UIView

@property(nonatomic, weak) id <YMABaseMoneySourcesViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame paymentInfo:(YMAExternalPaymentInfoModel *)paymentInfo andMoneySources:(NSArray *)moneySources;

@end
