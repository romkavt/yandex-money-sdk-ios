//
//  YMABaseCpsViewController.h
//  ui-cps-sdk-ios
//
//  Created by Alexander Mertvetsov on 04.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMACpsManager.h"
#import "YMABaseMoneySourcesView.h"
#import "YMABaseCscView.h"
#import "YMABaseResultView.h"

@protocol YMABaseCpsViewControllerDelegate <NSObject>

- (void)paymentSuccessWithInvoiceId:(NSString *)invoiceId;

@end

@interface YMABaseCpsViewController : UIViewController <UIWebViewDelegate>

@property(nonatomic, assign) id<YMABaseCpsViewControllerDelegate> delegate;

@property(nonatomic, strong, readonly) UIScrollView *scrollView;

@property(nonatomic, strong, readonly) YMACpsManager *cpsManager;

@property(nonatomic, strong, readonly) UIWebView *webView;

@property(nonatomic, strong, readonly) YMAExternalPaymentInfoModel *paymentRequestInfo;

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

- (id)initWithClientId:(NSString *)clientId patternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams;

- (void)setupNavigationBar;

- (void)showError:(NSError *)error target:(id)target withAction:(SEL)selector;

- (void)hideError;

- (void)disableError;

- (YMABaseMoneySourcesView *)moneySourcesViewWithSources:(NSArray *)sources;

- (YMABaseCscView *)cscView;

- (YMABaseResultView *)resultViewWithState:(YMAPaymentResultState)state andDescription:(NSString *)description;

@end
