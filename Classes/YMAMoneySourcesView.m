//
//  YMAMoneySourcesView.m
//  ui-cps-sdk-ios
//
//  Created by Alexander Mertvetsov on 06.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAMoneySourcesView.h"
#import "YMAUIConstants.h"

@interface YMAMoneySourcesView () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
}

@property(nonatomic, strong) NSMutableArray *moneySources;
@property(nonatomic, strong, readonly) UITableView *tableView;
@property(nonatomic, strong) UIView *header;
@property(nonatomic, strong) YMAExternalPaymentInfoModel *paymentInfo;
@property(nonatomic, strong) UILabel *paymentInfoValue;
@property(nonatomic, strong) UILabel *paymentInfoTitle;

@end

@implementation YMAMoneySourcesView

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
    self.backgroundColor = [YMAUIConstants defaultBackgroundColor];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    UIImageView *ymLogoView = [[UIImageView alloc] initWithImage:YMALocalizedImage(@"ym", nil)];
    CGRect logoRect = ymLogoView.frame;

    logoRect.origin.y = self.frame.size.height - 110;
    logoRect.origin.x = (self.frame.size.width - logoRect.size.width) / 2;
    ymLogoView.frame = logoRect;

    [self addSubview:ymLogoView];
    [self addSubview:self.tableView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:YMALocalizedString(@"NBBCancel", nil) style:UIBarButtonItemStylePlain target:self.delegate action:@selector(dismissController)];
    barButton.tintColor = [YMAUIConstants accentTextColor];

    [self.delegate updateNavigationBarTitle:YMALocalizedString(@"NBTMoneySourceTitle", nil) leftButtons:@[barButton] rightButtons:@[]];
}

#pragma mark -
#pragma mark *** TableView  delegate ***
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section) ? self.moneySources.count + 1 : 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section) ? kControlHeightDefault : kControlHeightWithTextField;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section) ? kControlHeightDefault : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return (section) ? self.header : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"moneySourceCellID";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];

    if (indexPath.section) {
        if (indexPath.row < self.moneySources.count) {
            YMAMoneySourceModel *moneySource = [self.moneySources objectAtIndex:(NSUInteger) indexPath.row];

            if (moneySource.cardType == YMAPaymentCardTypeVISA)
                cell.imageView.image = YMALocalizedImage(kImageKeyCardVISA, nil);
            else if (moneySource.cardType == YMAPaymentCardTypeMasterCard)
                cell.imageView.image = YMALocalizedImage(kImageKeyCardMasterCard, nil);
            else if (moneySource.cardType == YMAPaymentCardTypeAmericanExpress)
                cell.imageView.image = YMALocalizedImage(kImageKeyCardAmericanExpress, nil);
            else
                cell.imageView.image = YMALocalizedImage(kImageKeyCardDefault, nil);

            cell.textLabel.text = moneySource.panFragment;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        } else if (indexPath.row == self.moneySources.count) {
            cell.textLabel.text = YMALocalizedString(@"CTNewCard", nil);
            cell.textLabel.textColor = [YMAUIConstants accentTextColor];
            cell.imageView.image = YMALocalizedImage(kImageKeyCardNew, nil);
        }
    } else {

        UILabel *paymentInfoTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, self.frame.size.width - 20, 20)];
        paymentInfoTitle.font = [YMAUIConstants commentFont];
        paymentInfoTitle.textColor = [YMAUIConstants commentColor];

        UILabel *paymentInfoValue = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, self.frame.size.width - 10, 44)];

        [cell.contentView addSubview:paymentInfoTitle];
        [cell.contentView addSubview:paymentInfoValue];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (indexPath.row == 0) {
            paymentInfoTitle.text = YMALocalizedString(@"CTPaymentName", nil);
            paymentInfoValue.text = self.paymentInfo.title;

        } else {
            paymentInfoTitle.text = YMALocalizedString(@"CTAmount", nil);
            paymentInfoValue.text = [NSString stringWithFormat:@"%@ %@", self.paymentInfo.amount, YMALocalizedString(@"CTRub", nil)];
        }

        cell.separatorInset = UIEdgeInsetsMake(0, self.frame.size.width, 0, 0);
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1 && indexPath.row != self.moneySources.count;
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

    if (indexPath.section == 0)
        return;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row < self.moneySources.count) {
        YMAMoneySourceModel *moneySource = [self.moneySources objectAtIndex:(NSUInteger) indexPath.row];
        [self.delegate didSelectedMoneySource:moneySource];
    } else if (indexPath.row == self.moneySources.count) {

        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:YMALocalizedImage(@"back", nil) style:UIBarButtonItemStylePlain target:self.delegate action:@selector(showMoneySource)];
        leftBarButton.tintColor = [YMAUIConstants accentTextColor];

        [self.delegate updateNavigationBarTitle:YMALocalizedString(@"NBTMainTitle", nil) leftButtons:@[leftBarButton] rightButtons:@[]];
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

- (UIView *)header {
    if (!_header) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kControlHeightDefault)];
        _header.backgroundColor = [YMAUIConstants defaultBackgroundColor];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width, kControlHeightDefault)];
        label.textColor = [YMAUIConstants commentColor];
        label.font = [YMAUIConstants commentFont];
        label.text = YMALocalizedString(@"THMoneySources", nil);

        [_header addSubview:label];
    }

    return _header;
}

- (UILabel *)paymentInfoValue {
    if (!_paymentInfoValue) {
        _paymentInfoValue = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, self.frame.size.width - 10, 44)];
    }

    return _paymentInfoValue;
}

- (UILabel *)paymentInfoTitle {
    if (!_paymentInfoTitle) {
        _paymentInfoTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, self.frame.size.width - 20, 20)];
    }

    return _paymentInfoTitle;
}

@end
