//
// Created by Alexander Mertvetsov on 28.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseRequest.h"

///
/// Process payment request. Second phase of payment.
/// The application calls the process-external-payment persistently,
/// until the emergence of the final status of payment (YMAResponseStatusSuccess).
/// If the processing of the payment is still not complete method will be responsible status - YMAResponseStatusInProgress;
///
@interface YMAProcessExternalPaymentRequest : YMABaseRequest

/// Constructor. Returns a YMAProcessExternalPaymentRequest with the specified requestId,
/// successUri, failUri and requestToken.
/// @param requestId - ID of the current payment request.
/// @param successUri - Return address of the page if successful payment authorization by credit card.
/// @param failUri - Return address of the page with the refusal to authorize payment by credit card.
/// @param requestToken - Parameter is set to YES - an application requests a token (YMAMoneySource) for repeat payments.
+ (instancetype)processExternalPaymentWithRequestId:(NSString *)requestId successUri:(NSString *)successUri failUri:(NSString *)failUri requestToken:(BOOL)requestToken;

/// Constructor. Returns a YMAProcessExternalPaymentRequest with the specified requestId, successUri,
/// failUri, moneySourceToken and csc.
/// @param requestId - ID of the current payment request.
/// @param successUri - Return address of the page if successful payment authorization by credit card.
/// @param failUri - Return address of the page with the refusal to authorize payment by credit card.
/// @param moneySourceToken - Token for repeating payments (YMAMoneySource).
/// @param csc -  Card Security Code, CVV2/CVC2.
+ (instancetype)processExternalPaymentWithRequestId:(NSString *)requestId successUri:(NSString *)successUri failUri:(NSString *)failUri moneySourceToken:(NSString *)moneySourceToken andCsc:(NSString *)csc;

@end