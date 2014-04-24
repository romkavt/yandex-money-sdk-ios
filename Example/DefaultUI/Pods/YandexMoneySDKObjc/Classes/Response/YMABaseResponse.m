//
//  YMABaseResponse.m
//
//  Created by Alexander Mertvetsov on 01.11.13.
//  Copyright (c) 2013 Yandex.Money. All rights reserved.
//

#import "YMABaseResponse.h"
#import "YMAConstants.h"

static NSInteger const kResponseParseErrorCode = 2503;
static NSString *const kResponseStatusKeyRefused = @"refused";
static NSString *const kResponseStatusKeyInProgress = @"in_progress";
static NSString *const kResponseStatusKeyExtAuthRequired = @"ext_auth_required";
static NSString *const kParameterStatus = @"status";
static NSString *const kParameterError = @"error";
static NSString *const kParameterNextRetry = @"next_retry";

@interface YMABaseResponse ()

@property(nonatomic, copy) YMAResponseHandler handler;
@property(nonatomic, retain) NSData *data;

@end

@implementation YMABaseResponse

- (id)initWithData:(NSData *)data andCompletion:(YMAResponseHandler)block {
    self = [self init];

    if (self) {
        _data = data;
        _handler = [block copy];
        _nextRetry = 0;
    }

    return self;
}

#pragma mark -
#pragma mark *** NSOperation ***
#pragma mark -

- (void)main {

    NSError *error;

    @try {

        id responseModel = [NSJSONSerialization JSONObjectWithData:_data options:(NSJSONReadingOptions) kNilOptions error:&error];

        if (error) {
            self.handler(self, error);
            return;
        }

        NSString *statusKey = [responseModel objectForKey:kParameterStatus];

        if ([statusKey isEqual:kResponseStatusKeyRefused]) {
            NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"response" : self}];

            NSString *errorKey = [responseModel objectForKey:kParameterError];
            _status = YMAResponseStatusRefused;

            self.handler(self, errorKey ? [NSError errorWithDomain:errorKey code:0 userInfo:@{@"response" : self}] : unknownError);
            return;
        }

        if ([statusKey isEqual:kResponseStatusKeyInProgress]) {
            NSString *nextRetryString = [responseModel objectForKey:kParameterNextRetry];
            _nextRetry = (NSUInteger) [nextRetryString integerValue];
            _status = YMAResponseStatusInProgress;
        } else
            _status = [statusKey isEqual:kResponseStatusKeyExtAuthRequired] ? YMAResponseStatusExtAuthRequired : YMAResponseStatusSuccess;

        [self parseJSONModel:responseModel];
        self.handler(self, nil);
    }
    @catch (NSException *exception) {
        self.handler(self, [NSError errorWithDomain:exception.name code:kResponseParseErrorCode userInfo:exception.userInfo]);
    }
}

- (void)parseJSONModel:(id)responseModel {
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

@end
