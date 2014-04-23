//
// Created by Alexander Mertvetsov on 31.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ymcpssdk.h>

/// Empry string
extern NSString *const kKeychainItemValueEmpty;

///
/// KeyChain wrapper for storing money sources and instanceId.
///
@interface YMASecureStorage : NSObject

/// ID of an installed copy of the application. Used when you perform requests as parameter.
@property(nonatomic, copy) NSString *instanceId;
/// Info about the money sources (Information about the credit cards)
@property(nonatomic, copy, readonly) NSArray *moneySources;

- (void)saveMoneySource:(YMAMoneySource *)moneySource;

- (void)removeMoneySource:(YMAMoneySource *)moneySource;

- (void)clearSecureStorage;

@end