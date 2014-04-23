//
//  YMABaseRequest.m
//
//  Created by Alexander Mertvetsov on 01.11.13.
//  Copyright (c) 2013 Yandex.Money. All rights reserved.
//

#import "YMABaseRequest.h"
#import "YMABaseResponse.h"
#import "YMAConstants.h"

@implementation YMABaseRequest

- (void)buildResponseWithData:(NSData *)data queue:(NSOperationQueue *)queue andCompletion:(YMARequestHandler)block {
    NSOperation *operation = [self buildResponseOperationWithData:data andCompletionHandler:^(YMABaseResponse *response, NSError *error) {
        block(self, response, error);
    }];

    if (!operation) {
        block(self, nil, [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:nil]);
        return;
    }

    [queue addOperation:operation];
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data andCompletionHandler:(YMAResponseHandler)handler {
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

@end
