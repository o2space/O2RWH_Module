//
//  LMSAddBandCardVC.m
//  LetMeSpend
//
//  Created by zy on 16/7/8.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSAddBandCardVC.h"
//#import "LMSWebViewController.h"
#import "LMSIntrodutionView.h"
#import "LMSCommonAlertView.h"
#import "LMSPayInfoModel.h"
//#import "LMSUserViewModel.h"
#import "LMSPayViewModel.h"
#import "LMSBankCardManager.h"
#import "ActionSheetStringPicker.h"
#import "LMSAddBandSuccessVC.h"
#import "LMSBankCardSuccessController.h"

@interface LMSAddBandCardVC ()<UITextFieldDelegate>{
    
    NSArray *usageArr;
    //NSString *_resultString;
    UIView * backBlackView;
    int _bankcode_index;
    int isGetSmsCode;
}
@property (nonatomic,strong) LMSCustomAlertView *alert;
@property (nonatomic,strong) LMSPayInfoModel * payInfoModel;
@property (nonatomic,strong) LMSUserAllInfoModel * userInfo;
@property (nonatomic,strong) NSMutableArray * sortArr;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,assign) int time;
@property (nonatomic,strong) LMSPayAddCardSmsCodeResponseModel * smsCodeResponseModel;
@property (nonatomic,strong) LMSPayAddCardConfirmResponseModel * confirmResponseModel;
@property (nonatomic,copy)   NSString * resultString;

@property (weak, nonatomic) IBOutlet UIButton *getSmsCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *soundSmsCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *smsSoundTimer;


@end

@implementation LMSAddBandCardVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self initNavigation];
    isGetSmsCode = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isGetSmsCode) name:getSmsCodeAddBank object:nil];
}

- (void)isGetSmsCode{
    //isGetSmsCode = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.payInfoModel = [LMSPayInfoModel getPayInfoFromFile];
    self.userInfo = [LMSUserAllInfoModel userInfoFromFile];
    self.telephoneTextFiled.text = self.userInfo.mobile;
    
    [self refreshAddCardUI];
    
    [self forTimeOut];
        
    [LMSNotificationCenter addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    [LMSNotificationCenter addObserver:self selector:@selector(pickerViewToolBarCancelClick) name:LMSPickerViewCancel object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    backBlackView.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:getSmsCodeAddBank object:nil];
}

- (void)LoadMinehomePayInfoData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"",@""
                               ,nil];
        
        [[LMSPayViewModel sharePayViewModel] getPayInfo:dict CallBack:^(BOOL success, id data) {
            
            if (success) {
                
                self.payInfoModel = [LMSPayInfoModel mj_objectWithKeyValues:data];
                [LMSPayInfoModel savePayInfoToFile:self.payInfoModel];
                self.sortArr = [NSMutableArray arrayWithArray:[self sortCardsArr]];
            }
        }];
    });
}

/*
 充值提现
 */
- (NSArray *)sortCardsArr{
    
    NSMutableArray * statusArr  = [NSMutableArray array];
    NSMutableArray * cardsArr   = [NSMutableArray arrayWithArray:self.payInfoModel.cards];
    
    for (int i = 0; i < cardsArr.count; i++) {
        
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:cardsArr[i]];
        
        if ([dic[@"status"] intValue] == 1) {
            
            [statusArr addObject:cardsArr[i]];
        }
    }
    return statusArr;
}

- (void)forTimeOut{
    
    if (self.payInfoModel.cards.count == 0 || self.payInfoModel.cards == nil) {
        return;
    }
    
    if (self.timeOut != NSNotFound) {
        
        NSDictionary * dic = self.payInfoModel.cards[self.timeOut];
        self.resultString = dic[@"bankname"];
        self.chooseBandButton.title = _resultString;
        self.bandNumTextFiled.text = dic[@"cardno"];
        self.telephoneTextFiled.text = dic[@"phone"];
        [self.chooseBandButton setTitleColor:[UIColor hexStringToColor:@"383840"] forState:UIControlStateNormal];
        
        self.bandNumTextFiled.userInteractionEnabled   = NO;
        self.telephoneTextFiled.userInteractionEnabled = NO;
        self.chooseBandButton.userInteractionEnabled   = NO;
    }else{
        
        self.bandNumTextFiled.userInteractionEnabled   = YES;
        self.telephoneTextFiled.userInteractionEnabled = YES;
        self.chooseBandButton.userInteractionEnabled   = YES;
    }
}

- (void)refreshAddCardUI{
    
    self.nameLabel.text = self.userInfo.real_name;
    [self.chooseBandButton setTitleColor:[UIColor hexStringToColor:@"C8C7CC"] forState:UIControlStateNormal];
    self.nextBtn.layer.cornerRadius = 6.0;
    self.nextBtn.layer.masksToBounds = YES;
    self.time = 120;
    
    backBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:backBlackView];
    backBlackView.backgroundColor = [UIColor blackColor];
    backBlackView.alpha = 0.6f;
    backBlackView.hidden = YES;
}

- (IBAction)chooseBandButton:(UIButton *)sender {
    
    [self pickerViewShow];
}

- (void)pickerViewShow{
    NSMutableArray *bandArray = [NSMutableArray array];
    int current_index=0;
    for (int i = 0; i < self.payInfoModel.support.count ;i++) {
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:self.payInfoModel.support[i]];
        [bandArray addObject:dic[@"bank_name"]];
    }
    for (int i = 0; i <bandArray.count; i++) {
        NSString *temp_bankname=bandArray[i];
        if ([temp_bankname isEqualToString:_resultString]) {
            current_index = i;
            break;
        }
    }
    __weak typeof(self) weakSelf=self;
    NSNumber *current_s;
    current_s = [NSNumber numberWithInt:current_index];
    
    [ActionSheetStringPicker showPickerWithTitle:nil rows:@[[bandArray copy]] initialSelection:@[current_s] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
        
        NSString *selValue = [selectedValue firstObject];
        weakSelf.resultString = selValue;
        
    } cancelBlock:nil origin:self.view];
    
}

- (void)setResultString:(NSString *)resultString{
    
    int sel_index = -1;
    for (int i = 0; i < self.payInfoModel.support.count ;i++) {
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:self.payInfoModel.support[i]];
        if ([resultString isEqualToString:dic[@"bank_name"]]) {
            sel_index = i;
            break;
        };
    }
    if (sel_index != -1) {
        _bankcode_index = sel_index;
        _resultString = resultString;
    }else{
        _bankcode_index = 0;
        _resultString = @"";
    }
    
    if (resultString == nil || [resultString isEqualToString:@""]) {
        self.reachTimeLabel.text = @"该银行提现，会在次日前到账";
        self.chooseBandButton.title = @"请选择银行";
        [self.chooseBandButton setTitleColor:[UIColor hexStringToColor:@"C8C7CC"] forState:UIControlStateNormal];
    }else{
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:self.payInfoModel.support[_bankcode_index]];
        self.reachTimeLabel.text = [NSString stringWithFormat:@"该银行提现,会在%@",dic[@"time"]];
        self.chooseBandButton.title = resultString;
        [self.chooseBandButton setTitleColor:[UIColor hexStringToColor:@"383840"] forState:UIControlStateNormal];
    }
}

- (int)usageStr:(NSString *)str
{
    for (int i=0; i < usageArr.count; i++) {
        
        if ([str isEqualToString:usageArr[i]]) {
            return i+1;
        }
    }
    return 0;
}

- (IBAction)bandNoticeButton:(UIButton *)sender {
    
//#warning 到账通知 URL 要换
//    LMSWebViewController *web = [[LMSWebViewController alloc] init];
//    web.webUrl = [[NSString stringWithFormat:@"%@%@",LMSDomain,VIOLATE_URL] normalH5Url];
//    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)telephoneTap:(UITapGestureRecognizer *)sender {
    
    [self.alert show];
}

- (IBAction)getCodeButton:(UIButton *)sender {
    
    [self getSmsCodewithType:@0];
}

/*
 语音验证码
 */
- (IBAction)getSoundCodeBtnClick:(UIButton *)sender {
    
    [self getSmsCodewithType:@1];
}

- (void)getSmsCodewithType:(NSNumber *)type{
    
    if ([LMSTool judgeStringIsEmpty:_resultString]) {
        
        [self.view makeToast:@"银行不能为空！" duration:1.0 position:@"center"];
        return;
    }
    
    if ([LMSTool judgeStringIsEmpty:self.bandNumTextFiled.text]) {
        
        [self.view makeToast:@"银行卡号不能为空!" duration:1.0 position:@"center"];
        return;
    }
    
    if ([LMSTool judgeStringIsEmpty:self.telephoneTextFiled.text]) {
        
        [self.view makeToast:@"银行预留手机号不能为空!" duration:1.0 position:@"center"];
        return;
    }
    
    if ([LMSTool isMobileNumber:self.telephoneTextFiled.text] == NO) {
        
        [self.view makeToast:@"手机号码格式错误!" duration:1.0 position:@"center"];
        return;
    }
    
    if (![LMSBankCardManager checkCardNo:self.bandNumTextFiled.text]) {
        
        [self.view makeToast:@"暂不支持该银行卡支付，请使用支持的银行卡!" duration:1.0 position:@"center"];
        return;
    }
    /*
     pay/bind
     
     request :
     {
     card_no : 11212032312,  //银行卡号
     bank_name: 中国银行, //银行名称，
     bank_code : CBC, //银行编号
     phone : 18800019205, //预留手机号
     }
     
     response:
     {
     requestno: RWH121230123, //请求参数
     bankcode:
     }
     
     */
    NSDictionary * supportDic = self.payInfoModel.support[_bankcode_index];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.bandNumTextFiled.text,@"card_no",
                           _resultString,@"bank_name",
                           supportDic[@"bank_code"],@"bank_code",
                           self.telephoneTextFiled.text,@"phone",
                           type,@"type",nil];
    
    __weak typeof(self) weakSelf = self;
    [LMSLoadingHUD showInView:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[LMSPayViewModel sharePayViewModel] getPayBind:dict CallBack:^(BOOL success, id data) {
            
            if (success) {
                
                isGetSmsCode = 2;
                
                if ([type  isEqual: @0]) {
                     [self.view makeToast:@"短信验证码已发送成功，请注意查收" duration:1.0 position:@"center"];
                }else{
                    [weakSelf.view makeToast:@"语音验证码获取成功，请注意接听" duration:1.0 position:@"center"];
                }
                weakSelf.smsCodeResponseModel = [LMSPayAddCardSmsCodeResponseModel mj_objectWithKeyValues:data];
                
                for (int i = 0; i < self.payInfoModel.support.count ;i++) {
                    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:weakSelf.payInfoModel.support[i]];
                    if ([weakSelf.smsCodeResponseModel.bank_code isEqualToString:dic[@"bank_code"]]) {
                        weakSelf.resultString=dic[@"bank_name"];
                        
                        break;
                    };
                }
                weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(refreshTimerUI) userInfo:nil repeats:YES];
                [weakSelf.timer fire];
            }else{
                
                [self smsTimerZero];
            }
            [LMSLoadingHUD hide];
        }];
    });
}

- (void)refreshTimerUI{
    
    self.soundSmsCodeBtn.userInteractionEnabled = NO;
    self.getSmsCodeBtn.userInteractionEnabled = NO;
    self.smsSoundTimer.hidden   = NO;
    self.soundSmsCodeBtn.hidden = YES;
    self.smsSoundTimer.text = [NSString stringWithFormat:@"%ds",self.time];
    [self.getSmsCodeBtn setTitle:[NSString stringWithFormat:@"%ds",self.time] forState:UIControlStateNormal];
    self.time -= 1;
    if (self.time == 0) {
        
        [self smsTimerZero];
    }
}

- (void)smsTimerZero{
    
    self.soundSmsCodeBtn.userInteractionEnabled = YES;
    self.getSmsCodeBtn.userInteractionEnabled = YES;
    self.smsSoundTimer.hidden = YES;
    self.soundSmsCodeBtn.hidden = NO;
    [self.getSmsCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    self.time = 120;
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)nextButton:(UIButton *)sender {
    
    // 调用
    if (self.codeTextFiled.text == nil || [self.codeTextFiled.text isEqualToString:@""]) {
        
        [self.view makeToast:@"短信验证码不能为空" duration:1.0 position:@"center"];
        return;
    }
    /*
     pay/bind/confirm, 绑卡验证码
     request :
     {
     smd_code : 14122, //办卡验证码
     requestno : RWHsdfssd, //请求编号
     }
     
     response:{
     bind_id: 绑卡id
     }
     */
    
    if (isGetSmsCode == 1) {
        
        [self.view makeToast:@"请先获取验证码" duration:1.0 position:@"center"];
        return;
    }
   
    [LMSLoadingHUD showInView:self.view];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.codeTextFiled.text,@"sms_code",
                           self.smsCodeResponseModel.request_no,@"requestno",nil];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[LMSPayViewModel sharePayViewModel] getPayBindConfirm:dict CallBack:^(BOOL success, id data) {
            
            if (success) {
                
                [LMSNotificationCenter postNotificationName:LMSAddCardsuccess object:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    if (weakSelf.addFrom == ReplaceCard) {
                        LMSBankCardSuccessController * successVC = [[LMSBankCardSuccessController alloc] initWithNibName:@"LMSBankCardSuccessController" bundle:nil];
                        if (weakSelf.addFrom == Repayment) {
                            successVC.addSuccessAmount = weakSelf.addBandAmount;
                        }
                        successVC.vcStyle = weakSelf.addFrom;
                        [weakSelf.navigationController pushViewController:successVC animated:YES];
                    }else{
                        LMSAddBandSuccessVC * successVC = [[LMSAddBandSuccessVC alloc] initWithNibName:@"LMSAddBandSuccessVC" bundle:nil];
                        if (weakSelf.addFrom == Repayment) {
                            successVC.addSuccessAmount = weakSelf.addBandAmount;
                        }
                        successVC.vcStyle = weakSelf.addFrom;
                        [weakSelf.navigationController pushViewController:successVC animated:YES];
                    }
                    
                });
            }
            //[self smsTimerZero];
            [LMSLoadingHUD hide];
        }];
    });
}

- (LMSCustomAlertView *)alert
{
    if (!_alert) {
        _alert = [LMSCustomAlertView viewFromXib];
        _alert.alertContentHigh.constant = 80;
        _alert.allHeight.constant = 160;
        _alert.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [[UIApplication sharedApplication].keyWindow addSubview:_alert];
        
        LMSIntrodutionView *comm = [LMSIntrodutionView viewFromXib];
        comm.frame = CGRectMake(0, 0, 280, 80);
        comm.titleLabel.text = @"预留手机号说明";
        comm.titleLabel.textColor = [UIColor hexStringToColor:@"000000"];
        comm.textLabel.text = @"预留手机号是办理银行卡时所填写的手机号码。没有预留、手机号忘记或者已经停用，请联系银行客服处理。";
        comm.textLabel.font = HelveticaNeueLightFont(15);
        comm.textLabel.textAlignment = NSTextAlignmentCenter;
                
        [_alert.containerView addSubview:comm];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, _alert.buttonBgView.width, _alert.buttonBgView.height);
        [btn setTitle:@"知道了"];
        btn.titleLabel.font = HelveticaNeueLightFont(16);
        [btn setTitleColor:UIColorWithHex(0xF73E3E)];
        [btn addTarget:self action:@selector(dismissAlert)];
        [_alert.buttonBgView addSubview:btn];
    }
    return _alert;
}

- (void)dismissAlert
{
    [self.alert dismiss];
    self.alert = nil;
}

- (void)initNavigation{
    
    NSArray * cardsArr = self.payInfoModel.cards;
    
    if (cardsArr.count == 0 || cardsArr == nil || self.addFrom == Recharge || self.addFrom == Withdraw || self.addFrom == Repayment || self.isLastOne == YES || self.addFrom == Authentication || self.addFrom == BuyProduct) {
        self.navigationItem.title = @"添加银行卡";
    }else{
        self.navigationItem.title = @"更换银行卡";
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationController.navigationBar.shadowImage = nil;
    [self setNavBarBgColorStyle:NavBarColorStyleMine];
    [self addBackButton];
}

- (void)addBackButton
{
    UIButton *btn;
    btn                 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.bounds          = CGRectMake(0, 0, 30, 18);
    [btn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addLeftBarItemCustomButton:btn];
}
- (void)backAction:(UIButton *)b
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pickerViewToolBarCancelClick{
    
    backBlackView.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.bandNumTextFiled resignFirstResponder];
    [self.telephoneTextFiled resignFirstResponder];
    [self.codeTextFiled resignFirstResponder];
    backBlackView.hidden = YES;
}

- (void)showKeyboard:(NSNotification *)notify
{
    backBlackView.hidden = YES;
    self.view.transform = CGAffineTransformIdentity;
    CGFloat animationDuration = [notify.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:animationDuration animations:^{
        
        self.view.transform = CGAffineTransformMakeTranslation(0, -80);
    }];
}

#pragma mark -UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (_bandNumTextFiled == textField) {
        NSString *bankName_L = [LMSBankCardManager returnBankName:textField.text];

        if ([bankName_L isEqualToString:@""]) {
            return;
        }
        for (int i = 0; i < self.payInfoModel.support.count ;i++) {
            NSDictionary * dic = [NSDictionary dictionaryWithDictionary:self.payInfoModel.support[i]];
            NSString *bankName = dic[@"bank_name"];
            if ([bankName_L rangeOfString:bankName].location !=NSNotFound) {
                self.resultString = bankName;
            }
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_bandNumTextFiled == textField && textField.text.length>16) {
        NSString *bankName_L = [LMSBankCardManager returnBankName:textField.text];
    
        if ([bankName_L isEqualToString:@""]) {
            return YES;
        }
        for (int i = 0; i < self.payInfoModel.support.count ;i++) {
            NSDictionary * dic = [NSDictionary dictionaryWithDictionary:self.payInfoModel.support[i]];
            NSString *bankName = dic[@"bank_name"];
            if ([bankName_L rangeOfString:bankName].location !=NSNotFound) {
                self.resultString = bankName;
            }
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
