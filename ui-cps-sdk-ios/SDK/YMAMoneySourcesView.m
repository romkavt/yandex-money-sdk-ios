//
//  YMAMoneySourcesView.m
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 06.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAMoneySourcesView.h"
#import "YMAUIConstants.h"

@interface YMAMoneySourcesView () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
}

@property(nonatomic, strong) NSMutableArray *moneySources;
@property(nonatomic, strong, readonly) UITableView *tableView;
@property(nonatomic, strong) UIViewController *parentController;

@end

@implementation YMAMoneySourcesView

- (id)initWithMoneySources:(NSArray *)moneySources andViewController:(UIViewController *)controller {
    self = (controller) ? [super initWithFrame:controller.view.frame] : [super init];
    
    if (self) {
        _moneySources = [NSMutableArray arrayWithArray:moneySources];
        _parentController = controller;
        [self setupControls];
    }
    
    return self;
}

- (void)setupControls {
    [self addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.parentController.navigationController.title = YMALocalizedString(@"NBTMoneySourceTitle", nil);
    
    UIImageView *ymLogoView = [[UIImageView alloc] initWithImage:YMALocalizedImage(@"ym", nil)];
    CGRect logoRect = ymLogoView.frame;
    logoRect.origin.y = self.frame.size.height - 50;
    logoRect.origin.x = (self.frame.size.width - logoRect.size.width)/2;
    ymLogoView.frame = logoRect;
    
    [self.tableView.backgroundView addSubview:ymLogoView];
}

#pragma mark -
#pragma mark *** TableView  delegate ***
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.moneySources.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeightDefault;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"moneySourceCellID";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    if (indexPath.row < self.moneySources.count) {
        YMAMoneySource *moneySource = [self.moneySources objectAtIndex:indexPath.row];
        
        if (moneySource.cardType == YMAPaymentCardTypeVISA)
            cell.imageView.image = YMALocalizedImage(kImageKeyVISA, nil);
        else if (moneySource.cardType == YMAPaymentCardTypeMasterCard)
            cell.imageView.image = YMALocalizedImage(kImageKeyMasterCard, nil);
        else if (moneySource.cardType == YMAPaymentCardTypeAmericanExpress)
            cell.imageView.image = YMALocalizedImage(kImageKeyAmericanExpress, nil);
            
        cell.textLabel.text = moneySource.panFragment;
    } else if (indexPath.row == self.moneySources.count) {
        cell.textLabel.text = YMALocalizedString(@"CTNewCard", nil);
        cell.textLabel.textColor = [YMAUIConstants accentTextColor];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YMAMoneySource *moneySource = [self.moneySources objectAtIndex:indexPath.row];
        [self.delegate removeMoneySource:moneySource];
        [self.moneySources removeObject:moneySource];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.moneySources.count) {
        YMAMoneySource *moneySource = [self.moneySources objectAtIndex:indexPath.row];
        [self.delegate didSelectedMoneySource:moneySource];
    } else if (indexPath.row == self.moneySources.count)
        [self.delegate paymentFromNewCard];
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


@end
