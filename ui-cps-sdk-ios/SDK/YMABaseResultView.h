//
//  YMABaseSuccessView.h
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 05.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ymcpssdk-ios/ymcpssdk.h>

typedef enum {
    YMAPaymentResultStateSuccessWithNewCard,
    YMAPaymentResultStateSuccessWithExistCard,
    YMAPaymentResultStateFail
} YMAPaymentResultState;

@protocol YMABaseResultViewDelegate <NSObject>

- (void)saveMoneySource;

- (void)repeatPayment;

@end

@interface YMABaseResultView : UIView

@property(nonatomic, weak) id <YMABaseResultViewDelegate> delegate;

- (id)initWithState:(YMAPaymentResultState)state andViewController:(UIViewController *)controller;

- (void)successSaveMoneySource:(YMAMoneySource *)moneySource;

- (void)stopSavingMoneySourceWithError:(NSError *)error;

@end
