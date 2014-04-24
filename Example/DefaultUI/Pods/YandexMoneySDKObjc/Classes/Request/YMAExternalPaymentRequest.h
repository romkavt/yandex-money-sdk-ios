//
// Created by Alexander Mertvetsov on 28.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseRequest.h"

///
/// Payment request. First phase of payment is required to obtain payment info (YMAPaymentRequestInfo)
/// using patternId and paymentParams.
///
@interface YMAExternalPaymentRequest : YMABaseRequest

/// Constructor. Returns a YMAExternalPaymentRequest with the specified patternId and paymentParams.
/// @param patternId - ID of showcase on which payment is made.
/// @param paymentParams - payment parameters.
+ (instancetype)externalPaymentWithPatternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams;

@end