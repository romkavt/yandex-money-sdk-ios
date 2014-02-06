//
//  YMALocalization.h
//  ui-cps-sdk-ios
//
//  Created by Александр Мертвецов on 06.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YMALocalizedString(key, comment) \
        [YMALocalization stringByKey:(key)]

@interface YMALocalization : NSObject

+ (NSString *)stringByKey:(NSString *)key;

@end
