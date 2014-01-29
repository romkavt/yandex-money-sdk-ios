//
// Created by Александр Мертвецов on 28.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAProcessExternalPaymentRequest.h"
#import "YMAProcessExternalPaymentResponse.h"

static NSString *const kUrlProcessExternalPayment = @"https://money.yandex.ru/api/process-external-payment";

static NSString *const kParameterRequestId = @"request_id";
static NSString *const kParameterSuccessUri = @"ext_auth_success_uri";
static NSString *const kParameterFailUri = @"ext_auth_fail_uri";
static NSString *const kParameterRequestToken = @"request_token";
static NSString *const kParameterMoneySourceToken = @"money_source_token";
static NSString *const kParameterCsc = @"csc";

@interface YMAProcessExternalPaymentRequest ()

@property(nonatomic, copy) NSString *requestId;
@property(nonatomic, copy) NSString *successUri;
@property(nonatomic, copy) NSString *failUri;
@property(nonatomic, assign) BOOL requestToken;
@property(nonatomic, copy) NSString *moneySourceToken;
@property(nonatomic, copy) NSString *csc;

@end

@implementation YMAProcessExternalPaymentRequest

- (id)initWithRequestId:(NSString *)requestId successUri:(NSString *)successUri failUri:(NSString *)failUri requestToken:(BOOL)requestToken moneySourceToken:(NSString *)moneySourceToken andCsc:(NSString *)csc {
    self = [super init];

    if (self) {
        _requestId = [requestId copy];
        _successUri = [successUri copy];
        _failUri = [failUri copy];
        _requestToken = requestToken;
        _moneySourceToken = [moneySourceToken copy];
        _csc = [csc copy];
    }

    return self;
}

+ (instancetype)processExternalPaymentWithRequestId:(NSString *)requestId successUri:(NSString *)successUri failUri:(NSString *)failUri requestToken:(BOOL)requestToken {
    return [[YMAProcessExternalPaymentRequest alloc] initWithRequestId:requestId successUri:successUri failUri:failUri requestToken:requestToken moneySourceToken:nil andCsc:nil];
}

+ (instancetype)processExternalPaymentWithRequestId:(NSString *)requestId successUri:(NSString *)successUri failUri:(NSString *)failUri moneySourceToken:(NSString *)moneySourceToken andCsc:(NSString *)csc {
    return [[YMAProcessExternalPaymentRequest alloc] initWithRequestId:requestId successUri:successUri failUri:failUri requestToken:NO moneySourceToken:moneySourceToken andCsc:csc];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSURL *)requestUrl {
    //TODO use EPR API urls
    return [NSURL URLWithString:kUrlProcessExternalPayment];
}

- (NSDictionary *)parameters {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:self.requestId forKey:kParameterRequestId];
    [dictionary setObject:self.successUri forKey:kParameterSuccessUri];
    [dictionary setObject:self.failUri forKey:kParameterFailUri];

    if (!self.moneySourceToken) {
        if (self.requestToken)
            [dictionary setObject:@"true"forKey:kParameterRequestToken];

        return dictionary;
    }

    [dictionary setObject:self.moneySourceToken forKeyedSubscript:kParameterMoneySourceToken];
    [dictionary setObject:self.csc forKeyedSubscript:kParameterCsc];

    return dictionary;
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data andCompletionHandler:(YMAResponseHandler)handler {
    return [[YMAProcessExternalPaymentResponse alloc] initWithData:data andCompletionHandler:handler];
}

@end