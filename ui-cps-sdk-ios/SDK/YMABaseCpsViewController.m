//
//  YMABaseCpsViewController.m
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 04.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMABaseCpsViewController.h"

@interface YMABaseCpsViewController ()<YMABaseResultViewDelegate> {
    YMACpsManager *_cpsManager;
    UIWebView *_webView;
}

@property(nonatomic, copy) NSString *clientId;
@property(nonatomic, strong) NSDictionary *paymentParams;
@property(nonatomic, copy) NSString *patternId;
@property(nonatomic, copy) NSString *requestId;
@property(nonatomic, strong) YMABaseResultView *resultView;

@end

@implementation YMABaseCpsViewController

- (id)init {
    NSString *reason = [NSString stringWithFormat:@"please use initWithClintId:andPaymentParams: instead %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSString *reason = [NSString stringWithFormat:@"please use initWithClintId:andPaymentParams: instead %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (id)initWithClintId:(NSString *)clientId patternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams {
    self = [super init];
    
    if (self) {
        _clientId = [clientId copy];
        _paymentParams = paymentParams;
        _patternId = [patternId copy];
    }
    
    return self;
}

#pragma mark -
#pragma mark *** UIViewController methods ***
#pragma mark -

- (void)viewDidLoad {
    [self.cpsManager updateInstanceWithCompletion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showError:error];
        });
    }];
    
    [self startPayment];
}

- (void)viewDidAppear:(BOOL)animated {
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (void)showError:(NSError *)error {
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (YMABaseMoneySourcesView *)moneySourcesViewWithSources:(NSArray *)sources {
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (YMABaseCscView *)cscView {
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (YMABaseResultView *)resultViewWithState:(YMAPaymentResultState)state {
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (void)startPayment {
    [self.cpsManager startPaymentWithPatternId:self.patternId andPaymentParams:self.paymentParams completion:^(NSString *requestId, NSError *error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showError:error];
            });
        } else {
            self.requestId = requestId;
            if (!self.cpsManager.moneySources.count)
                [self processPaymentWithNewCard];
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self processPaymentWithExistCard];
                });
            }
        }
    }];
}

- (void)processPaymentWithNewCard {
    [self.cpsManager finishPaymentWithRequestId:self.requestId completion:^(YMAAsc *asc, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
                [self showError:error];
            else if (asc)
                [self loadInWebViewFormAsc:asc];
            else
                [self showSuccessView];
        });
    }];
}

- (void)processPaymentWithExistCard {
    
}

- (void)loadInWebViewFormAsc:(YMAAsc *)asc {
    
    NSMutableString *post = [NSMutableString string];
    
    for (NSString *key in asc.params.allKeys) {
        NSString *paramValue = [[asc.params objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *paramKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [post appendString:[NSString stringWithFormat:@"%@=%@&", paramKey, paramValue]];
    }
    
    [post deleteCharactersInRange:NSMakeRange(post.length - 1, 1)];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:asc.url];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    if (!self.webView.superview)
        [self.view addSubview:self.webView];
    [self.webView loadRequest:request];
}

- (void)showSuccessView {
    
}

- (void)showFailView {
    self.resultView = [self resultViewWithState:YMAPaymentResultStateFail];
    [self.view addSubview:self.resultView];
}

#pragma mark -
#pragma mark *** UIWebViewDelegate method ***
#pragma mark -

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (![request URL])
        return NO;
    
    NSString *urlString = [[request URL] absoluteString];
    
    if ([urlString isEqual:kSuccessUrl]) {
        [self processPaymentWithNewCard];
        [webView removeFromSuperview];
        return NO;
    }
    
    if ([urlString isEqual:kFailUrl]) {
        [self showFailView];
        [webView removeFromSuperview];
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark *** Getters and setters ***
#pragma mark -

- (void)setResultView:(YMABaseResultView *)resultView {
    if (_resultView) {
        _resultView.delegate = nil;
        [_resultView removeFromSuperview];
    }
    
    _resultView = resultView;
    _resultView.delegate = self;
}

- (YMACpsManager *)cpsManager {
    if (!_cpsManager) {
        _cpsManager = [[YMACpsManager alloc] initWithClientId:self.clientId];
    }
    
    return _cpsManager;
}

- (UIWebView *)webView {
    if (!_webView) {
        CGRect webViewFrame = self.view.frame;
        webViewFrame.size.height = webViewFrame.size.height - self.navigationController.navigationBar.frame.size.height;
        _webView = [[UIWebView alloc]initWithFrame:webViewFrame];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return _webView;
}

@end