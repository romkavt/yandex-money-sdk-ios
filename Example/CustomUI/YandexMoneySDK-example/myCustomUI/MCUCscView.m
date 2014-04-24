//
//  MCUCscView.m
//  YandexMoneySDK-example
//
//  Created by Alexander Mertvetsov on 24.04.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "MCUCscView.h"

@interface MCUCscView ()

@property(nonatomic, strong) UITextField *cscTextField;
@property(nonatomic, strong) UIBarButtonItem *backBarButton;

@end

@implementation MCUCscView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupControls];
    }
    return self;
}

- (void)setupControls {
    self.backgroundColor = [UIColor greenColor];

    UIView *backgroundCscView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 44)];
    backgroundCscView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backgroundCscView];
    [self addSubview:self.cscTextField];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupDefaultNavigationBar];
}

- (void)setupDefaultNavigationBar {
    self.backBarButton.tintColor = [UIColor whiteColor];
    self.backBarButton.enabled = YES;

    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Payment" style:UIBarButtonItemStylePlain target:self action:@selector(startPayment)];
    rightBarButton.tintColor = [UIColor whiteColor];

    [self.delegate updateNavigationBarTitle:@"" leftButtons:@[self.backBarButton] rightButtons:@[rightBarButton]];
}

- (void)startPayment {
    [self.delegate disableError];
    [self.delegate startPaymentWithCsc:self.cscTextField.text];
    self.cscTextField.enabled = NO;

    self.backBarButton.tintColor = [UIColor grayColor];
    self.backBarButton.enabled = NO;

    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity startAnimating];
    UIBarButtonItem *activityButton = [[UIBarButtonItem alloc] initWithCustomView:activity];

    [self.delegate updateNavigationBarTitle:@"" leftButtons:@[self.backBarButton] rightButtons:@[activityButton]];
}

- (void)stopPaymentWithError:(NSError *)error {
    self.cscTextField.enabled = YES;
    [self.delegate showError:error target:nil withAction:NULL];
    [self setupDefaultNavigationBar];
}

- (void)removeFromSuperview {
    self.backBarButton.tintColor = [UIColor whiteColor];
    self.backBarButton.enabled = YES;

    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity startAnimating];
    UIBarButtonItem *activityButton = [[UIBarButtonItem alloc] initWithCustomView:activity];

    [self.delegate updateNavigationBarTitle:@"" leftButtons:@[self.backBarButton] rightButtons:@[activityButton]];

    [super removeFromSuperview];
}

#pragma mark -
#pragma mark *** Getters and setters ***
#pragma mark -

- (UITextField *)cscTextField {
    if (!_cscTextField) {
        _cscTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 20, self.frame.size.width - 10, 44)];
        _cscTextField.secureTextEntry = YES;
        _cscTextField.keyboardType = UIKeyboardTypeNumberPad;

    }

    return _cscTextField;
}

- (UIBarButtonItem *)backBarButton {
    if (!_backBarButton) {
        _backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self.delegate action:@selector(showMoneySource)];
    }

    return _backBarButton;
}

@end
