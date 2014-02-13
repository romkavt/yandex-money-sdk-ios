//
//  YMACscView.m
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 06.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMACscView.h"
#import "YMAUIConstants.h"

@interface YMACscView () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
}

@property(nonatomic, strong) UIViewController *parentController;
@property(nonatomic, strong, readonly) UITableView *tableView;
@property(nonatomic, strong) UITextField *cscTextField;
@property(nonatomic, assign) BOOL isEnabled;

@end

@implementation YMACscView

- (id)initWithViewController:(UIViewController *)controller {
    self = (controller) ? [super initWithFrame:controller.view.frame] : [super init];

    if (self) {
        _parentController = controller;
        _isEnabled = YES;
        [self setupControls];
    }

    return self;
}

- (void)setupControls {
    [self addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    //TODO use image for back button
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backToMoneySources)];

    self.parentController.navigationItem.leftBarButtonItems = @[leftBarButton];

    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:YMALocalizedString(@"NBBPayment", nil) style:UIBarButtonItemStylePlain target:self action:@selector(startPayment)];

    self.parentController.navigationItem.rightBarButtonItems = @[rightBarButton];
    
    UIImageView *ymLogoView = [[UIImageView alloc] initWithImage:YMALocalizedImage(@"ym", nil)];
    CGRect logoRect = ymLogoView.frame;
    logoRect.origin.y = self.frame.size.height - 50;
    logoRect.origin.x = (self.frame.size.width - logoRect.size.width)/2;
    ymLogoView.frame = logoRect;
    
    [self addSubview:ymLogoView];
}

- (void)backToMoneySources {
    [self.delegate showAllMoneySource];
}

- (void)startPayment {
    [self.delegate startPaymentWithCsc:self.cscTextField.text];
    self.isEnabled = NO;
    self.cscTextField.enabled = NO;
    [self.tableView reloadData];
}

- (void)stopPaymentWithError:(NSError *)error {
    self.isEnabled = YES;
    self.cscTextField.enabled = YES;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark *** TableView  delegate ***
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeightWithTextField;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellID = @"cscCellID";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    cell.textLabel.text = YMALocalizedString(@"CTCsc", nil);

    [cell.contentView addSubview:self.cscTextField];

    return cell;
}

#pragma mark -
#pragma mark *** Getters and setters ***
#pragma mark -

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame];
        _tableView.backgroundColor = [YMAUIConstants defaultBackgroungColor];
    }

    return _tableView;
}

- (UITextField *)cscTextField {
    if (!_cscTextField) {
        _cscTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width - 10, 44)];
    }

    return _cscTextField;
}

@end
