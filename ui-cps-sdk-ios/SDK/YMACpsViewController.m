//
// Created by Александр Мертвецов on 06.02.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMACpsViewController.h"
#import "YMAUIConstants.h"
#import "YMAResultView.h"
#import "YMACscView.h"
#import "YMAMoneySourcesView.h"

@implementation YMACpsViewController

#pragma mark -
#pragma mark *** UIViewController methods ***
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];

    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
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

}

- (YMABaseMoneySourcesView *)moneySourcesViewWithSources:(NSArray *)sources {
    return [[YMAMoneySourcesView alloc] initWithMoneySources:sources andViewController:self];
}

- (YMABaseCscView *)cscView {
    return [[YMACscView alloc] initWithViewController:self];
}

- (YMABaseResultView *)resultViewWithState:(YMAPaymentResultState)state {
    return [[YMAResultView alloc] initWithState:state andViewController:self];;
}

#pragma mark -
#pragma mark *** Private methods ***
#pragma mark -

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end