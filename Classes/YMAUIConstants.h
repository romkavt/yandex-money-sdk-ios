//
//  YMATools.h
//  ui-cps-sdk-ios
//
//  Created by Alexander Mertvetsov on 06.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMALocalization.h"

extern CGFloat const kControlHeightDefault;
extern CGFloat const kControlHeightWithTextField;
extern CGFloat const kErrorHeight;

// image keys

extern NSString *const kImageKeyAmericanExpress;
extern NSString *const kImageKeyMasterCard;
extern NSString *const kImageKeyVISA;
extern NSString *const kImageKeyCardAmericanExpress;
extern NSString *const kImageKeyCardMasterCard;
extern NSString *const kImageKeyCardVISA;
extern NSString *const kImageKeyCardDefault;
extern NSString *const kImageKeyCardNew;
extern NSString *const kImageKeyCardSuccess;

@interface YMAUIConstants : NSObject

#pragma mark -
#pragma mark *** Colors ***
#pragma mark -

+ (UIColor *)defaultBackgroundColor;

+ (UIColor *)separatorColor;

+ (UIColor *)accentTextColor;

+ (UIColor *)commentColor;

+ (UIColor *)savedCardColor;

+ (UIColor *)checkColor;

#pragma mark -
#pragma mark *** Fonts ***
#pragma mark -

+ (UIFont *)titleFont;

+ (UIFont *)commentFont;

+ (UIFont *)commentTitleFont;

+ (UIFont *)buttonFont;

@end
