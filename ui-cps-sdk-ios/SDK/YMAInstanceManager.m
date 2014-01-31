//
//  YMAInstanceManager.m
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 30.01.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAInstanceManager.h"
#import "YMAKeychainItemWrapper.h"

static NSString* const kInstanceKeychainId = @"instanceKeychainId";

@interface YMAInstanceManager ()

@property(nonatomic, copy) NSString *clientId;
@property(nonatomic, strong) YMAKeychainItemWrapper *instanceId;
@property(nonatomic, strong) YMASession *session;

@end

@implementation YMAInstanceManager

- (id)initWithClientId:(NSString *)clientId {
    self = [super init];
    
    if (self) {
        _clientId = [clientId copy];
        _instanceId = [[YMAKeychainItemWrapper alloc] initWithIdentifier:kInstanceKeychainId];
        _session = [[YMASession alloc] init];
    }
    
    return self;
}

- (void)updateInstanceWithCompletion:(YMAHandler)block {
    if ([self.instanceId.itemValue isEqual:kKeychainItemValueEmpty]) {
        [self.session authorizeWithClientId:self.clientId completion:^(NSString *instanceId, NSError *error) {
            if (error)
                block(error);
            else {
                self.instanceId.itemValue = instanceId;
                block(nil);
            }
        }];
        
        return;
    }
    
    self.session.instanceId = self.instanceId.itemValue;
    block(nil);
}

- (void)processPaymentWithParams:(NSDictionary *)paymentParams completion:(YMAPaymentSuccessHandler)block {
    
}

- (void)processPaymentWithParams:(NSDictionary *)paymentParams moneySourceToken:(NSString *)moneySourceToken csc:(NSString *)csc completion:(YMAHandler)block {
    
}

- (void)saveMoneySourceWithRequestId:(NSString *)requestId complition:(YMAMoneySourceHandler)block {
    
}

@end
