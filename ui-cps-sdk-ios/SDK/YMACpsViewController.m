//
// Created by Александр Мертвецов on 06.02.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMACpsViewController.h"
#import "YMALocalization.h"

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

    self.navigationController.title = YMALocalizedString(@"NBTMainTitle", nil);
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:YMALocalizedString(@"NBBCancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(dismissController)];
    
    self.navigationItem.leftBarButtonItems = @[barButton];
}

- (void)showError:(NSError *)error {

}

- (YMABaseMoneySourcesView *)moneySourcesViewWithSources:(NSArray *)sources {
    return nil;
}

- (YMABaseCscView *)cscView {
    return nil;
}

- (YMABaseResultView *)resultViewWithState:(YMAPaymentResultState)state {
    return nil;
}

#pragma mark -
#pragma mark *** Private methods ***
#pragma mark -

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end