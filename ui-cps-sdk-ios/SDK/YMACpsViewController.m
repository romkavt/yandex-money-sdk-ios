//
// Created by Александр Мертвецов on 06.02.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMACpsViewController.h"
#import "YMAUIConstants.h"
#import "YMAResultView.h"
#import "YMACscView.h"
#import "YMAMoneySourcesView.h"

@interface YMACpsViewController ()

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation YMACpsViewController

#pragma mark -
#pragma mark *** UIViewController methods ***
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [YMAUIConstants defaultBackgroungColor];
    
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (void)setupNavigationBar {
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    }

    self.navigationItem.title = YMALocalizedString(@"NBTMainTitle", nil);
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:YMALocalizedString(@"NBBCancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(dismissController)];
    barButton.tintColor = [YMAUIConstants accentTextColor];
    
    self.navigationItem.leftBarButtonItems = @[barButton];
}

- (void)showError:(NSError *)error {
    for (UIView *subView in self.view.subviews) {
        CGRect viewRect = subView.frame;
        viewRect.origin.y += 100;
        subView.frame = viewRect;
    }
    
    [self.activityIndicatorView stopAnimating];
    
    CGFloat y = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7)
        y = self.navigationController.navigationBar.frame.size.height;
    
    UITextField *errorText = [[UITextField alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, 100)];
    errorText.textAlignment = NSTextAlignmentCenter;
    errorText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    errorText.backgroundColor = [UIColor whiteColor];
    errorText.textColor = [UIColor redColor];
    errorText.text = error.domain;
   
    [self.view addSubview:errorText];
}

- (YMABaseMoneySourcesView *)moneySourcesViewWithSources:(NSArray *)sources {
    return [[YMAMoneySourcesView alloc] initWithMoneySources:sources andViewController:self];
}

- (YMABaseCscView *)cscView {
    return [[YMACscView alloc] initWithViewController:self];
}

- (YMABaseResultView *)resultViewWithState:(YMAPaymentResultState)state {
    return [[YMAResultView alloc] initWithState:state amount:self.paymentRequestInfo.amount andViewController:self];;
}

#pragma mark -
#pragma mark *** Private methods ***
#pragma mark -

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark *** Getters and setters ***
#pragma mark -

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    }
    
    return _activityIndicatorView;
}

@end