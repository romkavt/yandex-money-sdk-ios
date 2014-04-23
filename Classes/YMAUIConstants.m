//
//  YMAUIConstants.m
//  ui-cps-sdk-ios
//
//  Created by Alexander Mertvetsov on 06.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAUIConstants.h"

CGFloat const kControlHeightDefault = 44.0;
CGFloat const kControlHeightWithTextField = 62.0;
CGFloat const kErrorHeight = 90;

// image keys

NSString *const kImageKeyAmericanExpress = @"am";
NSString *const kImageKeyMasterCard = @"mc";
NSString *const kImageKeyVISA = @"visa";
NSString *const kImageKeyCardAmericanExpress = @"card_ae";
NSString *const kImageKeyCardMasterCard = @"card_mc";
NSString *const kImageKeyCardVISA = @"card_visa";
NSString *const kImageKeyCardDefault = @"card_default";
NSString *const kImageKeyCardNew = @"card_new";
NSString *const kImageKeyCardSuccess = @"card_success";

@implementation YMAUIConstants

#pragma mark -
#pragma mark *** Colors ***
#pragma mark -

+ (UIColor *)defaultBackgroundColor {
    return [UIColor colorWithRed:242.0 / 255.0 green:239.0 / 255.0 blue:237.0 / 255.0 alpha:1.0];
}

+ (UIColor *)separatorColor {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
}


+ (UIColor *)accentTextColor {
    return [UIColor colorWithRed:253.0 / 255.0 green:148.0 / 255.0 blue:38.0 / 255.0 alpha:1.0];
}

+ (UIColor *)commentColor {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

+ (UIColor *)savedCardColor {
    return [UIColor colorWithRed:51.0 / 255.0 green:102.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
}

+ (UIColor *)checkColor {
    return [UIColor colorWithRed:2.0 / 255.0 green:196.0 / 255.0 blue:34.0 / 255.0 alpha:1.0];
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