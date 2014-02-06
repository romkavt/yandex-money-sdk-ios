//
//  YMATools.h
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 06.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMALocalization.h"

extern CGFloat const kCellHeightDefault;
extern CGFloat const kCellHeightWithTextField;

// image keys

extern NSString *const kImageKeyAmericanExpress;
extern NSString *const kImageKeyMasterCard;
extern NSString *const kImageKeyVISA;

@interface YMAUIConstants : NSObject 

+ (UIColor *)defaultBackgroungColor;

+ (UIColor *)accentTextColor;

@end
