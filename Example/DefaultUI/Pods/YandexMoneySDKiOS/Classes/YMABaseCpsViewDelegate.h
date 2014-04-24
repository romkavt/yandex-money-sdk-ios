//
//  YMABaseCpsViewDelegate.h
//  ui-cps-sdk-ios
//
//  Created by Alexander Mertvetsov on 14.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YMABaseCpsViewDelegate <NSObject>

- (void)updateNavigationBarTitle:(NSString *)title leftButtons:(NSArray *)leftButtons rightButtons:(NSArray *)rightButtons;

- (void)showError:(NSError *)error target:(id)target withAction:(SEL)selector;

- (void)disableError;

- (void)dismissController;

- (void)showMoneySource;

@end
