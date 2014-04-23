//
// Created by Alexander Mertvetsov on 29.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseResponse.h"

@class YMAAsc;
@class YMAMoneySource;

///
/// Process payment response. This class contains info about redirect to authorization page (asc)
/// and info about the money source (moneySource).
///
@interface YMAProcessExternalPaymentResponse : YMABaseResponse

/// Info about redirect to authorization page.
/// The property is not equal nil for status = YMAResponseStatusExtAuthRequired.
@property(nonatomic, strong, readonly) YMAAsc *asc;
/// Info about the money source (Information about the credit card).
/// The property is not equal nil if:
/// - was set the request parameter requestToken = YES;
/// - payment completed successfully (status = YMAResponseStatusSuccess).
@property(nonatomic, strong, readonly) YMAMoneySource *moneySource;
/// The number of transaction in the system Yandex.Money.
/// Present at the success of the payment in the shop.
@property(nonatomic, copy, readonly) NSString *invoiceId;

@end