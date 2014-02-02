//
// Created by Александр Мертвецов on 31.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ymcpssdk-ios/ymcpssdk.h>

extern NSString *const kKeychainItemValueEmpty;

@interface YMASecureStorage : NSObject

@property(nonatomic, copy) NSString *instanceId;

@property(nonatomic, copy, readonly) NSArray *moneySources;

- (void)saveMoneySource:(YMAMoneySource *)moneySource;

- (void)removeMoneySource:(YMAMoneySource *)moneySource;

- (void)clearSecureStorage;

@end