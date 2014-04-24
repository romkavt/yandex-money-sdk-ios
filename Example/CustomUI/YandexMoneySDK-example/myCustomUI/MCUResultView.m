//
//  MCUResultView.m
//  YandexMoneySDK-example
//
//  Created by Alexander Mertvetsov on 24.04.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "MCUResultView.h"

@interface MCUResultView ()

@property(nonatomic, assign) YMAPaymentResultState state;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, strong) UIButton *saveCardButton;

@end

@implementation MCUResultView

- (id)initWithFrame:(CGRect)frame state:(YMAPaymentResultState)state description:(NSString *)description {
    self = [super initWithFrame:frame];

    if (self) {
        _state = state;
        _description = [description copy];
        [self setupControls];
    }

    return self;
}

- (void)setupControls {
    self.backgroundColor = (self.state == YMAPaymentResultStateSuccessWithNewCard || self.state == YMAPaymentResultStateSuccessWithExistCard) ? [UIColor greenColor] : [UIColor redColor];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55.0, self.frame.size.width, 60.0)];

    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:42];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = (self.state == YMAPaymentResultStateSuccessWithNewCard || self.state == YMAPaymentResultStateSuccessWithExistCard) ? @"Success!" : @"Fail";

    [self addSubview:titleLabel];

    [self.saveCardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.saveCardButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

    if (self.state == YMAPaymentResultStateSuccessWithNewCard) {
        [self.saveCardButton setTitle:@"Save card" forState:UIControlStateNormal];
        [self.saveCardButton setTitle:@"Saving..." forState:UIControlStateDisabled];
        [self addSubview:self.saveCardButton];
        [self.saveCardButton addTarget:self action:@selector(saveMoneySource) forControlEvents:UIControlEventTouchUpInside];
    } else if (self.state == YMAPaymentResultStateFail) {
        [self.saveCardButton setTitle:@"Repeat" forState:UIControlStateNormal];
        [self addSubview:self.saveCardButton];

        [self.saveCardButton addTarget:self.delegate action:@selector(repeatPayment) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self.delegate action:@selector(dismissController)];

    rightBarButton.tintColor = [UIColor whiteColor];

    [self.delegate updateNavigationBarTitle:@"" leftButtons:@[] rightButtons:@[rightBarButton]];
}

- (void)successSaveMoneySource:(YMAMoneySource *)moneySource {
    [self.saveCardButton setTitle:@"Saved" forState:UIControlStateDisabled];
}

- (void)stopSavingMoneySourceWithError:(NSError *)error {
    [self stopSavingMoneySource];
    [self.delegate showError:error target:nil withAction:NULL];
}

#pragma mark -
#pragma mark *** Private methods ***
#pragma mark -

- (void)stopSavingMoneySource {
    self.saveCardButton.enabled = YES;
}

- (void)saveMoneySource {
    [self.delegate saveMoneySource];
    self.saveCardButton.enabled = NO;
}

#pragma mark -
#pragma mark *** Getters and setters ***
#pragma mark -

- (UIButton *)saveCardButton {
    if (!_saveCardButton) {
        CGRect buttonRect = CGRectMake(0, 300, self.frame.size.width, 44);
        _saveCardButton = [[UIButton alloc] initWithFrame:buttonRect];
        _saveCardButton.backgroundColor = [UIColor whiteColor];
    }

    return _saveCardButton;
}

@end
