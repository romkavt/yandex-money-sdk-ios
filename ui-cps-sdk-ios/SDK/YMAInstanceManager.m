//
//  YMAInstanceManager.m
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 30.01.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAInstanceManager.h"
#import "YMASecureStorage.h"

static NSString *const kSuccessUrl = @"yandexmoneyapp://oauth/authorize/success";
static NSString *const kFailUrl = @"yandexmoneyapp://oauth/authorize/fail";

@interface YMAInstanceManager ()

@property(nonatomic, copy) NSString *clientId;
@property(nonatomic, strong) YMASecureStorage *secureStorage;

@end

@implementation YMAInstanceManager

- (id)initWithClientId:(NSString *)clientId {
    self = [super init];

    if (self) {
        _clientId = [clientId copy];
        _secureStorage = [[YMASecureStorage alloc] init];
        _session = [[YMASession alloc] init];
    }

    return self;
}

- (void)updateInstanceWithCompletion:(YMAHandler)block {
    NSString *instanceId = self.secureStorage.instanceId;

    if (!instanceId || [instanceId isEqual:kKeychainItemValueEmpty]) {
        [self.session authorizeWithClientId:self.clientId completion:^(NSString *newInstanceId, NSError *error) {
            if (error)
                block(error);
            else {
                self.secureStorage.instanceId = newInstanceId;
                block(nil);
            }
        }];

        return;
    }

    self.session.instanceId = instanceId;
    block(nil);
}

- (void)saveMoneySourceWithRequestId:(NSString *)requestId complition:(YMAMoneySourceHandler)block {
    YMABaseRequest *request = [YMAProcessExternalPaymentRequest processExternalPaymentWithRequestId:requestId successUri:kSuccessUrl failUri:kFailUrl requestToken:YES];
    [self processExternalPaymentRequest:request complition:block];
}

- (void)removeMoneySource:(YMAMoneySource *)moneySource {
    [self.secureStorage removeMoneySource:moneySource];
}

- (void)processExternalPaymentRequest:(YMABaseRequest *)paymentRequest complition:(YMAMoneySourceHandler)block {
    [self.session performRequest:paymentRequest completion:^(YMABaseRequest *request, YMABaseResponse *response, NSError *error) {
        NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"request" : request, @"response" : response}];

        if (response.status == YMAResponseStatusSuccess) {
            YMAProcessExternalPaymentResponse *processExternalPaymentResponse = (YMAProcessExternalPaymentResponse *) response;
            YMAMoneySource *moneySource = processExternalPaymentResponse.moneySource;

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.secureStorage saveMoneySource:moneySource];
            });

            block(moneySource, moneySource ? nil : unknownError);
        } else if (response.status == YMAResponseStatusInProgress) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, response.nextRetry * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                [self processExternalPaymentRequest:request complition:block];
            });
        } else
            block(nil, unknownError);
    }];
}

- (NSArray *)moneySources {
    return self.secureStorage.moneySources;
}

@end
