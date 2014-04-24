//
//  MCUCpsViewController.m
//  YandexMoneySDK-example
//
//  Created by Alexander Mertvetsov on 24.04.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "MCUCpsViewController.h"
#import "MCUMoneySourcesView.h"
#import "MCUCscView.h"
#import "MCUResultView.h"

@implementation MCUCpsViewController

#pragma mark -
#pragma mark *** UIViewController methods ***
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.backgroundColor = [UIColor greenColor];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (void)setupNavigationBar {
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    }

    self.navigationItem.title = @"Pay any card!";

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"No, thanks" style:UIBarButtonItemStylePlain target:self action:@selector(dismissController)];
    barButton.tintColor = [UIColor whiteColor];

    self.navigationItem.leftBarButtonItems = @[barButton];
}

- (void)showError:(NSError *)error target:(id)target withAction:(SEL)selector {

    NSString *message = error ? error.domain : @"Just fail";

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
}

- (void)hideError {
    //
}

- (void)disableError {
    //
}

- (YMABaseMoneySourcesView *)moneySourcesViewWithSources:(NSArray *)sources {
    return [[MCUMoneySourcesView alloc] initWithFrame:self.view.frame paymentInfo:self.paymentRequestInfo andMoneySources:sources];
}

- (YMABaseCscView *)cscView {
    return [[MCUCscView alloc] initWithFrame:self.view.frame];
}

- (YMABaseResultView *)resultViewWithState:(YMAPaymentResultState)state andDescription:(NSString *)description {
    self.scrollView.contentSize = self.view.frame.size;
    return [[MCUResultView alloc] initWithFrame:self.view.frame state:state description:description];
}

#pragma mark -
#pragma mark *** Private methods ***
#pragma mark -

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
