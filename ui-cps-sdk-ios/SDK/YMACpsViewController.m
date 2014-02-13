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

@property(nonatomic, strong) UILabel *errorText;
@property(nonatomic, strong) UIButton *errorButton;

@end

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

- (void)showError:(NSError *)error target:(id)target withAction:(SEL)selector {
    [self.errorText removeFromSuperview];
    [self.errorButton removeFromSuperview];
    
    CGFloat errorHeight = (selector) ? kErrorHeight + kCellHeightDefault : kErrorHeight;
    
    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height += errorHeight;
    self.scrollView.contentSize = contentSize;
    
    for (UIView *subView in self.scrollView.subviews) {
        CGRect viewRect = subView.frame;
        viewRect.origin.y += errorHeight;
        subView.frame = viewRect;
    }
    
    [self.activityIndicatorView stopAnimating];
   
    self.errorText.text = error.domain;
   
    [self.scrollView addSubview:self.errorText];
    
    if (!selector || !target)
        return;
    
    [self.errorButton setTitle: YMALocalizedString(@"BTRepeat", nil) forState:UIControlStateNormal];
    [self.errorButton setTitleColor:[YMAUIConstants accentTextColor] forState:UIControlStateNormal];
    self.errorButton.titleLabel.font = [YMAUIConstants buttonFont];
    
    [self.scrollView addSubview:self.errorButton];
    
    [self.errorButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.errorButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
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

- (UILabel *)errorText {
    if (!_errorText) {
        _errorText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kErrorHeight)];
        _errorText.textAlignment = NSTextAlignmentCenter;
        _errorText.backgroundColor = [UIColor whiteColor];
        _errorText.textColor = [UIColor redColor];
    }
    
    return _errorText;
}

- (UIButton *)errorButton {
    if (!_errorButton) {
        CGRect buttonRect = CGRectMake(0, kErrorHeight, self.view.frame.size.width, kCellHeightDefault);
        _errorButton = [[UIButton alloc] initWithFrame:buttonRect];
        _errorButton.backgroundColor = [UIColor whiteColor];
        
        CGFloat separatorHeight = [UIScreen mainScreen].scale == 2 ? 0.5 : 1;
        
        CGRect separatorRect = CGRectMake(0, 0, self.view.frame.size.width, separatorHeight);
        
        UIView *topSeparatorView = [[UIView alloc] initWithFrame:separatorRect];
        topSeparatorView.backgroundColor = [YMAUIConstants separatorColor];
        
        [_errorButton addSubview:topSeparatorView];
        
        separatorRect.origin.y = kCellHeightDefault;
        UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:separatorRect];
        bottomSeparatorView.backgroundColor = [YMAUIConstants separatorColor];
        
        [_errorButton addSubview:bottomSeparatorView];
    }
    
    return _errorButton;
}

@end