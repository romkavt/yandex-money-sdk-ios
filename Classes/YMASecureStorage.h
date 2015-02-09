//
// Created by Alexander Mertvetsov on 31.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YMAMoneySourceModel;

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

- (void)saveMoneySource:(YMAMoneySourceModel *)moneySource;

- (void)removeMoneySource:(YMAMoneySourceModel *)moneySource;

- (void)clearSecureStorage;

@end