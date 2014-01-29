//
// Created by Александр Мертвецов on 28.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseResponse.h"

@interface YMAExternalPaymentResponse : YMABaseResponse

@property(nonatomic, copy, readonly) NSString *requestId;

@end