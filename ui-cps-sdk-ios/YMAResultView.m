//
// Created by mertvetcov on 06.02.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAResultView.h"

@interface YMAResultView ()

@property(nonatomic, assign) YMAPaymentResultState state;
@property(nonatomic, strong) UIViewController *parentController;

@end

@implementation YMAResultView

- (id)initWithState:(YMAPaymentResultState)state andViewController:(UIViewController *)controller {
    self = (controller) ? [super initWithFrame:controller.view.frame] : [super init];

    if (self) {
        _state = state;
        _parentController = controller;
    }

    return self;
}

- (void)successSaveMoneySource:(YMAMoneySource *)moneySource {

}

- (void)stopSavingMoneySourceWithError:(NSError *)error {

}

@end