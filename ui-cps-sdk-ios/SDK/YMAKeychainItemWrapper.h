//
//  YMAKeychainItemWrapper.h
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 30.01.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMAKeychainItemWrapper : NSObject

@property (nonatomic, readwrite) id itemValue;

- (id)initWithIdentifier:(NSString *)identifier;
- (void)resetKeychainItem;

@end
