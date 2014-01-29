//
// Created by Александр Мертвецов on 29.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseResponse.h"

@class YMAAsc;
@class YMAMoneySource;


@interface YMAProcessExternalPaymentResponse : YMABaseResponse

@property(nonatomic, strong, readonly) YMAAsc *asc;
@property(nonatomic, strong, readonly) YMAMoneySource *moneySource;

@end