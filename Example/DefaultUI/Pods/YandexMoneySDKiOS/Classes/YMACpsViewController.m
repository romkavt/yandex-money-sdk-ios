//
// Created by Alexander Mertvetsov on 06.02.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMACpsViewController.h"
#import "YMAUIConstants.h"
#import "YMAResultView.h"
#import "YMACscView.h"
#import "YMAMoneySourcesView.h"

@interface YMACpsViewController ()

@property(nonatomic, strong) UITextView *errorText;
@property(nonatomic, strong) UIButton *errorButton;
@property(nonatomic, assign) CGFloat errorHeight;

@end

@implementation YMACpsViewController

#pragma mark -
#pragma mark *** UIViewController methods ***
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.backgroundColor = [YMAUIConstants defaultBackgroundColor];
    self.errorHeight = 0.0;
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

- (void)showError:(NSError *)error target:(id)target withAction:(SEL)selector {

    [self.errorText removeFromSuperview];
    [self.errorButton removeFromSuperview];

    CGFloat newErrorHeight = ((selector) ? kErrorHeight + kControlHeightDefault : kErrorHeight);
    CGFloat deltaErrorHeight = newErrorHeight - self.errorHeight;
    self.errorHeight = newErrorHeight;

    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height += deltaErrorHeight;
    self.scrollView.contentSize = contentSize;

    for (UIView *subView in self.scrollView.subviews) {
        CGRect viewRect = subView.frame;
        viewRect.origin.y += deltaErrorHeight;
        subView.frame = viewRect;
    }

    [self.activityIndicatorView stopAnimating];

    CGFloat separatorHeight = [UIScreen mainScreen].scale == 2 ? 0.5 : 1;
    CGRect separatorRect = CGRectMake(0, kErrorHeight - separatorHeight, self.view.frame.size.width, separatorHeight);
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:separatorRect];
    topSeparatorView.backgroundColor = [YMAUIConstants separatorColor];
    [self.errorText addSubview:topSeparatorView];

    NSString *errorText = YMALocalizedString(error.domain, nil);
    errorText = [errorText isEqualToString:error.domain] ? YMALocalizedString(@"unknownError", nil) : errorText;
    self.errorText.text = errorText;
    [self.scrollView addSubview:self.errorText];

    if (!selector || !target)
        return;

    [self.errorButton setTitle:YMALocalizedString(@"BTRepeat", nil) forState:UIControlStateNormal];
    [self.errorButton setTitleColor:[YMAUIConstants accentTextColor] forState:UIControlStateNormal];
    [self.errorButton setTitleColor:[YMAUIConstants commentColor] forState:UIControlStateDisabled];
    self.errorButton.titleLabel.font = [YMAUIConstants buttonFont];

    [self.scrollView addSubview:self.errorButton];

    [self.errorButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.errorButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];

    self.errorText.textColor = [UIColor blackColor];
    self.errorButton.enabled = YES;
}

- (void)hideError {
    [self.errorText removeFromSuperview];
    [self.errorButton removeFromSuperview];

    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height -= self.errorHeight;
    self.scrollView.contentSize = contentSize;

    for (UIView *subView in self.scrollView.subviews) {
        CGRect viewRect = subView.frame;
        viewRect.origin.y -= self.errorHeight;
        subView.frame = viewRect;
    }

    self.errorHeight = 0;
}

- (void)disableError {
    self.errorText.textColor = [YMAUIConstants commentColor];
    self.errorButton.enabled = NO;
}

- (YMABaseMoneySourcesView *)moneySourcesViewWithSources:(NSArray *)sources {
    return [[YMAMoneySourcesView alloc] initWithFrame:self.view.frame paymentInfo:self.paymentRequestInfo andMoneySources:sources];;
}

- (YMABaseCscView *)cscView {
    return [[YMACscView alloc] initWithFrame:self.view.frame];
}

- (YMABaseResultView *)resultViewWithState:(YMAPaymentResultState)state andDescription:(NSString *)description {
    CGRect viewRect = self.view.frame;
    CGFloat y = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7)
        y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    viewRect.size.height -= y; //self.scrollView.contentSize.height;

    self.scrollView.contentSize = viewRect.size;

    return [[YMAResultView alloc] initWithFrame:viewRect state:state description:description];
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

- (UITextView *)errorText {
    if (!_errorText) {
        _errorText = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kErrorHeight)];
        _errorText.textAlignment = NSTextAlignmentCenter;
        _errorText.textContainerInset = UIEdgeInsetsMake(15, 15, 5, 15);
        _errorText.backgroundColor = [UIColor whiteColor];
        _errorText.editable = NO;
        _errorText.font = [YMAUIConstants commentFont];
    }

    return _errorText;
}

- (UIButton *)errorButton {
    if (!_errorButton) {
        CGRect buttonRect = CGRectMake(0, kErrorHeight, self.view.frame.size.width, kControlHeightDefault);
        _errorButton = [[UIButton alloc] initWithFrame:buttonRect];
        _errorButton.backgroundColor = [UIColor whiteColor];

        CGFloat separatorHeight = [UIScreen mainScreen].scale == 2 ? 0.5 : 1;
        CGRect separatorRect = CGRectMake(0, kControlHeightDefault, self.view.frame.size.width, separatorHeight);

        UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:separatorRect];
        bottomSeparatorView.backgroundColor = [YMAUIConstants separatorColor];

        [_errorButton addSubview:bottomSeparatorView];
    }

    return _errorButton;
}

@end