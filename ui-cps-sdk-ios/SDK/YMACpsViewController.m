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
    self.scrollView.backgroundColor = [YMAUIConstants defaultBackgroungColor];
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
    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height += kErrorHeight;
    self.scrollView.contentSize = contentSize;
    
    for (UIView *subView in self.scrollView.subviews) {
        CGRect viewRect = subView.frame;
        viewRect.origin.y += kErrorHeight;
        subView.frame = viewRect;
    }
    
    [self.activityIndicatorView stopAnimating];
    
    UILabel *errorText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kErrorHeight)];
    errorText.textAlignment = NSTextAlignmentCenter;
    errorText.backgroundColor = [UIColor whiteColor];
    errorText.textColor = [UIColor redColor];
    errorText.text = error.domain;
   
    [self.scrollView addSubview:errorText];
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

@end