//
// Created by Александр Мертвецов on 31.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMASecureStorage.h"

NSString *const kKeychainItemValueEmpty = @"";
static NSString *const kKeychainIdInstance = @"instanceKeychainId";

@interface YMASecureStorage () {
    NSMutableDictionary *_instanceIdQuery;
}

@property(nonatomic, strong, readonly) NSDictionary *instanceIdQuery;

@end

@implementation YMASecureStorage

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert
{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    [returnDictionary setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [returnDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];

    CFTypeRef itemDataRef = nil;

    if (!SecItemCopyMatching((__bridge CFDictionaryRef)returnDictionary, &itemDataRef))
    {
        NSData *passwordData = (__bridge_transfer NSData*)itemDataRef;

        [returnDictionary removeObjectForKey:(__bridge id)kSecReturnData];
        NSString *itemData = [[NSString alloc] initWithBytes:[passwordData bytes] length:[passwordData length] encoding:NSUTF8StringEncoding];
        [returnDictionary setObject:itemData forKey:(__bridge id)kSecValueData];
    }

    return returnDictionary;
}

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert
{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    [returnDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    NSString *passwordString = [dictionaryToConvert objectForKey:(__bridge id)kSecValueData];
    [returnDictionary setObject:[passwordString dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];

    return returnDictionary;
}


- (NSMutableDictionary *)performQuery:(NSDictionary *)query {
    CFTypeRef outDictionaryRef = nil;

    if (SecItemCopyMatching((__bridge CFDictionaryRef) query, &outDictionaryRef) == errSecSuccess) {
        NSMutableDictionary *outDictionary = (__bridge_transfer NSMutableDictionary *) outDictionaryRef;
        return [self secItemFormatToDictionary:outDictionary];
    }

    return nil;
}

- (void)writeToKeychain:(NSDictionary *)value withQuery:(NSDictionary *)query
{
    CFTypeRef attributesRef = nil;

    if (SecItemCopyMatching((__bridge CFDictionaryRef)query, &attributesRef) == errSecSuccess)
    {
        NSDictionary *attributes = (__bridge_transfer NSDictionary*)attributesRef;

        NSMutableDictionary *updateItem = [NSMutableDictionary dictionaryWithDictionary:attributes];
        [updateItem setObject:[query objectForKey:(__bridge id)kSecClass] forKey:(__bridge id)kSecClass];
        NSMutableDictionary *secItem = [self dictionaryToSecItemFormat:value];
        [secItem removeObjectForKey:(__bridge id)kSecClass];

#if TARGET_IPHONE_SIMULATOR
		[secItem removeObjectForKey:(__bridge id)kSecAttrAccessGroup];
#endif

        SecItemUpdate((__bridge CFDictionaryRef)updateItem, (__bridge CFDictionaryRef)secItem);
    }
    else
        SecItemAdd((__bridge CFDictionaryRef)[self dictionaryToSecItemFormat:value], NULL);
}


#pragma mark -
#pragma mark *** Getters and setters ***
#pragma mark -

- (NSDictionary *)instanceIdQuery {
    if (!_instanceIdQuery) {
        _instanceIdQuery = [NSMutableDictionary dictionary];
        [_instanceIdQuery setObject:(__bridge id) kSecClassGenericPassword forKey:(__bridge id) kSecClass];
        [_instanceIdQuery setObject:kKeychainIdInstance forKey:(__bridge id) kSecAttrGeneric];
        [_instanceIdQuery setObject:(__bridge id) kSecMatchLimitOne forKey:(__bridge id) kSecMatchLimit];
        [_instanceIdQuery setObject:(__bridge id) kCFBooleanTrue forKey:(__bridge id) kSecReturnAttributes];
    }

    return _instanceIdQuery;
}

- (NSString *)instanceId {
    NSDictionary *queryResult = [self performQuery:self.instanceIdQuery];
    return (queryResult) ? [queryResult objectForKey:(__bridge id)kSecValueData] : nil;
}

- (void)setInstanceId:(NSString *)instanceId {
    NSMutableDictionary *queryResult = [self performQuery:self.instanceIdQuery];

    if (!queryResult) {
        queryResult = [NSMutableDictionary dictionary];
    } else if ([[queryResult objectForKey:(__bridge id) kSecValueData] isEqual:instanceId])
        return;

    [queryResult setObject:instanceId forKey:(__bridge id)kSecValueData];
    [self writeToKeychain:queryResult withQuery:self.instanceIdQuery];
}

@end