//
//  YMABaseCscView.h
//  ui-cps-sdk-ios
//
//  Created by Alexander Mertvetsov on 05.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMABaseCpsViewDelegate.h"

@protocol YMABaseCscViewDelegate <YMABaseCpsViewDelegate>

- (void)startPaymentWithCsc:(NSString *)csc;

@end

@interface YMABaseCscView : UIView

@property(nonatomic, weak) id <YMABaseCscViewDelegate> delegate;

- (void)stopPaymentWithError:(NSError *)error;

@end
