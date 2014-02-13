//
//  YMACscView.m
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 06.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMACscView.h"
#import "YMAUIConstants.h"
#import "YMABaseCpsViewController.h"

@interface YMACscView () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
}

@property(nonatomic, strong) UIViewController *parentController;
@property(nonatomic, strong, readonly) UITableView *tableView;
@property(nonatomic, strong) UITextField *cscTextField;
@property(nonatomic, strong) UILabel *cscLabel;
@property(nonatomic, assign) BOOL isEnabled;
@property(nonatomic, strong) UIView *footer;

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
    leftBarButton.tintColor = [YMAUIConstants accentTextColor];
    
    self.parentController.navigationItem.leftBarButtonItems = @[leftBarButton];

    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:YMALocalizedString(@"NBBPayment", nil) style:UIBarButtonItemStylePlain target:self action:@selector(startPayment)];
    rightBarButton.tintColor = [YMAUIConstants accentTextColor];
    
    self.parentController.navigationItem.title = @"";

    self.parentController.navigationItem.rightBarButtonItems = @[rightBarButton];
    
    UIImageView *ymLogoView = [[UIImageView alloc] initWithImage:YMALocalizedImage(@"ym", nil)];
    CGRect logoRect = ymLogoView.frame;
    
    logoRect.origin.y = self.frame.size.height - 110;
    logoRect.origin.x = (self.frame.size.width - logoRect.size.width)/2;
    ymLogoView.frame = logoRect;
    
    [self addSubview:ymLogoView];
}

- (void)backToMoneySources {
    [self.delegate showAllMoneySource];
}

- (void)startPayment {
    [(YMABaseCpsViewController *)self.parentController disableError];
    [self.delegate startPaymentWithCsc:self.cscTextField.text];
    self.isEnabled = NO;
    self.cscTextField.enabled = NO;
    [self.tableView reloadData];
}

- (void)stopPaymentWithError:(NSError *)error {
    self.isEnabled = YES;
    self.cscTextField.enabled = YES;
    [self.tableView reloadData];
    [(YMABaseCpsViewController *)self.parentController showError:error target:self withAction:@selector(startPayment)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == 0) ? kCellHeightDefault : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return (section == 0) ? self.footer : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellID = @"cscCellID";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }

    [cell.contentView addSubview:self.cscLabel];
    [cell.contentView addSubview:self.cscTextField];

    return cell;
}

#pragma mark -
#pragma mark *** Getters and setters ***
#pragma mark -

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [YMAUIConstants defaultBackgroungColor];
    }

    return _tableView;
}

- (UITextField *)cscTextField {
    if (!_cscTextField) {
        _cscTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 20, self.frame.size.width - 10, 44)];
        _cscTextField.placeholder = YMALocalizedString(@"TPRequired", nil);
    }

    return _cscTextField;
}

- (UILabel *)cscLabel {
    if (!_cscLabel) {
        _cscLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, self.frame.size.width - 20, 20)];
        _cscLabel.font = [YMAUIConstants commentFont];
        _cscLabel.textColor = [YMAUIConstants accentTextColor];
        _cscLabel.text = YMALocalizedString(@"CTCsc", nil);
    }
    
    return _cscLabel;
}

- (UIView *)footer {
    if (!_footer) {
        _footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kCellHeightDefault)];
        _footer.backgroundColor = [YMAUIConstants defaultBackgroungColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width - 30, kCellHeightDefault)];
        label.textColor = [YMAUIConstants commentColor];
        label.numberOfLines = 2;
        label.font = [YMAUIConstants commentFont];
        label.text = YMALocalizedString(@"TFCVVCode", nil);
        
        [_footer addSubview:label];
    }
    
    return _footer;
}

@end
