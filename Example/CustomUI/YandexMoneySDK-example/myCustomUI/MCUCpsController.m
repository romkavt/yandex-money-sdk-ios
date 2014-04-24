//
//  MCUCpsController.m
//  YandexMoneySDK-example
//
//  Created by Alexander Mertvetsov on 24.04.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "MCUCpsController.h"
#import "MCUCpsViewController.h"

@implementation MCUCpsController

- (id)initWithClientId:(NSString *)clientId patternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams {
    MCUCpsViewController *cpsViewController = [[MCUCpsViewController alloc] initWithClientId:clientId patternId:patternId andPaymentParams:paymentParams];
   
    return [super initWithRootViewController:cpsViewController];

}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
