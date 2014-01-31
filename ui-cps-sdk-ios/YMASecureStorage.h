//
// Created by Александр Мертвецов on 31.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ymcpssdk-ios/ymcpssdk.h>

@interface YMASecureStorage : NSObject

@property(nonatomic, copy) NSString *instanceId;

@property(nonatomic, assign) NSUInteger moneySourcesCount;

- (void)saveMoneySource:(YMAMoneySource *)moneySource withIdentifier:(NSString *)identifier;

- (YMAMoneySource *)moneySourceByIdentifier:(NSString *)identifier;

- (void)removeMoneySourceByIdentifier:(NSString *)identifier;

- (void)removeAllMoneySource;

@end