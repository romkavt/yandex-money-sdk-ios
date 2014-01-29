//
// Created by Александр Мертвецов on 29.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YMAAsc : NSObject

+ (instancetype)ascWithUrl:(NSURL *)url andParams:(NSDictionary *)params;

@property(nonatomic, strong, readonly) NSURL *url;
@property(nonatomic, strong, readonly) NSDictionary *params;

@end