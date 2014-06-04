//
//  YMACpsController.m
//  ui-cps-sdk-ios
//
//  Created by Alexander Mertvetsov on 17.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMACpsController.h"

@interface YMACpsController ()

@end

@implementation YMACpsController

- (id)initWithClientId:(NSString *)clientId patternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams {
    _cpsViewController = [[YMACpsViewController alloc] initWithClientId:clientId patternId:patternId andPaymentParams:paymentParams];

    return [super initWithRootViewController:_cpsViewController];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
