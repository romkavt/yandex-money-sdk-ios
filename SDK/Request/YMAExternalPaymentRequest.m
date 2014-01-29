//
// Created by Александр Мертвецов on 28.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAExternalPaymentRequest.h"
#import "YMAExternalPaymentResponse.h"

static NSString *const kUrlExternalPayment = @"https://money.yandex.ru/api/request-external-payment";
static NSString *const kParameterPatternId = @"pattern_id";

@interface YMAExternalPaymentRequest ()

@property(nonatomic, copy) NSString *patternId;
@property(nonatomic, strong) NSDictionary *paymentParams;

@end

@implementation YMAExternalPaymentRequest

- (id)initWithPatternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams {
    self = [super init];

    if (self) {
        _patternId = [patternId copy];
        _paymentParams = paymentParams;
    }

    return self;
}

+ (instancetype)externalPaymentWithPatternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams {
    return [[YMAExternalPaymentRequest alloc] initWithPatternId:patternId andPaymentParams:paymentParams];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSURL *)requestUrl {
    //TODO use EPR API urls
    return [NSURL URLWithString:kUrlExternalPayment];
}

- (NSDictionary *)parameters {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.paymentParams];
    [dictionary setObject:self.patternId forKey:kParameterPatternId];
    return dictionary;
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data andCompletionHandler:(YMAResponseHandler)handler {
    return [[YMAExternalPaymentResponse alloc] initWithData:data andCompletionHandler:handler];
}

@end