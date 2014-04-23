//
//  YMAPaymentRequestInfo.h
//  cps-sdk
//
//  Created by Alexander Mertvetsov on 10.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

///
/// This class contains info about the payment request (requestId, amount, title).
///
@interface YMAPaymentRequestInfo : NSObject

/// Constructor. Returns a YMAPaymentRequestInfo with the specified requestId, amount, and payment title.
/// @param requestId - ID of the current payment request.
/// @param amount - The amount of the payment.
/// @param title - A title of the payment.
+ (instancetype)paymentRequestInfoWithId:(NSString *)requestId amount:(NSString *)amount andTitle:(NSString *)title;

@property(nonatomic, copy, readonly) NSString *requestId;
@property(nonatomic, copy, readonly) NSString *amount;
@property(nonatomic, copy, readonly) NSString *title;

@end
