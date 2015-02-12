//
// Created by Alexander Mertvetsov on 31.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMASecureStorage.h"
#import "YMAMoneySourceModel.h"

NSString *const kKeychainItemValueEmpty = @"";
static NSString *const kKeychainIdInstance = @"instanceKeychainId";
static NSString *const kKeychainMoneySource = @"moneySourceKeychainId";

@interface YMASecureStorage () {
    NSMutableDictionary *_instanceIdQuery;
    NSMutableDictionary *_moneySourceQuery;
}

@property(nonatomic, strong, readonly) NSDictionary *instanceIdQuery;
@property(nonatomic, strong, readonly) NSDictionary *moneySourceQuery;

@end

@implementation YMASecureStorage

#pragma mark -
#pragma mark *** Public methods ***
#pragma mark -

- (void)saveMoneySource:(YMAMoneySourceModel *)moneySource {
    if (!moneySource || [self hasMoneySource:moneySource])
        return;

    NSMutableDictionary *newSource = [NSMutableDictionary dictionary];

    [newSource setObject:kKeychainMoneySource forKey:(__bridge id) kSecAttrGeneric];
    [newSource setObject:[NSString stringWithFormat:@"%li", (long)moneySource.type] forKey:(__bridge id) kSecAttrLabel];
    [newSource setObject:[NSString stringWithFormat:@"%li", (long)moneySource.cardType] forKey:(__bridge id) kSecAttrDescription];
    [newSource setObject:moneySource.moneySourceToken forKey:(__bridge id) kSecValueData];
    [newSource setObject:moneySource.panFragment forKey:(__bridge id) kSecAttrAccount];

    NSMutableDictionary *secItem = [self dictionaryToSecItemFormat:newSource];
    SecItemAdd((__bridge CFDictionaryRef) secItem, NULL);
}

- (void)removeMoneySource:(YMAMoneySourceModel *)moneySource {
    NSMutableDictionary *sourceToRemove = [NSMutableDictionary dictionary];

    [sourceToRemove setObject:moneySource.panFragment forKey:(__bridge id) kSecAttrAccount];
    [sourceToRemove setObject:[NSString stringWithFormat:@"%li", (long)moneySource.type] forKey:(__bridge id) kSecAttrLabel];
    [sourceToRemove setObject:[NSString stringWithFormat:@"%li", (long)moneySource.cardType] forKey:(__bridge id) kSecAttrDescription];
    [sourceToRemove setObject:kKeychainMoneySource forKey:(__bridge id) kSecAttrGeneric];
    [sourceToRemove setObject:(__bridge id) kSecClassGenericPassword forKey:(__bridge id) kSecClass];

    SecItemDelete((__bridge CFDictionaryRef) sourceToRemove);
}

- (void)clearSecureStorage {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:(__bridge id) kSecClassGenericPassword forKey:(__bridge id) kSecClass];
    SecItemDelete((__bridge CFDictionaryRef) dict);
}

#pragma mark -
#pragma mark *** Private methods ***
#pragma mark -

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert {
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    [returnDictionary setObject:(__bridge id) kCFBooleanTrue forKey:(__bridge id) kSecReturnData];
    [returnDictionary setObject:(__bridge id) kSecClassGenericPassword forKey:(__bridge id) kSecClass];

    CFTypeRef itemDataRef = nil;

    if (!SecItemCopyMatching((__bridge CFDictionaryRef) returnDictionary, &itemDataRef)) {
        NSData *data = (__bridge_transfer NSData *) itemDataRef;

        [returnDictionary removeObjectForKey:(__bridge id) kSecReturnData];
        NSString *itemData = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        [returnDictionary setObject:itemData forKey:(__bridge id) kSecValueData];
    }

    return returnDictionary;
}

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert {
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    [returnDictionary setObject:(__bridge id) kSecClassGenericPassword forKey:(__bridge id) kSecClass];
    NSString *secDataString = [dictionaryToConvert objectForKey:(__bridge id) kSecValueData];
    [returnDictionary setObject:[secDataString dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id) kSecValueData];

    return returnDictionary;
}

- (CFTypeRef)performQuery:(NSDictionary *)query {
    CFTypeRef outDictionaryRef = NULL;

    if (SecItemCopyMatching((__bridge CFDictionaryRef) query, &outDictionaryRef) == errSecSuccess)
        return outDictionaryRef;

    return NULL;
}

- (BOOL)hasMoneySource:(YMAMoneySourceModel *)moneySource {
    for (YMAMoneySourceModel *source in self.moneySources) {
        if ([source.panFragment isEqual:moneySource.panFragment])
            return YES;
    }

    return NO;
}

#pragma mark -
#pragma mark *** Getters and setters ***
#pragma mark -

- (NSDictionary *)instanceIdQuery {
    if (!_instanceIdQuery) {
        _instanceIdQuery = [[NSMutableDictionary alloc] init];
        [_instanceIdQuery setObject:(__bridge id) kSecClassGenericPassword forKey:(__bridge id) kSecClass];
        [_instanceIdQuery setObject:kKeychainIdInstance forKey:(__bridge id) kSecAttrGeneric];
        [_instanceIdQuery setObject:(__bridge id) kSecMatchLimitOne forKey:(__bridge id) kSecMatchLimit];
        [_instanceIdQuery setObject:(__bridge id) kCFBooleanTrue forKey:(__bridge id) kSecReturnAttributes];
    }

    return _instanceIdQuery;
}

- (NSDictionary *)moneySourceQuery {
    if (!_moneySourceQuery) {
        _moneySourceQuery = [[NSMutableDictionary alloc] init];
        [_moneySourceQuery setObject:(__bridge id) kSecClassGenericPassword forKey:(__bridge id) kSecClass];
        [_moneySourceQuery setObject:kKeychainMoneySource forKey:(__bridge id) kSecAttrGeneric];
        [_moneySourceQuery setObject:(__bridge id) kSecMatchLimitAll
                              forKey:(__bridge id) kSecMatchLimit];
        [_moneySourceQuery setObject:(__bridge id) kCFBooleanTrue forKey:(__bridge id) kSecReturnAttributes];
    }

    return _moneySourceQuery;
}

- (NSArray *)moneySources {
    NSMutableArray *sources = [NSMutableArray array];
    CFArrayRef outArrayRef = [self performQuery:self.moneySourceQuery];

    if (outArrayRef == NULL)
        return sources;

    for (int i = 0; i < CFArrayGetCount(outArrayRef); i++) {
        SecIdentityRef item = (SecIdentityRef) CFArrayGetValueAtIndex(outArrayRef, i);

        NSMutableDictionary *outDictionary = (__bridge_transfer NSMutableDictionary *) item;
        NSDictionary *queryResult = [self secItemFormatToDictionary:outDictionary];

        NSString *panFragment = [queryResult objectForKey:(__bridge id) kSecAttrAccount];
        NSString *sourceTypeString = [queryResult objectForKey:(__bridge id) kSecAttrLabel];
        NSString *cardTypeString = [queryResult objectForKey:(__bridge id) kSecAttrDescription];
        NSString *moneySourceToken = [queryResult objectForKey:(__bridge id) kSecValueData];
        YMAMoneySourceType sourceType = (YMAMoneySourceType) [sourceTypeString integerValue];
        YMAPaymentCardType cardType = (YMAPaymentCardType) [cardTypeString integerValue];

        YMAMoneySourceModel *moneySource = [YMAMoneySourceModel moneySourceWithType:sourceType cardType:cardType panFragment:panFragment moneySourceToken:moneySourceToken];

        [sources addObject:moneySource];
    };

    return sources;
}

- (NSString *)instanceId {
    CFTypeRef outDictionaryRef = [self performQuery:self.instanceIdQuery];

    if (outDictionaryRef != NULL) {
        NSMutableDictionary *outDictionary = (__bridge_transfer NSMutableDictionary *) outDictionaryRef;
        NSDictionary *queryResult = [self secItemFormatToDictionary:outDictionary];

        return [queryResult objectForKey:(__bridge id) kSecValueData];
    }

    return nil;
}

- (void)setInstanceId:(NSString *)instanceId {
    [self clearSecureStorage];
    
    NSMutableDictionary *secItem = [self dictionaryToSecItemFormat:@{(__bridge id) kSecValueData : instanceId}];
    [secItem setObject:kKeychainIdInstance forKey:(__bridge id) kSecAttrGeneric];
    SecItemAdd((__bridge CFDictionaryRef) secItem, NULL);
}

@end