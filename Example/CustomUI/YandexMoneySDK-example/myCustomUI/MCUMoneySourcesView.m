//
//  MCUMoneySourcesView.m
//  YandexMoneySDK-example
//
//  Created by Alexander Mertvetsov on 24.04.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "MCUMoneySourcesView.h"

static CGFloat const kControlHeightDefault = 44.0;

@interface MCUMoneySourcesView () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
}

@property(nonatomic, strong) NSMutableArray *moneySources;
@property(nonatomic, strong, readonly) UITableView *tableView;
@property(nonatomic, strong) YMAExternalPaymentInfoModel *paymentInfo;

@end

@implementation MCUMoneySourcesView

- (id)initWithFrame:(CGRect)frame paymentInfo:(YMAExternalPaymentInfoModel *)paymentInfo andMoneySources:(NSArray *)moneySources {
    self = [super initWithFrame:frame];

    if (self) {
        _moneySources = [NSMutableArray arrayWithArray:moneySources];
        _paymentInfo = paymentInfo;
        [self setupControls];
    }

    return self;
}

- (void)setupControls {
    self.backgroundColor = [UIColor greenColor];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self addSubview:self.tableView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"No, thanks" style:UIBarButtonItemStylePlain target:self.delegate action:@selector(dismissController)];
    barButton.tintColor = [UIColor whiteColor];

    [self.delegate updateNavigationBarTitle:[NSString stringWithFormat:@"Pay %@ for %@", self.paymentInfo.amount, self.paymentInfo.title] leftButtons:@[barButton] rightButtons:@[]];
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
    return kControlHeightDefault;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"moneySourceCellID";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];


    if (indexPath.row < self.moneySources.count) {
        YMAMoneySourceModel *moneySource = [self.moneySources objectAtIndex:(NSUInteger) indexPath.row];

        NSString *cardType;

        switch (moneySource.cardType) {
            case YMAPaymentCardTypeVISA:
                cardType = @"VISA";
                break;

            case YMAPaymentCardTypeMasterCard:
                cardType = @"MasterCard";
                break;

            case YMAPaymentCardTypeAmericanExpress:
                cardType = @"AmericanExpress";
                break;

            case YMAPaymentCardTypeJCB:
                cardType = @"JCB";
                break;

            default:
                cardType = @"unknown";
                break;
        }

        cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)", moneySource.panFragment, cardType];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    } else if (indexPath.row == self.moneySources.count)
        cell.textLabel.text = @"New card";

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row != self.moneySources.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YMAMoneySourceModel *moneySource = [self.moneySources objectAtIndex:(NSUInteger) indexPath.row];
        [self.delegate removeMoneySource:moneySource];
        [self.moneySources removeObject:moneySource];
        [self.tableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row < self.moneySources.count) {
        YMAMoneySourceModel *moneySource = [self.moneySources objectAtIndex:(NSUInteger) indexPath.row];
        [self.delegate didSelectedMoneySource:moneySource];
    } else if (indexPath.row == self.moneySources.count) {

        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self.delegate action:@selector(showMoneySource)];
        leftBarButton.tintColor = [UIColor whiteColor];

        [self.delegate updateNavigationBarTitle:@"Pay any card" leftButtons:@[leftBarButton] rightButtons:@[]];
        [self.delegate paymentFromNewCard];
    }
}

#pragma mark -
#pragma mark *** Getters and setters ***
#pragma mark -

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
    }

    return _tableView;
}

@end
