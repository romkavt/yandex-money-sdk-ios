//
//  ViewController.m
//  ios-example
//
//  Created by Alexander Mertvetsov on 07.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "ViewController.h"

//Use you application identifier
static NSString *const kClientId = @"YOU_CLIENT_ID";

@interface ViewController ()

@property(nonatomic, strong) UIButton *doPaymentButton;
@property(nonatomic, strong) UILabel *phoneNumberLabel;
@property(nonatomic, strong) UITextField *phoneNumberTextField;
@property(nonatomic, strong) UILabel *amountLabel;
@property(nonatomic, strong) UITextField *amountTextField;
@property(nonatomic, strong, readonly) NSDictionary *instanceIdQuery;
@property(nonatomic, copy) NSString *instanceId;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.doPaymentButton setTitle:@"pay" forState:UIControlStateNormal];
    [self.doPaymentButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [self.view addSubview:self.doPaymentButton];
    
    [self.doPaymentButton addTarget:self action:@selector(doTestPayment) forControlEvents:UIControlEventTouchUpInside];
    
    self.phoneNumberLabel.text = @"phone number";
    
    
    [self.view addSubview:self.phoneNumberLabel];
    
    UIView *bgPhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 84, self.view.frame.size.width, 44)];
    bgPhoneView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [self.view addSubview:bgPhoneView];
    [bgPhoneView release];
    
    self.phoneNumberTextField.placeholder = @"7##########";
    [self.view addSubview:self.phoneNumberTextField];
    
    self.amountLabel.text = @"Amount (RUB)";
    [self.view addSubview:self.amountLabel];
    
    UIView *bgAmountView = [[UIView alloc] initWithFrame:CGRectMake(0, 184, self.view.frame.size.width, 44)];
    bgAmountView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [self.view addSubview:bgAmountView];
    [bgAmountView release];
    
    self.amountTextField.placeholder = @"0 rub.";
    [self.view addSubview:self.amountTextField];
}

- (void)dealloc {
    [_doPaymentButton release];
    [_phoneNumberLabel release];
    [_phoneNumberTextField release];
    [_amountLabel release];
    [_amountTextField release];
    
    [super dealloc];
}

- (void)doTestPayment {
    
}

#pragma mark -
#pragma mark *** UI  ***
#pragma mark -

- (UIButton *)doPaymentButton {
    if (!_doPaymentButton) {
        CGRect buttonRect = CGRectMake(0, 270, self.view.frame.size.width, 44);
        
        _doPaymentButton = [[UIButton alloc] initWithFrame:buttonRect];
        _doPaymentButton.backgroundColor = [UIColor whiteColor];
    }
    
    return _doPaymentButton;
}

- (UILabel *)phoneNumberLabel {
    if (!_phoneNumberLabel) {
        CGRect labelRect = CGRectMake(20, 40, self.view.frame.size.width - 40, 44);
        
        _phoneNumberLabel = [[UILabel alloc] initWithFrame:labelRect];
    }
    
    return _phoneNumberLabel;
}

- (UITextField *)phoneNumberTextField {
    if (!_phoneNumberTextField) {
        CGRect textFieldRect = CGRectMake(20, 84, self.view.frame.size.width - 40, 44);
        
        _phoneNumberTextField = [[UITextField alloc] initWithFrame:textFieldRect];
        _phoneNumberTextField.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    }
    
    return _phoneNumberTextField;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        CGRect labelRect = CGRectMake(20, 140, self.view.frame.size.width - 40, 44);
        
        _amountLabel = [[UILabel alloc] initWithFrame:labelRect];
    }
    
    return _amountLabel;
}

- (UITextField *)amountTextField {
    if (!_amountTextField) {
        CGRect textFieldRect = CGRectMake(20, 184, self.view.frame.size.width - 40, 44);
        
        _amountTextField = [[UITextField alloc] initWithFrame:textFieldRect];
        _amountTextField.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    }
    
    return _amountTextField;
}

@end
