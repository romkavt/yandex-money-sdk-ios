//
//  YMALocalization.h
//  ui-cps-sdk-ios
//
//  Created by Alexander Mertvetsov on 06.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define YMALocalizedString(key, comment) \
        [YMALocalization stringByKey:(key)]

#define YMALocalizedImage(key, comment) \
        [YMALocalization imageByKey:(key)]

@interface YMALocalization : NSObject

+ (NSString *)stringByKey:(NSString *)key;

+ (UIImage *)imageByKey:(NSString *)key;

@end
