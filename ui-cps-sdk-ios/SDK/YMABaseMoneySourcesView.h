//
//  YMABaseMoneySourcesView.h
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 05.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ymcpssdk-ios/ymcpssdk.h>

@protocol YMABaseMoneySourcesViewDelegate <NSObject>

- (void)didSelectedMoneySource:(YMAMoneySource *)moneySource;

- (void)removeMoneySource:(YMAMoneySource *)moneySource;

- (void)paymentFromNewCard;

- (void)showAllMoneySource;

@end

@interface YMABaseMoneySourcesView : UIView

@property(nonatomic, weak) id <YMABaseMoneySourcesViewDelegate> delegate;

- (id)initWithMoneySources:(NSArray *)moneySources andViewController:(UIViewController *)controller;

@end
