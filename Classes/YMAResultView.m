//
// Created by Alexander Mertvetsov on 06.02.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAResultView.h"
#import "YMAUIConstants.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

static CGFloat const kSaveButtonOffset = 102.0;
static CGFloat const kLeftOffset = 30.0;
static CGFloat const kTitleLabelTopOffset = 55.0;
static CGFloat const kTitleLabelHeight = 60.0;
static CGFloat const kDefaultSeparatorHeight = 1.0;

static CGFloat const kCardTopOffset = 110.0;
static CGFloat const kCardLeftOffset = 23.0;
static CGFloat const kCardWidth = 230.0;
static CGFloat const kCardHeight = 150.0;

static CGFloat const kCheckHeight = 46.0;

static CGFloat const kAnimationSpeed = 0.7;

@interface YMAResultView () {
    CATransformLayer *_cardContainer;
    CAShapeLayer *_frontCardLayer;
    CAShapeLayer *_frontStripLayer;
    CAShapeLayer *_backCardLayer;
    CATransformLayer *_buttonContainer;
    CAShapeLayer *_buttonLayer;

    CAShapeLayer *_leftCheckLayer;
    CAShapeLayer *_rightCheckLayer;
    CAShapeLayer *_transCheckLayer;
    CAShapeLayer *_checkLayer;
}

@property(nonatomic, assign) YMAPaymentResultState state;
@property(nonatomic, copy) NSString *resultDescription;
@property(nonatomic, strong) UIButton *saveCardButton;
@property(nonatomic, strong) UILabel *saveButtonComment;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property(nonatomic, strong) UIBarButtonItem *rightBarButton;

@end

@implementation YMAResultView

- (id)initWithFrame:(CGRect)frame state:(YMAPaymentResultState)state description:(NSString *)description {
    self = [super initWithFrame:frame];

    if (self) {
        _state = state;
        _resultDescription = [description copy];
        [self setupControls];
    }

    return self;
}

- (void)setupControls {
    self.backgroundColor = [YMAUIConstants defaultBackgroundColor];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTitleLabelTopOffset, self.frame.size.width, kTitleLabelHeight)];

    titleLabel.font = [YMAUIConstants titleFont];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;

    [self addSubview:titleLabel];

    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftOffset, kTitleLabelTopOffset + kTitleLabelHeight, self.frame.size.width - 2 * kLeftOffset, kTitleLabelHeight)];

    amountLabel.font = [YMAUIConstants commentTitleFont];
    amountLabel.textColor = [YMAUIConstants commentColor];
    amountLabel.numberOfLines = 3;
    amountLabel.textAlignment = NSTextAlignmentCenter;

    if (self.state == YMAPaymentResultStateFatalFail || self.state == YMAPaymentResultStateFail) {
        NSString *errorText = YMALocalizedString(self.resultDescription, nil);
        errorText = [errorText isEqualToString:self.resultDescription] ? YMALocalizedString(@"unknownError", nil) : errorText;
        titleLabel.text = (self.state == YMAPaymentResultStateFatalFail) ? YMALocalizedString(@"TLFatalErrorTitle", nil) : YMALocalizedString(@"TLErrorTitle", nil);
        amountLabel.text = YMALocalizedString(errorText, nil);
    } else {
        titleLabel.text = YMALocalizedString(@"TLThanks", nil);
        amountLabel.text = [NSString stringWithFormat:YMALocalizedString(@"TLAmount", nil), self.resultDescription];
    }

    [self addSubview:amountLabel];

    if (self.state == YMAPaymentResultStateSuccessWithNewCard)
        [self addControlsForSuccessWithNewCardState];
    else if (self.state == YMAPaymentResultStateFail)
        [self addControlsForFailState];
    else
        [self addLogo];
}

- (void)addControlsForSuccessWithNewCardState {
    [self.saveCardButton setTitle:YMALocalizedString(@"BTSaveCard", nil) forState:UIControlStateNormal];
    [self.saveCardButton setTitle:YMALocalizedString(@"BTSavingCard", nil) forState:UIControlStateDisabled];
    [self.saveCardButton setTitleColor:[YMAUIConstants accentTextColor] forState:UIControlStateNormal];
    [self.saveCardButton setTitleColor:[YMAUIConstants commentColor] forState:UIControlStateDisabled];
    self.saveCardButton.titleLabel.font = [YMAUIConstants buttonFont];

    [self addSubview:self.saveCardButton];

    self.saveButtonComment.text = YMALocalizedString(@"TLSaveCardComment", nil);
    self.saveButtonComment.font = [YMAUIConstants commentFont];
    self.saveButtonComment.textColor = [YMAUIConstants commentColor];
    self.saveButtonComment.numberOfLines = 2;
    self.saveButtonComment.textAlignment = NSTextAlignmentCenter;

    [self addSubview:self.saveButtonComment];
    
    if (IS_IPHONE_5)
        [self drawCard];

    [self drawCheck];
    
    [self.saveCardButton addTarget:self action:@selector(saveMoneySource) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addControlsForFailState {
    [self.saveCardButton setTitle:YMALocalizedString(@"BTRepeat", nil) forState:UIControlStateNormal];
    [self.saveCardButton setTitleColor:[YMAUIConstants accentTextColor] forState:UIControlStateNormal];
    [self.saveCardButton setTitleColor:[YMAUIConstants commentColor] forState:UIControlStateDisabled];
    self.saveCardButton.titleLabel.font = [YMAUIConstants buttonFont];

    [self addSubview:self.saveCardButton];

    [self.saveCardButton addTarget:self.delegate action:@selector(repeatPayment) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addLogo {
    UIImageView *ymLogoView = [[UIImageView alloc] initWithImage:YMALocalizedImage(@"ym", nil)];
    CGRect logoRect = ymLogoView.frame;
    logoRect.origin.y = self.frame.size.height - 50;
    logoRect.origin.x = (self.frame.size.width - logoRect.size.width) / 2;
    ymLogoView.frame = logoRect;

    [self addSubview:ymLogoView];
}


- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.state == YMAPaymentResultStateFatalFail || self.state == YMAPaymentResultStateFail) {
        self.rightBarButton = [[UIBarButtonItem alloc] initWithTitle:YMALocalizedString(@"NBBClose", nil) style:UIBarButtonItemStylePlain target:self.delegate action:@selector(dismissController)];

        self.rightBarButton.tintColor = [YMAUIConstants accentTextColor];

        [self.delegate updateNavigationBarTitle:@"" leftButtons:@[] rightButtons:@[self.rightBarButton]];

        return;
    }

    self.rightBarButton = [[UIBarButtonItem alloc] initWithTitle:YMALocalizedString(@"NBBSuccess", nil) style:UIBarButtonItemStylePlain target:self.delegate action:@selector(dismissController)];

    self.rightBarButton.tintColor = [YMAUIConstants accentTextColor];

    [self.delegate updateNavigationBarTitle:YMALocalizedString(@"NBTResultSuccess", nil) leftButtons:@[] rightButtons:@[self.rightBarButton]];
}

- (void)successSaveMoneySource:(YMAMoneySourceModel *)moneySource {
    if (IS_IPHONE_5)
        [self showSavedCardWithMoneySource:moneySource];
    
    [self showCheck];
    
    self.saveButtonComment.text = YMALocalizedString(@"TLSavedCardComment", nil);
    self.rightBarButton.enabled = YES;
}

- (void)stopSavingMoneySourceWithError:(NSError *)error {
    [self stopSavingMoneySource];
    [self.delegate showError:error target:nil withAction:NULL];
}

#pragma mark -
#pragma mark *** Private methods ***
#pragma mark -

- (void)stopSavingMoneySource {
    if (IS_IPHONE_5)
        [self enableCard];
    self.saveCardButton.enabled = YES;
    self.saveButtonComment.text = YMALocalizedString(@"TLSaveCardComment", nil);
    [self.activityIndicatorView removeFromSuperview];
    self.rightBarButton.enabled = YES;
}

- (void)saveMoneySource {
    [self.delegate saveMoneySource];
    
    if (IS_IPHONE_5)
        [self disableCard];
    
    self.saveCardButton.enabled = NO;
    self.saveButtonComment.text = YMALocalizedString(@"TLSavingCardComment", nil);
    self.activityIndicatorView.center = CGPointMake(65, self.saveCardButton.frame.size.height / 2);
    [self.saveCardButton addSubview:self.activityIndicatorView];
    self.rightBarButton.enabled = NO;
}

- (void)drawCard {
    _cardContainer = [CATransformLayer layer];
    _frontCardLayer = [CAShapeLayer layer];
    _frontStripLayer = [CAShapeLayer layer];
    _backCardLayer = [CAShapeLayer layer];
    _buttonContainer = [CATransformLayer layer];
    _buttonLayer = [CAShapeLayer layer];

    _cardContainer.frame = CGRectMake(kCardLeftOffset, kCardTopOffset, kCardWidth, kCardHeight);
    _cardContainer.speed = kAnimationSpeed;

    _frontCardLayer.path = [UIBezierPath
            bezierPathWithRoundedRect:CGRectMake(0, 0, kCardWidth, kCardHeight)
                         cornerRadius:10].CGPath;

    _frontCardLayer.position = CGPointMake(kCardLeftOffset, kCardTopOffset);
    _frontCardLayer.lineWidth = 1;
    _frontCardLayer.strokeColor = [YMAUIConstants accentTextColor].CGColor;
    _frontCardLayer.fillColor = self.backgroundColor.CGColor;
    _frontCardLayer.zPosition = 2;
    _frontCardLayer.speed = kAnimationSpeed;

    [_cardContainer addSublayer:_frontCardLayer];

    _frontStripLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(kCardLeftOffset, kCardTopOffset + 20, kCardWidth, 40)].CGPath;
    _frontStripLayer.lineWidth = 0;
    _frontStripLayer.fillColor = [YMAUIConstants accentTextColor].CGColor;
    _frontStripLayer.zPosition = 2;
    _frontStripLayer.speed = kAnimationSpeed;

    [_cardContainer addSublayer:_frontStripLayer];

    CAShapeLayer *backgroundButton = [CAShapeLayer layer];
    backgroundButton.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(112, kCardTopOffset + 110, 52, 52)].CGPath;
    backgroundButton.lineWidth = 0;
    backgroundButton.fillColor = self.backgroundColor.CGColor;
    backgroundButton.zPosition = 1;

    [_buttonContainer addSublayer:backgroundButton];

    UIBezierPath *buttonPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(116, kCardTopOffset + 114, 44, 44)];
    [buttonPath moveToPoint:CGPointMake(138.0, kCardTopOffset + 124.0)];
    [buttonPath addLineToPoint:CGPointMake(138.0, kCardTopOffset + 148.0)];
    [buttonPath moveToPoint:CGPointMake(126.0, kCardTopOffset + 136.0)];
    [buttonPath addLineToPoint:CGPointMake(150.0, kCardTopOffset + 136.0)];

    _buttonLayer.path = buttonPath.CGPath;
    _buttonLayer.lineWidth = 1;
    _buttonLayer.strokeColor = [YMAUIConstants accentTextColor].CGColor;
    _buttonLayer.fillColor = self.backgroundColor.CGColor;
    _buttonLayer.zPosition = 2;
    _buttonLayer.speed = kAnimationSpeed + 0.1;

    [_buttonContainer addSublayer:_buttonLayer];
    _buttonContainer.zPosition = 3;
    _buttonContainer.speed = kAnimationSpeed + 0.1;

    [_cardContainer addSublayer:_buttonContainer];


    _backCardLayer.path = [UIBezierPath
            bezierPathWithRoundedRect:CGRectMake(0, 0, kCardWidth - 1, kCardHeight - 1)
                         cornerRadius:10].CGPath;
    _backCardLayer.position = CGPointMake(kCardLeftOffset + 0.5, kCardTopOffset + 0.5);
    _backCardLayer.lineWidth = 0;
    _backCardLayer.fillColor = [YMAUIConstants savedCardColor].CGColor;
    _backCardLayer.zPosition = 1;

    _backCardLayer.masksToBounds = NO;
    _backCardLayer.cornerRadius = 10; // if you like rounded corners
    _backCardLayer.shadowOffset = CGSizeMake(-5, 5);
    _backCardLayer.shadowRadius = 5;
    _backCardLayer.shadowOpacity = 0.2;
    _backCardLayer.shadowColor = [UIColor clearColor].CGColor;

    [_cardContainer addSublayer:_backCardLayer];

    [self.layer addSublayer:_cardContainer];
}

- (void)drawCheck {
    _transCheckLayer = [CAShapeLayer layer];
    _leftCheckLayer = [CAShapeLayer layer];
    _rightCheckLayer = [CAShapeLayer layer];
    _checkLayer = [CAShapeLayer layer];

    CALayer *btnLayers = [CALayer layer];

    CGRect checkRect = self.saveCardButton.frame;
    checkRect.size.height = kCheckHeight;

    _transCheckLayer.path = [UIBezierPath bezierPathWithRect:checkRect].CGPath;
    _transCheckLayer.lineWidth = 0;
    _transCheckLayer.fillColor = [UIColor clearColor].CGColor;
    _transCheckLayer.zPosition = 0;
    _transCheckLayer.speed = kAnimationSpeed - 0.3;

    [btnLayers addSublayer:_transCheckLayer];

    UIBezierPath *checkPath = [UIBezierPath bezierPath];

    [checkPath moveToPoint:CGPointMake(self.frame.size.width / 2 - 10, (self.frame.size.height - kSaveButtonOffset) + checkRect.size.height / 2)];
    [checkPath addLineToPoint:CGPointMake(self.frame.size.width / 2 - 3, ((self.frame.size.height - kSaveButtonOffset) + checkRect.size.height / 2) + 6)];
    [checkPath addLineToPoint:CGPointMake(self.frame.size.width / 2 + 9, ((self.frame.size.height - kSaveButtonOffset) + checkRect.size.height / 2) - 8)];

    _checkLayer.path = checkPath.CGPath;
    _checkLayer.lineWidth = 4;
    _checkLayer.strokeColor = [UIColor clearColor].CGColor;
    _checkLayer.fillColor = [UIColor clearColor].CGColor;
    _checkLayer.zPosition = 1;
    _checkLayer.speed = kAnimationSpeed;

    [btnLayers addSublayer:_checkLayer];

    UIBezierPath *leftPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, (self.frame.size.height - kSaveButtonOffset) + checkRect.size.height / 2) radius:checkRect.size.height / 2 startAngle:(CGFloat) (M_PI + M_PI / 2) endAngle:(CGFloat) (M_PI/ 2) clockwise:NO];
    [leftPath addLineToPoint:CGPointMake(-self.frame.size.width / 2, (self.frame.size.height - kSaveButtonOffset) + checkRect.size.height)];
    [leftPath addLineToPoint:CGPointMake(-self.frame.size.width / 2, self.frame.size.height - kSaveButtonOffset)];
    [leftPath addLineToPoint:CGPointMake(0, self.frame.size.height - kSaveButtonOffset)];
    [leftPath closePath];

    _leftCheckLayer.path = leftPath.CGPath;
    _leftCheckLayer.lineWidth = 0;
    _leftCheckLayer.fillColor = self.backgroundColor.CGColor;
    _leftCheckLayer.zPosition = 1;
    _leftCheckLayer.speed = kAnimationSpeed;

    [btnLayers addSublayer:_leftCheckLayer];

    UIBezierPath *rightPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width, (self.frame.size.height - kSaveButtonOffset) + checkRect.size.height / 2) radius:checkRect.size.height / 2 startAngle:(CGFloat) (M_PI + M_PI / 2) endAngle:(CGFloat) (M_PI/ 2) clockwise:YES];
    [rightPath addLineToPoint:CGPointMake(self.frame.size.width * 2, (self.frame.size.height - kSaveButtonOffset) + checkRect.size.height)];
    [rightPath addLineToPoint:CGPointMake(self.frame.size.width * 2, self.frame.size.height - kSaveButtonOffset)];
    [rightPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - kSaveButtonOffset)];
    [rightPath closePath];

    _rightCheckLayer.path = rightPath.CGPath;
    _rightCheckLayer.lineWidth = 0;
    _rightCheckLayer.fillColor = self.backgroundColor.CGColor;
    _rightCheckLayer.zPosition = 1;
    _rightCheckLayer.speed = kAnimationSpeed;

    [btnLayers addSublayer:_rightCheckLayer];

    [self.layer addSublayer:btnLayers];
}

- (void)showSavedCardWithMoneySource:(YMAMoneySourceModel *)moneySource {
    CATextLayer *backTextLayer = [CATextLayer layer];

    backTextLayer.frame = CGRectMake(kCardLeftOffset + 21, kCardTopOffset + 91, kCardWidth - 44, 40);
    backTextLayer.fontSize = 18;
    backTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
    backTextLayer.alignmentMode = kCAAlignmentCenter;
    backTextLayer.string = moneySource.panFragment;
    backTextLayer.zPosition = 0;

    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / 800;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, (CGFloat) M_PI, 0.0f, -1.0f, 0.0f);

    backTextLayer.transform = rotationAndPerspectiveTransform;

    [_cardContainer addSublayer:backTextLayer];

    if (moneySource.cardType != YMAPaymentCardTypeJCB && moneySource.cardType != YMAPaymentCardUnknown) {

        NSString *logoKey = kImageKeyVISA;

        if (moneySource.cardType == YMAPaymentCardTypeMasterCard)
            logoKey = kImageKeyMasterCard;
        else if (moneySource.cardType == YMAPaymentCardTypeAmericanExpress)
            logoKey = kImageKeyAmericanExpress;

        UIImageView *logoView = [[UIImageView alloc] initWithImage:YMALocalizedImage(logoKey, nil)];
        logoView.frame = CGRectMake(kCardLeftOffset + 21, kCardTopOffset + 21, logoView.frame.size.width, logoView.frame.size.height);
        CALayer *imgLayer = logoView.layer;
        imgLayer.transform = rotationAndPerspectiveTransform;
        imgLayer.zPosition = 0;

        [_cardContainer addSublayer:imgLayer];
    }

    [_buttonContainer removeFromSuperlayer];

    [UIView beginAnimations:@"flip" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];

    rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform, -46.0f, 0.0f, 0.0f);
    _cardContainer.transform = rotationAndPerspectiveTransform;
    _backCardLayer.shadowColor = [UIColor blackColor].CGColor;

    [UIView commitAnimations];
}

- (void)showCheck {
    [UIView beginAnimations:@"check" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];

    _transCheckLayer.fillColor = [YMAUIConstants checkColor].CGColor;
    _checkLayer.strokeColor = [UIColor whiteColor].CGColor;

    CATransform3D leftTransform = CATransform3DIdentity;
    leftTransform = CATransform3DTranslate(leftTransform, self.frame.size.width / 2, 0.0f, 0.0f);
    _leftCheckLayer.transform = leftTransform;
    CATransform3D rightTransform = CATransform3DIdentity;
    rightTransform = CATransform3DTranslate(rightTransform, -self.frame.size.width / 2, 0.0f, 0.0f);
    _rightCheckLayer.transform = rightTransform;

    [UIView commitAnimations];
}

- (void)disableCard {
    [UIView beginAnimations:@"disable" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];

    _frontCardLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    _frontStripLayer.fillColor = [UIColor lightGrayColor].CGColor;
    _buttonLayer.strokeColor = [UIColor clearColor].CGColor;
    CATransform3D zoomTransform = CATransform3DIdentity;

    zoomTransform = CATransform3DScale(zoomTransform, 0.5f, 0.5f, 3.0f);
    zoomTransform = CATransform3DTranslate(zoomTransform, 134.0f, 232.0f, 3.0f);
    _buttonContainer.transform = zoomTransform;

    [UIView commitAnimations];
}

- (void)enableCard {
    [UIView beginAnimations:@"enable" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];

    _frontCardLayer.strokeColor = [UIColor orangeColor].CGColor;
    _frontStripLayer.fillColor = [UIColor orangeColor].CGColor;
    _buttonLayer.strokeColor = [UIColor orangeColor].CGColor;
    CATransform3D zoomTransform = CATransform3DIdentity;

    zoomTransform = CATransform3DScale(zoomTransform, 1.0f, 1.0f, 3.0f);
    zoomTransform = CATransform3DTranslate(zoomTransform, 0.0f, 0.0f, 3.0f);
    _buttonContainer.transform = zoomTransform;

    [UIView commitAnimations];
}

#pragma mark -
#pragma mark *** Getters and setters ***
#pragma mark -

- (UIButton *)saveCardButton {
    if (!_saveCardButton) {
        CGRect buttonRect = CGRectMake(0, self.frame.size.height - kSaveButtonOffset, self.frame.size.width, kControlHeightDefault);
        _saveCardButton = [[UIButton alloc] initWithFrame:buttonRect];
        _saveCardButton.backgroundColor = [UIColor whiteColor];

        CGFloat separatorHeight = [UIScreen mainScreen].scale == 2 ? kDefaultSeparatorHeight / 2 : kDefaultSeparatorHeight;

        CGRect separatorRect = CGRectMake(0, 0, self.frame.size.width, separatorHeight);

        UIView *topSeparatorView = [[UIView alloc] initWithFrame:separatorRect];
        topSeparatorView.backgroundColor = [YMAUIConstants separatorColor];

        [_saveCardButton addSubview:topSeparatorView];

        separatorRect.origin.y = kControlHeightDefault;
        UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:separatorRect];
        bottomSeparatorView.backgroundColor = [YMAUIConstants separatorColor];

        [_saveCardButton addSubview:bottomSeparatorView];
    }

    return _saveCardButton;
}

- (UILabel *)saveButtonComment {
    if (!_saveButtonComment) {
        _saveButtonComment = [[UILabel alloc] initWithFrame:CGRectMake(kLeftOffset, self.frame.size.height - (kSaveButtonOffset - kControlHeightDefault), self.frame.size.width - kLeftOffset * 2, kControlHeightDefault)];
    }

    return _saveButtonComment;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicatorView startAnimating];
    }

    return _activityIndicatorView;
}

@end