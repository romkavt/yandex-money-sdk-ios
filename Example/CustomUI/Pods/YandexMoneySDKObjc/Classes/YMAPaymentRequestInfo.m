//
//  YMAPaymentRequestInfo.m
//  cps-sdk
//
//  Created by Alexander Mertvetsov on 10.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAPaymentRequestInfo.h"

@implementation YMAPaymentRequestInfo

- (id)initPaymentRequestInfoWithId:(NSString *)requestId amount:(NSString *)amount andTitle:(NSString *)title {
    self = [super init];
    
    if (self) {
        _requestId = [requestId copy];
        _amount = [amount copy];
        _title = [title copy];
    }
    
    return self;
}

+ (instancetype)paymentRequestInfoWithId:(NSString *)requestId amount:(NSString *)amount andTitle:(NSString *)title {
    return [[YMAPaymentRequestInfo alloc] initPaymentRequestInfoWithId:requestId amount:amount andTitle:title];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
            @{
              @"requestId" : self.requestId,
              @"amount" : self.amount,
              @"title" : self.title
              }];
}

@end
