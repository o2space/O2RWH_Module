//
//  LMSCommonAlertView.m
//  LetMeSpend
//
//  Created by liuhongmei on 15/12/28.
//  Copyright © 2015年 __defaultyuan. All rights reserved.
//

#import "LMSCommonAlertView.h"
#import "RWHMacros.h"
#import "UIColor+RWHAdd.h"
#import "Masonry.h"

@interface LMSCommonAlertView ()

// backgroundView, alertView
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *alertView;

// titleLabel, messageLable, button
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *messageLabel;
@property(nonatomic, strong) UILabel *titleDesLabel;
@property(nonatomic, strong) UILabel *messageDesLabel;
@property(nonatomic, strong) UIView *titleView;
@property(nonatomic, strong) UIView *messageView;
@property (nonatomic) UIButton *button;

// autolayout constraint for alertview centerY
@property (nonatomic) NSLayoutConstraint *alertConstraintCenterY;

// title, message, button text
@property(nonatomic, strong) NSString *messageDes;
@property (nonatomic) NSString *titleText;
@property (nonatomic) NSString *messageText;
@property (nonatomic) NSString *buttonTitleText;
@property(nonatomic, strong) NSString *cancelTitle;
@property(nonatomic, strong) NSString *okTitle;

@property(nonatomic, strong) UIButton *cancelBtn;
@property(nonatomic, strong) UIButton *okBtn;

// blocks

@property (nonatomic, copy) commonAlertViewBlock dismissBlock;

@property (nonatomic) float rorateDirection;

@end


@implementation LMSCommonAlertView

//+ (instancetype)alertViewWithTitleDes:(NSString *)titleDes
//                              message:(NSString *)message
//                           messageDes:(NSString *)messageDes
//                          buttonTitle:(NSString *)buttonTitle
//                  buttonTouchedAction:(commonAlertViewBlock)buttonBlock
//                        dismissAction:(commonAlertViewBlock)dismissBlock
//{
//    return [[LMSCommonAlertView alloc] initWithTitleDes:titleDes message:message messageDes:messageDes buttonTitle:buttonTitle buttonTouchedAction:buttonBlock dismissAction:dismissBlock];
//}

+ (instancetype)alertViewwithTitle:(NSString *)title
                           message:(NSString *)message
                    cancelBtnTitle:(NSString *)cancelTitle
                        okBtnTitle:(NSString *)okBtnTittle
               buttonTouchedAction:(commonAlertViewBlock)buttonBlock
                     dismissAction:(commonAlertViewBlock)dismissBlock
{
    return  [[LMSCommonAlertView alloc] initWithTitle:title message:message cancelBtnTitle:cancelTitle okBtnTitle:okBtnTittle buttonTouchedAction:buttonBlock dismissAction:dismissBlock];
}

+ (instancetype)alertViewwithTitle:(NSString *)title
                           message:(NSString *)message
                    cancelBtnTitle:(NSString *)cancelTitle
                     okBtnRedTitle:(NSString *)okBtnRedTittle
               buttonTouchedAction:(commonAlertViewBlock)buttonBlock
                     dismissAction:(commonAlertViewBlock)dismissBlock
{
    return  [[LMSCommonAlertView alloc] initWithTitle:title message:message cancelBtnTitle:cancelTitle okBtnRedTitle:okBtnRedTittle buttonTouchedAction:buttonBlock dismissAction:dismissBlock];
}

+ (instancetype)alertViewWithChangeTitle:(NSString *)title
                                 message:(NSString *)message
                          cancelBtnTitle:(NSString *)cancelTitle
                              okBtnTitle:(NSString *)okBtnTittle
                     buttonTouchedAction:(commonAlertViewBlock)buttonBlock
                           dismissAction:(commonAlertViewBlock)dismissBlock
{
    return  [[LMSCommonAlertView alloc] initWithChangeTitle:title message:message cancelBtnTitle:okBtnTittle okBtnTitle:cancelTitle buttonTouchedAction:dismissBlock dismissAction:buttonBlock];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
               cancelBtnTitle:(NSString *)cancelTitle
                   okBtnTitle:(NSString *)okBtnTittle
          buttonTouchedAction:(commonAlertViewBlock)buttonBlock
                dismissAction:(commonAlertViewBlock)dismissBlock
{
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _cancelTitle = cancelTitle;
        _okTitle = okBtnTittle;
        _titleText = title;
        _messageText =  message;
        _buttonBlock = buttonBlock;
        _dismissBlock = dismissBlock;
        [self lenthSetup];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
               cancelBtnTitle:(NSString *)cancelTitle
                   okBtnRedTitle:(NSString *)okBtnTittle
          buttonTouchedAction:(commonAlertViewBlock)buttonBlock
                dismissAction:(commonAlertViewBlock)dismissBlock
{
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _cancelTitle = cancelTitle;
        _okTitle = okBtnTittle;
        _titleText = title;
        _messageText =  message;
        _buttonBlock = buttonBlock;
        _dismissBlock = dismissBlock;
        [self lenthRedSetup];
    }
    return self;
}

//- (instancetype)initWithTitleDes:(NSString *)titleDes
//                         message:(NSString *)message
//                      messageDes:(NSString *)messageDes
//                     buttonTitle:(NSString *)buttonTitle
//             buttonTouchedAction:(commonAlertViewBlock)buttonAction
//                   dismissAction:(commonAlertViewBlock)dismissAction {
//    self = [super init];
//    if (self) {
//        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        _buttonTitleText = buttonTitle;
//        _messageText = message;
//        _titleText = titleDes;
//        _messageDes = messageDes;
//        _buttonBlock = buttonAction;
//        _dismissBlock = dismissAction;
//        
//        [self setup];
//    }
//    return self;
//}

- (instancetype)initWithChangeTitle:(NSString *)title
                      message:(NSString *)message
               cancelBtnTitle:(NSString *)cancelTitle
                   okBtnTitle:(NSString *)okBtnTittle
          buttonTouchedAction:(commonAlertViewBlock)buttonBlock
                dismissAction:(commonAlertViewBlock)dismissBlock
{
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _cancelTitle = cancelTitle;
        _okTitle = okBtnTittle;
        _titleText = title;
        _messageText =  message;
        _buttonBlock = buttonBlock;
        _dismissBlock = dismissBlock;
        [self lenthChangeSetup];
    }
    return self;
}

- (UILabel *)labelWithText:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    
    return label;
}

UIImage *imageFromColor(UIColor *color)
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//- (void)setup
//{
//    [self setupBackgroundView];
//    [self setupAlertView];
//    [self setupTitleView];
//    [self setupMessageView];
//    
//    [self setupButton];
//    [self setupLayoutConstraints];
//}

- (void)lenthChangeSetup {
    [self setupBackgroundView];
    [self setupAlertView];
    [self setupChangeContent];
}

- (void)lenthSetup {
    [self setupBackgroundView];
    [self setupAlertView];
    [self setupRedContent];
}

- (void)lenthRedSetup {
    [self setupBackgroundView];
    [self setupAlertView];
    [self setupRedContent];
}

- (void)setupBackgroundView
{
    UIView *view = [UIView new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
    view.alpha = 0.5;
    [self addSubview:view];
    self.backgroundView = view;
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)setupAlertView
{
    UIView *alertView = [UIView new];
    alertView.translatesAutoresizingMaskIntoConstraints = NO;
    alertView.layer.cornerRadius = 8;
    alertView.layer.masksToBounds = YES;
    alertView.backgroundColor = [UIColor whiteColor];
    [self addSubview:alertView];
    self.alertView = alertView;
    
    [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if(IS_IPHONE_4_OR_LESS || IS_IPHONE_5){
            
            make.left.equalTo(self).offset(25);
            make.right.equalTo(self).offset(-25);
        }else{
         
            make.left.equalTo(self).offset(55);
            make.right.equalTo(self).offset(-55);
        }
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}

- (void)setupRedContent {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.titleText;
    titleLabel.textColor = UIColorWithHex(0x333333);
    [self.alertView addSubview:titleLabel];
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.text = self.messageText;
    messageLabel.numberOfLines = 0;
    messageLabel.font = HelveticaNeueLightFont(14);//fontHB_16;
    messageLabel.textColor = UIColorWithHex(0x686871);//[Tool titleGrayColor];
    [self.alertView addSubview:messageLabel];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    // gray seperator
    cancelBtn.backgroundColor = [UIColor whiteColor];
//    RGB(239, 239, 244);
    cancelBtn.layer.shadowColor = [[UIColor grayColor] CGColor];
    cancelBtn.layer.shadowRadius = 0.5;
    cancelBtn.layer.shadowOpacity = 1;
    cancelBtn.layer.shadowOffset = CGSizeZero;
    cancelBtn.layer.masksToBounds = NO;
    
    // title
    [cancelBtn setTitle:self.cancelTitle forState:UIControlStateNormal];
    [cancelBtn setTitle:self.cancelTitle forState:UIControlStateSelected];
    cancelBtn.titleLabel.font = HelveticaNeueLightFont(14);
    [cancelBtn setTitleColor:UIColorWithHex(0x686871) forState:UIControlStateNormal];
    
    // action
    [cancelBtn addTarget:self
                  action:@selector(hide)
        forControlEvents:UIControlEventTouchUpInside];
    
    [self.alertView addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    okBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    // gray seperator
    okBtn.backgroundColor = [UIColor whiteColor];
//    RGB(239, 239, 244);
    okBtn.layer.shadowColor = [[UIColor grayColor] CGColor];
    okBtn.layer.shadowRadius = 0.5;
    okBtn.layer.shadowOpacity = 1;
    okBtn.layer.shadowOffset = CGSizeZero;
    okBtn.layer.masksToBounds = NO;
    
    // title
    [okBtn setTitle:self.okTitle forState:UIControlStateNormal];
    [okBtn setTitle:self.okTitle forState:UIControlStateSelected];
    okBtn.titleLabel.font = HelveticaNeueLightFont(14);
//    [okBtn setTitleColor:UIColorWithHex(0x686871) forState:UIControlStateNormal];
    
    // action
    [okBtn addTarget:self
              action:@selector(buttonAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    [self.alertView addSubview:okBtn];
    self.okBtn = okBtn;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel,messageLabel, cancelBtn, okBtn);
    NSString *vflH1 = @"H:|-[titleLabel]-|";
    NSString * vflh2 = @"H:|-15-[messageLabel]-15-|";
    
    NSString *vflh3 = @"H:|-0-[okBtn]-0-|";
    if (self.cancelTitle) {
        vflh3 = @"H:|-0-[cancelBtn]-0-[okBtn(cancelBtn)]-0-|";
    }
    NSString *vflV1;
    NSString *vflV2 = @"V:[cancelBtn(44)]-0-|";
    if ([self.titleText isEqualToString:@""] || self.titleText == nil) {
        
        vflV1 = @"V:|-30-[messageLabel]-30-[okBtn(44)]-0-|";
    }else{
        
        vflV1 = @"V:|-12-[titleLabel(20)]-20-[messageLabel]-20-[okBtn(44)]-0-|";
    }
    
    [okBtn setTitleColor:[UIColor hexStringToColor:@"F73E3E"] forState:UIControlStateNormal];
    
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflH1 options:0 metrics:nil views:views]];
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflh2 options:0 metrics:nil views:views]];
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflh3 options:0 metrics:nil views:views]];
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflV1 options:0 metrics:nil views:views]];
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflV2 options:0 metrics:nil views:views]];
    
    if (self.cancelTitle == nil)
    {
        //右上角叉号
        UIButton *cancelBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn2.backgroundColor = UIColorWithHex(0xffffff);
        [cancelBtn2 addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:cancelBtn2];
        
        [cancelBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@25);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
        }];
    }
}

- (void)setupChangeContent{
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.titleText;
    titleLabel.textColor = UIColorWithHex(0x333333);
    [self.alertView addSubview:titleLabel];
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.text = self.messageText;
    messageLabel.numberOfLines = 0;
    messageLabel.font = HelveticaNeueLightFont(14);//fontHB_16;
    messageLabel.textColor = UIColorWithHex(0x686871);//[Tool titleGrayColor];
    [self.alertView addSubview:messageLabel];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    // gray seperator
    cancelBtn.backgroundColor = [UIColor whiteColor];
    //    RGB(239, 239, 244);
    cancelBtn.layer.shadowColor = [[UIColor grayColor] CGColor];
    cancelBtn.layer.shadowRadius = 0.5;
    cancelBtn.layer.shadowOpacity = 1;
    cancelBtn.layer.shadowOffset = CGSizeZero;
    cancelBtn.layer.masksToBounds = NO;
    
    // title
    [cancelBtn setTitle:self.cancelTitle forState:UIControlStateNormal];
    [cancelBtn setTitle:self.cancelTitle forState:UIControlStateSelected];
    cancelBtn.titleLabel.font = HelveticaNeueLightFont(14);
    [cancelBtn setTitleColor:UIColorWithHex(0x686871) forState:UIControlStateNormal];
    
    // action
    [cancelBtn addTarget:self
                  action:@selector(hide)
        forControlEvents:UIControlEventTouchUpInside];
    
    [self.alertView addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    okBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    // gray seperator
    okBtn.backgroundColor = [UIColor whiteColor];
    //    RGB(239, 239, 244);
    okBtn.layer.shadowColor = [[UIColor grayColor] CGColor];
    okBtn.layer.shadowRadius = 0.5;
    okBtn.layer.shadowOpacity = 1;
    okBtn.layer.shadowOffset = CGSizeZero;
    okBtn.layer.masksToBounds = NO;
    
    
    // title
    [okBtn setTitle:self.okTitle forState:UIControlStateNormal];
    [okBtn setTitle:self.okTitle forState:UIControlStateSelected];
    okBtn.titleLabel.font = HelveticaNeueLightFont(14);
    [okBtn setTitleColor:UIColorWithHex(0x686871) forState:UIControlStateNormal];
    
    // action
    [okBtn addTarget:self
              action:@selector(buttonAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    [self.alertView addSubview:okBtn];
    self.okBtn = okBtn;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel,messageLabel, cancelBtn, okBtn);
    NSString *vflH1 = @"H:|-[titleLabel]-|";
    NSString * vflh2 = @"H:|-15-[messageLabel]-15-|";
    
    NSString *vflh3 = @"H:|-0-[okBtn]-0-|";
    if (self.cancelTitle) {
        vflh3 = @"H:|-0-[cancelBtn]-0-[okBtn(cancelBtn)]-0-|";
    }
    NSString *vflV1 = @"V:|-30-[messageLabel]-30-[okBtn(44)]-0-|";
    NSString *vflV2 = @"V:[cancelBtn(44)]-0-|";
    
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflH1 options:0 metrics:nil views:views]];
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflh2 options:0 metrics:nil views:views]];
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflh3 options:0 metrics:nil views:views]];
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflV1 options:0 metrics:nil views:views]];
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflV2 options:0 metrics:nil views:views]];
    
    if (self.cancelTitle == nil)
    {
        //右上角叉号
        UIButton *cancelBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn2.backgroundColor = UIColorWithHex(0xffffff);
        [cancelBtn2 addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:cancelBtn2];
        
        [cancelBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@25);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
        }];
    }
}

- (void)setupTitleView {
    UIView *view = [UIView new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [_alertView addSubview:view];
    self.titleView = view;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"投资金额：";
    titleLabel.textColor = UIColorWithHex(0xe7343a);//[Tool colorWithHexString:@"#38404b"];
    titleLabel.font = HelveticaNeueLightFont(17);
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    UILabel *titleDesLabel = [UILabel new];
    titleDesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleDesLabel.font = HelveticaNeueLightFont(17);
    titleDesLabel.textColor = UIColorWithHex(0xe7343a);
    titleDesLabel.text = _titleText;
    [view addSubview:titleDesLabel];
    self.titleDesLabel = titleDesLabel;

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.right.equalTo(titleDesLabel).offset(2);
        make.top.equalTo(self);
    }];
    
    [titleDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self);
        make.top.equalTo(self);
    }];
    
}

- (void)setupMessageView {
    UIView *view = [UIView new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [_alertView addSubview:view];
    self.messageView = view;
    
    UILabel *messageLabel = [UILabel new];
    messageLabel.font = HelveticaNeueLightFont(14);;
    messageLabel.text = self.messageText;
    messageLabel.textColor = UIColorWithHex(0x38404b);;
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:messageLabel];
    self.messageDesLabel = messageLabel;
    UILabel *messageDesLabel = [UILabel new];
    messageDesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    messageDesLabel.font = HelveticaNeueLightFont(14);
    messageDesLabel.text = _messageDes;
    messageDesLabel.textColor = UIColorWithHex(0x38404b);;
    [view addSubview:messageDesLabel];
    self.messageDesLabel = messageDesLabel;
    
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.right.equalTo(messageDesLabel.mas_right).offset(2);
        make.top.equalTo(self);
    }];
    
    [messageDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.right.equalTo(self);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"exit_x"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:cancelBtn];

    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@25);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(@25);
    }];
}

- (void)setupButton {
    // init
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    
    // gray seperator
    _button.backgroundColor = [UIColor whiteColor];
    _button.layer.shadowColor = [[UIColor grayColor] CGColor];
    _button.layer.shadowRadius = 0.5;
    _button.layer.shadowOpacity = 1;
    _button.layer.shadowOffset = CGSizeZero;
    _button.layer.masksToBounds = NO;
    
    // background color
    [_button setBackgroundImage:imageFromColor([UIColor grayColor])
                       forState:UIControlStateHighlighted];
    [_button setBackgroundImage:imageFromColor([UIColor whiteColor])
                       forState:UIControlStateNormal];
    
    // title
    [_button setTitle:_buttonTitleText forState:UIControlStateNormal];
    [_button setTitle:_buttonTitleText forState:UIControlStateSelected];
    _button.titleLabel.font = [UIFont boldSystemFontOfSize:_button.titleLabel.font.pointSize];
    
    // action
    [_button addTarget:self
                action:@selector(buttonAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    [_alertView addSubview:_button];
}

- (void)setupLayoutConstraints {
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_alertView.mas_centerX);
        make.centerY.equalTo(_alertView.mas_centerY);
        make.top.equalTo(self).offset(20);
        make.bottom.equalTo(_messageView.mas_top);
    }];
    [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(_titleView.mas_leading);
        make.centerY.equalTo(_alertView.mas_centerY);
        make.bottom.equalTo(_button.mas_top).offset(20);
    }];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@44);
        make.bottom.equalTo(@0);
        make.centerY.equalTo(_alertView.mas_centerY);
    }];
}

- (void)addAlertView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(window.mas_width);
        make.height.equalTo(window.mas_height);
        make.left.equalTo(window.mas_left);
        make.right.equalTo(window.mas_right);
    }];
}

- (void)buttonAction:(UIButton *)sender {
    if (self.buttonBlock != NULL) {
        self.buttonBlock();
    }
    [self dismiss];
}

- (void)show
{
    [self addAlertView];
    
    self.alertView.layer.shouldRasterize = YES;
    self.alertView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.alertView.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
    
    [UIView animateWithDuration:0.20f delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.alertView.transform = CGAffineTransformMakeScale(1, 1);

                     }
                     completion:NULL
     ];
}

- (void)hide
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [self dismiss];
}

- (void)dismiss
{
    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    hideAnimation.duration = 0.05;
    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)]];
    hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    hideAnimation.delegate = self;
    hideAnimation.fillMode = kCAFillModeBoth;
    hideAnimation.removedOnCompletion = NO;
    [self.alertView.layer addAnimation:hideAnimation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
