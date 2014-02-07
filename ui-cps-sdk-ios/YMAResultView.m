//
// Created by mertvetcov on 06.02.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAResultView.h"
#import "YMAUIConstants.h"

@interface YMAResultView ()

@property(nonatomic, assign) YMAPaymentResultState state;
@property(nonatomic, strong) UIViewController *parentController;
@property(nonatomic, strong) UIButton *saveCardButton;

@end

@implementation YMAResultView

- (id)initWithState:(YMAPaymentResultState)state andViewController:(UIViewController *)controller {
    self = (controller) ? [super initWithFrame:controller.view.frame] : [super init];

    if (self) {
        _state = state;
        _parentController = controller;
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

    [self addSubview:self.saveCardButton];

    [self.saveCardButton addTarget:self action:@selector(saveMoneySource) forControlEvents:UIControlEventTouchUpInside];
}

- (void)successSaveMoneySource:(YMAMoneySource *)moneySource {

}

- (void)stopSavingMoneySourceWithError:(NSError *)error {
    self.saveCardButton.enabled = YES;
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
        CGRect buttonRect = CGRectMake(0, self.frame.size.height/2, self.frame.size.width, kCellHeightDefault);
        
        _saveCardButton = [[UIButton alloc] initWithFrame:buttonRect];
        _saveCardButton.titleLabel.text = YMALocalizedString(@"BTSaveCard", nil);
        _saveCardButton.backgroundColor = [UIColor whiteColor];
        [_saveCardButton setTitleColor:[YMAUIConstants accentTextColor] forState:UIControlStateNormal];
    }
    
    return _saveCardButton;
}

@end