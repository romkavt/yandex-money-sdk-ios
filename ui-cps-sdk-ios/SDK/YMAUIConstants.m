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

// image keys

NSString *const kImageKeyAmericanExpress = @"am";
NSString *const kImageKeyMasterCard = @"mc";
NSString *const kImageKeyVISA = @"visa";

@implementation YMAUIConstants

+ (UIColor *)defaultBackgroungColor {
    return [UIColor colorWithRed:242.0/255.0 green:239.0/255.0 blue:237.0/255.0 alpha:1.0];
}

+ (UIColor *)accentTextColor {
    return [UIColor colorWithRed:253.0/255.0 green:148.0/255.0 blue:38.0/255.0 alpha:1.0];
}

@end