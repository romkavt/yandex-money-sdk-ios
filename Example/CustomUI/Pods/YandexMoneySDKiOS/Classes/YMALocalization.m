//
//  YMALocalization.m
//  ui-cps-sdk-ios
//
//  Created by Alexander Mertvetsov on 06.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMALocalization.h"


static NSBundle *stringBundle = nil;
static NSBundle *imageBundle = nil;

@implementation YMALocalization

+ (NSString *)stringByKey:(NSString *)key {

    if (!stringBundle) {
        NSString *libraryBundlePath = [[NSBundle mainBundle] pathForResource:@"uiymcpssdkios"
                                                                      ofType:@"bundle"];

        NSBundle *libraryBundle = [NSBundle bundleWithPath:libraryBundlePath];
        NSString *langID = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *path = [libraryBundle pathForResource:langID ofType:@"lproj"];
        stringBundle = [NSBundle bundleWithPath:path];

    }

    return [stringBundle localizedStringForKey:key value:@"" table:nil];
}

+ (UIImage *)imageByKey:(NSString *)key {

    if (!imageBundle) {
        NSString *libraryBundlePath = [[NSBundle mainBundle] pathForResource:@"uiymcpssdkios"
                                                                      ofType:@"bundle"];

        imageBundle = [NSBundle bundleWithPath:libraryBundlePath];
    }

    NSString *imagePath = [imageBundle pathForResource:key ofType:@"png"];
    return [UIImage imageWithContentsOfFile:imagePath];
}

@end
