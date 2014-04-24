//
// Created by Alexander Mertvetsov on 29.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

///
/// This class contains info about redirect to authorization page (url, params).
///
@interface YMAAsc : NSObject

/// Constructor. Returns a YMAAsc with the specified url and authorization parameters.
/// @param url - Address authorization page. If the field is present to complete the transaction
/// requires authorization (credit card page / or 3D-Secure).
/// @param params - Authorization parameters in the format collection name-value pairs.
/// If the field is present to complete the transaction requires authorization
/// (form DC and / or 3D-Secure).
+ (instancetype)ascWithUrl:(NSURL *)url andParams:(NSDictionary *)params;

@property(nonatomic, strong, readonly) NSURL *url;
@property(nonatomic, strong, readonly) NSDictionary *params;

@end