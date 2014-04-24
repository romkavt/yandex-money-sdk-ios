//
//  YMAConnection.h
//
//  Created by Alexander Mertvetsov on 31.10.13.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^YMAConnectionHandler)(NSURLRequest *request, NSURLResponse *response, NSData *responseData, NSError *error);

@interface YMAConnection : NSObject

@property(nonatomic, copy) NSString *requestMethod;

+ (instancetype)connectionWithUrl:(NSURL *)url;

- (id)initWithUrl:(NSURL *)url;

- (void)sendAsynchronousWithQueue:(NSOperationQueue *)queue
                completionHandler:(YMAConnectionHandler)handler;

- (void)addValue:(NSString *)value forHeader:(NSString *)header;

- (void)addPostParams:(NSDictionary *)postParams;

- (void)addBodyData:(NSData *)bodyData;

@end
