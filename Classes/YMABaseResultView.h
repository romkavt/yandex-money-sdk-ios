//
//  YMABaseSuccessView.h
//  ui-cps-sdk-ios
//
//  Created by Alexander Mertvetsov on 05.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMAMoneySourceModel.h"
#import "YMABaseCpsViewDelegate.h"

typedef NS_ENUM(NSInteger, YMAPaymentResultState) {
    YMAPaymentResultStateSuccessWithNewCard,
    YMAPaymentResultStateSuccessWithExistCard,
    YMAPaymentResultStateFatalFail,
    YMAPaymentResultStateFail
};

@protocol YMABaseResultViewDelegate <YMABaseCpsViewDelegate>

- (void)saveMoneySource;

- (void)repeatPayment;

@end

@interface YMABaseResultView : UIView

@property(nonatomic, weak) id <YMABaseResultViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame state:(YMAPaymentResultState)state description:(NSString *)description;

- (void)successSaveMoneySource:(YMAMoneySourceModel *)moneySource;

- (void)stopSavingMoneySourceWithError:(NSError *)error;

@end
