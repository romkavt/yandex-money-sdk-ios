//
// Created by Александр Мертвецов on 28.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAExternalPaymentResponse.h"

static NSString *const kParameterRequestId = @"request_id";

@implementation YMAExternalPaymentResponse

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (void)parseJSONModel:(id)responseModel {
    _requestId = [responseModel objectForKey:kParameterRequestId];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"requestId" : self.requestId
                                      }];
}

@end