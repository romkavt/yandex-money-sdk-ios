//
//  YMACpsManager.m
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 30.01.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMACpsManager.h"

NSString *const kSuccessUrl = @"yandexmoneyapp://oauth/authorize/success";
NSString *const kFailUrl = @"yandexmoneyapp://oauth/authorize/fail";

@interface YMACpsManager ()

@property(nonatomic, copy) NSString *clientId;
@property(nonatomic, strong) YMASecureStorage *secureStorage;
@property(nonatomic, strong, readonly) YMASession *session;

@end

@implementation YMACpsManager

- (id)initWithClientId:(NSString *)clientId {
    self = [super init];

    if (self) {
        _clientId = [clientId copy];
        _secureStorage = [[YMASecureStorage alloc] init];
        _session = [[YMASession alloc] init];
    }

    return self;
}

#pragma mark -
#pragma mark *** Public methods ***
#pragma mark -

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

- (void)saveMoneySourceWithRequestId:(NSString *)requestId completion:(YMAMoneySourceHandler)block {
    YMABaseRequest *moneySourceRequest = [YMAProcessExternalPaymentRequest processExternalPaymentWithRequestId:requestId successUri:kSuccessUrl failUri:kFailUrl requestToken:YES];

    [self processPaymentRequest:moneySourceRequest completion:^(YMABaseRequest *request, YMABaseResponse *response, NSError *error) {
        if (error) {
            block(nil, error);
            return;
        }

        NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"request" : request, @"response" : response}];

        if (response.status == YMAResponseStatusSuccess) {
            YMAProcessExternalPaymentResponse *processExternalPaymentResponse = (YMAProcessExternalPaymentResponse *) response;
            YMAMoneySource *moneySource = processExternalPaymentResponse.moneySource;

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.secureStorage saveMoneySource:moneySource];
            });

            block(moneySource, moneySource ? nil : unknownError);
        } else
            block(nil, unknownError);
    }];
}

- (void)removeMoneySource:(YMAMoneySource *)moneySource {
    [self.secureStorage removeMoneySource:moneySource];
}

- (void)startPaymentWithPatternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams completion:(YMAStartPaymentHandler)block {
    YMABaseRequest *externalPaymentRequest = [YMAExternalPaymentRequest externalPaymentWithPatternId:patternId andPaymentParams:paymentParams];

    [self.session performRequest:externalPaymentRequest completion:^(YMABaseRequest *request, YMABaseResponse *response, NSError *error) {
        if (error) {
            block(nil, error);
            return;
        }

        YMAExternalPaymentResponse *externalPaymentResponse = (YMAExternalPaymentResponse *) response;
        block(externalPaymentResponse.paymentRequestInfo, nil);
    }];
}

- (void)finishPaymentWithRequestId:(NSString *)requestId completion:(YMAFinishPaymentHandler)block {
    YMABaseRequest *processExternalPaymentRequest = [YMAProcessExternalPaymentRequest processExternalPaymentWithRequestId:requestId successUri:kSuccessUrl failUri:kFailUrl requestToken:NO];

    [self finishPaymentWithRequest:processExternalPaymentRequest completion:block];
}

- (void)finishPaymentWithRequestId:(NSString *)requestId moneySourceToken:(NSString *)moneySourceToken andCsc:(NSString *)csc completion:(YMAFinishPaymentHandler)block {
    YMABaseRequest *processExternalPaymentRequest = [YMAProcessExternalPaymentRequest processExternalPaymentWithRequestId:requestId successUri:kSuccessUrl failUri:kFailUrl moneySourceToken:moneySourceToken andCsc:csc];

    [self finishPaymentWithRequest:processExternalPaymentRequest completion:block];
}

#pragma mark -
#pragma mark *** Private methods ***
#pragma mark -

- (void)finishPaymentWithRequest:(YMABaseRequest *)paymentRequest completion:(YMAFinishPaymentHandler)block {
    [self processPaymentRequest:paymentRequest completion:^(YMABaseRequest *request, YMABaseResponse *response, NSError *error) {
        if (error) {
            block(nil, error);
            return;
        }

        NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"request" : request, @"response" : response}];

        if (response.status == YMAResponseStatusSuccess)
            block(nil, nil);
        else if (response.status == YMAResponseStatusExtAuthRequired) {
            YMAProcessExternalPaymentResponse *processExternalPaymentResponse = (YMAProcessExternalPaymentResponse *) response;
            YMAAsc *asc = processExternalPaymentResponse.asc;

            block(asc, asc ? nil : unknownError);
        } else
            block(nil, unknownError);
    }];
}

- (void)processPaymentRequest:(YMABaseRequest *)paymentRequest completion:(YMARequestHandler)block {
    [self.session performRequest:paymentRequest completion:^(YMABaseRequest *request, YMABaseResponse *response, NSError *error) {
        if (response.status == YMAResponseStatusInProgress) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, response.nextRetry);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                [self processPaymentRequest:request completion:block];
            });
        } else
            block(request, response, error);
    }];
}

#pragma mark -
#pragma mark *** Getters and setters ***
#pragma mark -

- (NSArray *)moneySources {
    return self.secureStorage.moneySources;
}

@end
