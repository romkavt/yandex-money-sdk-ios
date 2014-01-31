//
//  YMAKeychainItemWrapper.m
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 30.01.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAKeychainItemWrapper.h"

@interface YMAKeychainItemWrapper ()

@property (nonatomic, strong) NSMutableDictionary *keychainItemData;
@property (nonatomic, strong) NSMutableDictionary *genericPasswordQuery;

@end

@implementation YMAKeychainItemWrapper

- (id)initWithIdentifier:(NSString *)identifier
{
    if (self = [super init])
    {
        _genericPasswordQuery = [[NSMutableDictionary alloc] init];
		[_genericPasswordQuery setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [_genericPasswordQuery setObject:identifier forKey:(__bridge id)kSecAttrGeneric];
        [_genericPasswordQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
        [_genericPasswordQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
        
        NSDictionary *tempQuery = [NSDictionary dictionaryWithDictionary:_genericPasswordQuery];
        CFTypeRef outDictionaryRef = nil;
        
        if (SecItemCopyMatching((__bridge CFDictionaryRef)tempQuery, (CFTypeRef *)&outDictionaryRef))
        {
            [self resetKeychainItem];
			[_keychainItemData setObject:identifier forKey:(__bridge id)kSecAttrGeneric];
		}
        else
        {
            NSMutableDictionary *outDictionary = (__bridge_transfer NSMutableDictionary*)outDictionaryRef;
            self.keychainItemData = [self secItemFormatToDictionary:outDictionary];
        }
    }
    
	return self;
}

- (id)itemValue
{
    return [_keychainItemData objectForKey:(__bridge id)kSecValueData];
}

- (void)setItemvalue:(id)itemvalue
{
    if (itemvalue == nil) return;
    id currentObject = [_keychainItemData objectForKey:(__bridge id)kSecValueData];
    if (![currentObject isEqual:itemvalue])
    {
        [_keychainItemData setObject:itemvalue forKey:(__bridge id)kSecValueData];
        [self writeToKeychain];
    }
}

- (void)resetKeychainItem
{
    if (_keychainItemData)
    {
        NSMutableDictionary *tempDictionary = [self dictionaryToSecItemFormat:_keychainItemData];
		SecItemDelete((__bridge CFDictionaryRef)tempDictionary);
    }
    else
        self.keychainItemData = [[NSMutableDictionary alloc] init];
    
    [_keychainItemData setObject:@"" forKey:(__bridge id)kSecAttrAccount];
    [_keychainItemData setObject:@"" forKey:(__bridge id)kSecAttrLabel];
    [_keychainItemData setObject:@"" forKey:(__bridge id)kSecAttrDescription];
    [_keychainItemData setObject:@"" forKey:(__bridge id)kSecValueData];
}

#pragma mark -
#pragma mark *** Private methods ***
#pragma mark -

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert
{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    [returnDictionary setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [returnDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    CFTypeRef passwordDataRef = nil;
    
    if (!SecItemCopyMatching((__bridge CFDictionaryRef)returnDictionary, (CFTypeRef *)&passwordDataRef))
    {
        NSData *passwordData = (__bridge_transfer NSData*)passwordDataRef;
        
        [returnDictionary removeObjectForKey:(__bridge id)kSecReturnData];
        NSString *password = [[NSString alloc] initWithBytes:[passwordData bytes] length:[passwordData length] encoding:NSUTF8StringEncoding];
        [returnDictionary setObject:password forKey:(__bridge id)kSecValueData];
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

- (void)writeToKeychain
{
    CFTypeRef attributesRef = nil;
    
    if (!SecItemCopyMatching((__bridge CFDictionaryRef)_genericPasswordQuery, (CFTypeRef *)&attributesRef))
    {
        NSDictionary *attributes = (__bridge_transfer NSDictionary*)attributesRef;
        
        NSMutableDictionary *updateItem = [NSMutableDictionary dictionaryWithDictionary:attributes];
        [updateItem setObject:[_genericPasswordQuery objectForKey:(__bridge id)kSecClass] forKey:(__bridge id)kSecClass];
        NSMutableDictionary *tempCheck = [self dictionaryToSecItemFormat:_keychainItemData];
        [tempCheck removeObjectForKey:(__bridge id)kSecClass];
		
#if TARGET_IPHONE_SIMULATOR
		[tempCheck removeObjectForKey:(__bridge id)kSecAttrAccessGroup];
#endif
        
        SecItemUpdate((__bridge CFDictionaryRef)updateItem, (__bridge CFDictionaryRef)tempCheck);
    }
    else
        SecItemAdd((__bridge CFDictionaryRef)[self dictionaryToSecItemFormat:_keychainItemData], NULL);
}


@end
