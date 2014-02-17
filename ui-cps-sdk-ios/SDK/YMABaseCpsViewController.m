//
//  YMABaseCpsViewController.m
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 04.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMABaseCpsViewController.h"

static NSString *const kFatalError = @"illegal_param_client_id";
static NSString *const kUnknownError = @"unknownError";

@interface YMABaseCpsViewController () <YMABaseResultViewDelegate, YMABaseMoneySourcesViewDelegate, YMABaseCscViewDelegate> {
    YMACpsManager *_cpsManager;
    UIWebView *_webView;
    UIScrollView *_scrollView;
}

@property(nonatomic, copy) NSString *clientId;
@property(nonatomic, strong) NSDictionary *paymentParams;
@property(nonatomic, copy) NSString *patternId;
@property(nonatomic, strong) YMAMoneySource *selectedMoneySource;
@property(nonatomic, copy) NSString *currentCsc;
@property(nonatomic, strong) YMABaseResultView *resultView;
@property(nonatomic, strong) YMABaseMoneySourcesView *moneySourcesView;
@property(nonatomic, strong) YMABaseCscView *cardCscView;

@end

@implementation YMABaseCpsViewController

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
    [self.view addSubview:self.scrollView];
    [self startActivity];

//    YMAAsc *asc = [YMAAsc ascWithUrl:[NSURL URLWithString:@"http://m.money.yandex.ru"] andParams:nil];
//
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
//        [self loadInWebViewFormAsc:asc];
//
//        dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
//        dispatch_after(popTime2, dispatch_get_main_queue(), ^(void) {
//            [self showSuccessView];
//        });
//    });


    [self.cpsManager updateInstanceWithCompletion:^(NSError *error) {
        if (error)
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showFailViewWithError:error];
            });
        else
            [self startPayment];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [self setupNavigationBar];
}

#pragma mark -
#pragma mark *** Abstract methods ***
#pragma mark -

- (void)setupNavigationBar {
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (void)showError:(NSError *)error target:(id)target withAction:(SEL)selector {
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (void)disableError {
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (void)hideError {
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

- (YMABaseResultView *)resultViewWithState:(YMAPaymentResultState)state andDescription:(NSString *)description {
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

#pragma mark -
#pragma mark *** Private methods ***
#pragma mark -

- (void)processError:(NSError *)error {
    if (self.cardCscView && self.cardCscView.superview) {
        [self.cardCscView stopPaymentWithError:error];
        return;
    }

    [self stopActivity];
    [self showFailViewWithError:error];
}

- (void)startPayment {
    [self disableError];
    
    [self updatePaymentRequestInfoWithCompletion:^(NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showFailViewWithError:error];
            });
        } else if (self.cpsManager.moneySources.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopActivity];
                [self showMoneySource];
            });
        } else
            [self finishPaymentFromNewCard];
    }];
}

- (void)processPaymentRequestWithAsc:(YMAAsc *)asc andError:(NSError *)error {
    if (error)
        [self processError:error];
    else if (asc)
        [self loadInWebViewFormAsc:asc];
    else
        [self showSuccessView];
}

- (void)finishPaymentFromNewCard {
    [self.cpsManager finishPaymentWithRequestId:self.paymentRequestInfo.requestId completion:^(YMAAsc *asc, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self processPaymentRequestWithAsc:asc andError:error];
        });
    }];
}

- (void)finishPaymentFromExistCard {
    [self.cpsManager finishPaymentWithRequestId:self.paymentRequestInfo.requestId moneySourceToken:self.selectedMoneySource.moneySourceToken andCsc:self.currentCsc completion:^(YMAAsc *asc, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self processPaymentRequestWithAsc:asc andError:error];
        });
    }];
}

- (void)loadInWebViewFormAsc:(YMAAsc *)asc {
    [self hideError];

    NSMutableString *post = [NSMutableString string];

    for (NSString *key in asc.params.allKeys) {
        NSString *paramValue = [[asc.params objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *paramKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [post appendString:[NSString stringWithFormat:@"%@=%@&", paramKey, paramValue]];
    }

    if (post.length)
        [post deleteCharactersInRange:NSMakeRange(post.length - 1, 1)];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:asc.url];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];

    [self stopActivity];
    if (!self.webView.superview)
        [self.scrollView addSubview:self.webView];
    [self.webView loadRequest:request];
}

- (void)showSuccessView {
    [self stopActivity];
    YMAPaymentResultState state = (self.selectedMoneySource) ? YMAPaymentResultStateSuccessWithExistCard : YMAPaymentResultStateSuccessWithNewCard;
    self.resultView = [self resultViewWithState:state andDescription:self.paymentRequestInfo.amount];
    [self.scrollView addSubview:self.resultView];
}

- (void)showFailViewWithError:(NSError *)error {
    YMAPaymentResultState state = [error.domain isEqualToString:kFatalError] ? YMAPaymentResultStateFatalFail : YMAPaymentResultStateFail;
    self.resultView = [self resultViewWithState:state andDescription:(error) ? error.domain : kUnknownError];
    [self.scrollView addSubview:self.resultView];
}

- (void)startActivity {
    [self.scrollView addSubview:self.activityIndicatorView];
}

- (void)stopActivity {
    if (self.activityIndicatorView.superview)
        [self.activityIndicatorView removeFromSuperview];
}

#pragma mark -
#pragma mark *** YMABaseCpsViewDelegate ***
#pragma mark -

- (void)updateNavigationBarTitle:(NSString *)title leftButtons:(NSArray *)leftButtons rightButtons:(NSArray *)rightButtons {
    self.navigationItem.title = title;
    self.navigationItem.leftBarButtonItems = leftButtons;
    self.navigationItem.rightBarButtonItems = rightButtons;
}

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)showMoneySource {
    [self hideError];
    self.moneySourcesView = [self moneySourcesViewWithSources:self.cpsManager.moneySources];
    [self.scrollView addSubview:self.moneySourcesView];
    [self.cardCscView removeFromSuperview];
    [self.webView removeFromSuperview];
}

#pragma mark -
#pragma mark *** YMABaseResultViewDelegate ***
#pragma mark -

- (void)saveMoneySource {
    [self.cpsManager saveMoneySourceWithRequestId:self.paymentRequestInfo.requestId completion:^(YMAMoneySource *moneySource, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
                [self.resultView stopSavingMoneySourceWithError:error];
            else
                [self.resultView successSaveMoneySource:moneySource];
        });
    }];
}

- (void)repeatPayment {
    [self startActivity];
    [self startPayment];
    [self.resultView removeFromSuperview];
}

#pragma mark -
#pragma mark *** YMABaseMoneySourcesViewDelegate ***
#pragma mark -

- (void)didSelectedMoneySource:(YMAMoneySource *)moneySource {
    self.selectedMoneySource = moneySource;
    self.cardCscView = [self cscView];
    [self.scrollView addSubview:self.cardCscView];
    [self.moneySourcesView removeFromSuperview];
}

- (void)removeMoneySource:(YMAMoneySource *)moneySource {
    [self.cpsManager removeMoneySource:moneySource];
}

- (void)paymentFromNewCard {
    self.selectedMoneySource = nil;
    [self.moneySourcesView removeFromSuperview];
    [self startActivity];
    [self updatePaymentRequestInfoWithCompletion:^(NSError *error) {
        if (error)
            dispatch_async(dispatch_get_main_queue(), ^{
                [self processError:error];
            });
        else
            [self finishPaymentFromNewCard];
    }];
}

- (void)updatePaymentRequestInfoWithCompletion:(YMAHandler)block {
    [self.cpsManager startPaymentWithPatternId:self.patternId andPaymentParams:self.paymentParams completion:^(YMAPaymentRequestInfo *requestInfo, NSError *error) {
        _paymentRequestInfo = requestInfo;
        block(error);
    }];
}

#pragma mark -
#pragma mark *** YMABaseCscViewDelegate ***
#pragma mark -

- (void)startPaymentWithCsc:(NSString *)csc {
    self.currentCsc = csc;
    [self updatePaymentRequestInfoWithCompletion:^(NSError *error) {
        if (error)
            dispatch_async(dispatch_get_main_queue(), ^{
                [self processError:error];
            });
        else
            [self finishPaymentFromExistCard];
    }];
}

#pragma mark -
#pragma mark *** UIWebViewDelegate ***
#pragma mark -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (![request URL])
        return NO;

    NSString *scheme = [[request URL] scheme];
    NSString *path = [[request URL] path];
    NSString *host = [[request URL] host];

    NSString *strippedURL = [NSString stringWithFormat:@"%@://%@%@", scheme, host, path];

    if ([strippedURL isEqual:kSuccessUrl]) {

        if (self.selectedMoneySource)
            [self finishPaymentFromExistCard];
        else
            [self finishPaymentFromNewCard];

        [webView removeFromSuperview];
        return NO;
    }

    if ([strippedURL isEqual:kFailUrl]) {
        [self showFailViewWithError:nil];
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

- (void)setMoneySourcesView:(YMABaseMoneySourcesView *)moneySourcesView {
    if (_moneySourcesView) {
        _moneySourcesView.delegate = nil;
        [_moneySourcesView removeFromSuperview];
    }

    _moneySourcesView = moneySourcesView;
    _moneySourcesView.delegate = self;
}

- (void)setCardCscView:(YMABaseCscView *)cardCscView {
    if (_cardCscView) {
        _cardCscView.delegate = nil;
        [_cardCscView removeFromSuperview];
    }

    _cardCscView = cardCscView;
    _cardCscView.delegate = self;
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
        CGFloat y = 0.0;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7)
            y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        webViewFrame.size.height -= y;
        _webView = [[UIWebView alloc] initWithFrame:webViewFrame];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
    }

    return _webView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        CGFloat y = 0.0;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7)
            y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        CGSize contentSize = self.view.frame.size;
        contentSize.height -= y;
        _scrollView.contentSize = contentSize;
    }

    return _scrollView;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.center = CGPointMake(self.view.frame.size.width / 2, self.scrollView.contentSize.height / 2);
        [_activityIndicatorView startAnimating];
    }

    return _activityIndicatorView;
}

@end