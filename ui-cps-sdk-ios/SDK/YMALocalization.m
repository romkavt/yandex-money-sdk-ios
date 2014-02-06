//
//  YMALocalization.m
//  ui-cps-sdk-ios
//
//  Created by Александр Мертвецов on 06.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMALocalization.h"

@implementation YMALocalization

+ (NSString *)stringByKey:(NSString *)key {
    static NSBundle* bundle = nil;
    if (!bundle)
    {
        NSString *libraryBundlePath = [[NSBundle mainBundle] pathForResource:@"uiymcpssdkios"
                                                                      ofType:@"bundle"];
        
        NSBundle *libraryBundle = [NSBundle bundleWithPath:libraryBundlePath];
        NSString *langID        = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *path          = [libraryBundle pathForResource:langID ofType:@"lproj"];
        bundle                  = [NSBundle bundleWithPath:path];
        
    }
    
    return [bundle localizedStringForKey:key value:@"" table:nil];
}

@end
