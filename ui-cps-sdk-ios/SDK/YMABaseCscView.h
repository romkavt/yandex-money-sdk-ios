//
//  YMABaseCscView.h
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 05.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YMABaseCscViewDelegate <NSObject>

- (void)startPaymentWithCsc:(NSString *)csc;

- (void)showAllMoneySource;

@end

@interface YMABaseCscView : UIView

@property(nonatomic, weak) id <YMABaseCscViewDelegate> delegate;

- (id)initWithViewController:(UIViewController *)controller;

- (void)stopPaymentWithError:(NSError *)error;

@end
