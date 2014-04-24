//
//  MCUCpsController.h
//  YandexMoneySDK-example
//
//  Created by Alexander Mertvetsov on 24.04.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCUCpsController : UINavigationController

- (id)initWithClientId:(NSString *)clientId patternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams;

@end
