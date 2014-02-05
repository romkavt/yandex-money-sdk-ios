//
//  YMABaseCpsViewController.h
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 04.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMACpsManager.h"
#import "YMABaseMoneySourcesView.h"
#import "YMABaseCscView.h"
#import "YMABaseResultView.h"

@interface YMABaseCpsViewController : UIViewController<UIWebViewDelegate> {
    @protected
    YMABaseMoneySourcesView *_moneySourcesView;
    YMABaseCscView *_cscView;
    YMABaseResultView *_resultView;
}

@property(nonatomic, strong, readonly) YMACpsManager *cpsManager;

@property(nonatomic, strong, readonly) UIWebView *webView;

- (id)initWithClintId:(NSString *)clientId patternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams;

- (void)setupNavigationBar;

- (YMABaseMoneySourcesView *)moneySourcesViewWithSources:(NSArray *)sources;

- (YMABaseCscView *)cscView;

- (YMABaseResultView *)resultViewWithState:(YMAPaymentResultState)state;

@end
