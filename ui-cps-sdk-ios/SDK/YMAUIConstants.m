//
//  YMAUIConstants.m
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 06.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAUIConstants.h"

CGFloat const kCellHeightDefault = 44.0;
CGFloat const kCellHeightWithTextField = 62.0;
CGFloat const kErrorHeight = 100;

// image keys

NSString *const kImageKeyAmericanExpress = @"am";
NSString *const kImageKeyMasterCard = @"mc";
NSString *const kImageKeyVISA = @"visa";

@implementation YMAUIConstants

#pragma mark -
#pragma mark *** Colors ***
#pragma mark -

+ (UIColor *)defaultBackgroungColor {
    return [UIColor colorWithRed:242.0/255.0 green:239.0/255.0 blue:237.0/255.0 alpha:1.0];
}

+ (UIColor *)separatorColor {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha: 0.1];
}


+ (UIColor *)accentTextColor {
    return [UIColor colorWithRed:253.0/255.0 green:148.0/255.0 blue:38.0/255.0 alpha:1.0];
}

+ (UIColor *)commentColor {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

#pragma mark -
#pragma mark *** Fonts ***
#pragma mark -

+ (UIFont *)titleFont {
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:42];
}

+ (UIFont *)commentFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:14];
}

+ (UIFont *)commentTitleFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:17];
}

+ (UIFont *)buttonFont {
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
}

@end