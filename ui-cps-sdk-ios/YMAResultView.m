//
// Created by mertvetcov on 06.02.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAResultView.h"
#import "YMAUIConstants.h"
#import "YMABaseCpsViewController.h"

static NSUInteger const kSaveButtonOffset = 100;
static NSUInteger const kLeftOffset = 40;
static NSUInteger const kTitleLabelTopOffset = 80;
static NSUInteger const kTitleLabelHeight = 50;
static CGFloat const kDefaultSeparatorHeight = 1.0;

@interface YMAResultView ()

@property(nonatomic, assign) YMAPaymentResultState state;
@property(nonatomic, copy) NSString *amount;
@property(nonatomic, strong) UIViewController *parentController;
@property(nonatomic, strong) UIButton *saveCardButton;
@property(nonatomic, strong) UILabel *saveButtonComment;

@end

@implementation YMAResultView

- (id)initWithState:(YMAPaymentResultState)state amount:(NSString *)amount andViewController:(UIViewController *)controller {
    self = (controller) ? [super initWithFrame:controller.view.frame] : [super init];

    if (self) {
        _state = state;
        _parentController = controller;
        _amount = [amount copy];
        [self setupControls];
    }

    return self;
}

- (void)setupControls {    
    self.backgroundColor = [YMAUIConstants defaultBackgroungColor];
    
    self.parentController.navigationItem.title = YMALocalizedString(@"NBTResultSuccess", nil);
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:YMALocalizedString(@"NBBSuccess", nil) style:UIBarButtonItemStylePlain target:self action:@selector(dismissController)];
    
    rightBarButton.tintColor = [YMAUIConstants accentTextColor];
    
    self.parentController.navigationItem.rightBarButtonItems = @[rightBarButton];
    self.parentController.navigationItem.leftBarButtonItems = @[];
    
    [self.saveCardButton setTitle: YMALocalizedString(@"BTSaveCard", nil) forState:UIControlStateNormal];
    [self.saveCardButton setTitleColor:[YMAUIConstants accentTextColor] forState:UIControlStateNormal];
    self.saveCardButton.titleLabel.font = [YMAUIConstants buttonFont];

    [self addSubview:self.saveCardButton];
    
    self.saveButtonComment.text = YMALocalizedString(@"TLSaveCardComment", nil);
    self.saveButtonComment.font = [YMAUIConstants commentFont];
    self.saveButtonComment.textColor = [YMAUIConstants commentColor];
    self.saveButtonComment.numberOfLines = 2;
    self.saveButtonComment.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.saveButtonComment];
    
    CGFloat y = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7)
        y = self.parentController.navigationController.navigationBar.frame.size.height;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y + kTitleLabelTopOffset, self.frame.size.width, kTitleLabelHeight)];
    titleLabel.text = YMALocalizedString(@"TLThanks", nil);
    titleLabel.font = [YMAUIConstants titleFont];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:titleLabel];
    
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftOffset, y + kTitleLabelTopOffset + kTitleLabelHeight, self.frame.size.width - 2*kLeftOffset, kTitleLabelHeight)];
    amountLabel.text = [NSString stringWithFormat:YMALocalizedString(@"TLAmount", nil), self.amount];
    amountLabel.font = [YMAUIConstants commentTitleFont];
    amountLabel.textColor = [YMAUIConstants commentColor];
    amountLabel.numberOfLines = 2;
    amountLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:amountLabel];
        
    [self.saveCardButton addTarget:self action:@selector(saveMoneySource) forControlEvents:UIControlEventTouchUpInside];
}

- (void)successSaveMoneySource:(YMAMoneySource *)moneySource {

}

- (void)stopSavingMoneySourceWithError:(NSError *)error {
    self.saveCardButton.enabled = YES;
    [(YMABaseCpsViewController *)self.parentController showError:error];
}

#pragma mark -
#pragma mark *** Private methods ***
#pragma mark -

- (void)saveMoneySource {
    [self.delegate saveMoneySource];
    self.saveCardButton.enabled = NO;
}

- (void)dismissController {
    [self.parentController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark *** Getters and setters ***
#pragma mark -

- (UIButton *)saveCardButton {
    if (!_saveCardButton) {
        CGRect buttonRect = CGRectMake(0, self.frame.size.height - kSaveButtonOffset, self.frame.size.width, kCellHeightDefault);
        _saveCardButton = [[UIButton alloc] initWithFrame:buttonRect];
        _saveCardButton.backgroundColor = [UIColor whiteColor];
        
        CGFloat separatorHeight = [UIScreen mainScreen].scale == 2 ? kDefaultSeparatorHeight/2 : kDefaultSeparatorHeight;
        
        CGRect separatorRect = CGRectMake(0, 0, self.frame.size.width, separatorHeight);
        
        UIView *topSeparatorView = [[UIView alloc] initWithFrame:separatorRect];
        topSeparatorView.backgroundColor = [YMAUIConstants separatorColor];
        
        [_saveCardButton addSubview:topSeparatorView];
        
        separatorRect.origin.y = kCellHeightDefault;
        UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:separatorRect];
        bottomSeparatorView.backgroundColor = [YMAUIConstants separatorColor];
        
        [_saveCardButton addSubview:bottomSeparatorView];
    }
    
    return _saveCardButton;
}

- (UILabel *)saveButtonComment {
    if (!_saveButtonComment) {
        _saveButtonComment = [[UILabel alloc] initWithFrame:CGRectMake(kLeftOffset, self.frame.size.height - (kSaveButtonOffset - kCellHeightDefault),self.frame.size.width - kLeftOffset*2, kCellHeightDefault)];
    }
    
    return _saveButtonComment;
}

@end