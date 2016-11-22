//
//  LMSRechargeVC.m
//  LetMeSpend
//
//  Created by zy on 16/7/11.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSRechargeVC.h"
#import "LMSPayInfoModel.h"
#import "LMSPayViewModel.h"
#import "ZHPickView.h"
#import "LMSMyBillVC.h"
#import "LMSMyBillDetailVC.h"

@interface LMSRechargeVC ()<ZHPickViewDelegate,UITextFieldDelegate>{
    
    NSArray *usageArr;
    NSString *_resultString;
    UIView * backBlackView;
    int isGetsmsCode;
}

@property (nonatomic,strong) NSTimer * timer;

@property (nonatomic,assign) int time;

@property (nonatomic,strong) LMSPayInfoModel * payInfo;

@property (nonatomic,strong) LMSPayRechargeSmsCodeResponseModel * smsResponseModel;

@property (nonatomic,strong) LMSPayRechargeConfirmResponseModel * confirmResponseModel;

@property (nonatomic,strong) LMSPayRechargeQueryResponseModel * queryResponseModel;

@property (nonatomic,strong) LMSUserAllInfoModel * allInfo;

@property (nonatomic,strong) ZHPickView *pickview;

@property (nonatomic,strong) NSArray * sortArr;

@property (weak, nonatomic) IBOutlet UIButton *soundSmsCodeBtn;

@property (weak, nonatomic) IBOutlet UILabel *smsSoundTimer;


@end

@implementation LMSRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.enablePanGesture = NO;
    
    [self fromRepayment];
    
    if (IS_LOGIN) {
        _moneyTextFiled.delegate = self;
        [_moneyTextFiled addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerViewToolBarCancelClick) name:LMSPickerViewCancel object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self initNavigation];
    
    self.view.hidden = YES;
    isGetsmsCode = 1;
    
    [self loadPayInfoData];
    self.moneyTextFiled.userInteractionEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isGetSmsCode) name:getSmsCode object:nil];
}

- (void)isGetSmsCode{
    
    //isGetsmsCode = 1;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    backBlackView.hidden = YES;
    [_pickview remove];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:getSmsCode object:nil];
}

- (void)fromRepayment{
    
    if(self.rechargeType == LMSRechargeTypeRepayment){
     
        self.moneyTextFiled.text = [NSString stringWithFormat:@"%.2f",self.amount];
        self.moneyTextFiled.userInteractionEnabled = NO;
    }
}

- (void)loadPayInfoData{
    __weak typeof(self) weakSelf = self;
    [LMSLoadingHUD showInView:LMKeyWindow];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil];
    [[LMSPayViewModel sharePayViewModel] getPayInfo:params CallBack:^(BOOL success, id data) {
        
        if (success) {
            
            weakSelf.payInfo = [LMSPayInfoModel mj_objectWithKeyValues:data];
            [LMSPayInfoModel savePayInfoToFile:weakSelf.payInfo];
            weakSelf.sortArr = [weakSelf sortCardsArr];
            [weakSelf refreshRechargeUI];
            weakSelf.view.hidden = NO;
            [weakSelf.moneyTextFiled becomeFirstResponder];
        }
        [LMSLoadingHUD hide];
    }];
}

- (NSArray *)sortCardsArr{
    
    NSMutableArray * timeOutArr = [NSMutableArray array];
    NSMutableArray * statusArr  = [NSMutableArray array];
    NSMutableArray * changeArr  = [NSMutableArray array];
    NSMutableArray * cardsArr   = [NSMutableArray arrayWithArray:self.payInfo.cards];
    
    for (int i = 0; i < cardsArr.count; i++) {
        
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:cardsArr[i]];
        if ([dic[@"status"] intValue] == 0){
            
            [timeOutArr addObject:cardsArr[i]];
        }
        if ([dic[@"status"] intValue] == 1) {
            
            [statusArr addObject:cardsArr[i]];
        }
        if ([dic[@"status"] intValue] == 2) {
            
            [changeArr addObject:cardsArr[i]];
        }
    }
    [statusArr addObjectsFromArray:changeArr];
    [statusArr addObjectsFromArray:timeOutArr];
    
    return statusArr;
}

- (void)refreshRechargeUI{
    
    self.time = 120;
    self.rechargebtn.layer.cornerRadius = 6.0;
    self.rechargebtn.layer.masksToBounds = YES;
    self.lastLabel.text = self.payInfo.pay_notice;
    [self showView2CardStateTips];
    
    if (self.sortArr.count != 0) {
    
        NSDictionary * cardsDict = self.sortArr[0];
        NSString * cardNo = cardsDict[@"cardno"];
        NSString *lastFourNumber = [cardNo substringWithRange:NSMakeRange(cardNo.length - 4, 4)];
        self.bandLabel.text = [NSString stringWithFormat:@"%@ 尾号%@",cardsDict[@"bankname"],lastFourNumber];
    }
    
    backBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:backBlackView];
    backBlackView.backgroundColor = [UIColor blackColor];
    backBlackView.alpha = 0.6f;
    backBlackView.hidden = YES;
}

- (void)showView2CardStateTips{
    if (self.payInfo.bind_card_status == nil) {
        _vwCardStateTips.hidden = YES;
        _height_vwCardStateTips.constant = 0;
    }
    NSDictionary *withdrawTipDic = [self.payInfo.bind_card_status valueForKey:@"pay"];
    if ([[withdrawTipDic valueForKey:@"status"] integerValue] == 0) {
        _vwCardStateTips.hidden = YES;
        _height_vwCardStateTips.constant = 0;
    }else{
        _vwCardStateTips.hidden = NO;
        _height_vwCardStateTips.constant = 36;
        
        NSString *str = [NSString stringWithFormat:@"%@ 查看帮助",[withdrawTipDic valueForKey:@"message"]];
        NSMutableAttributedString * tipStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange range = NSMakeRange(tipStr.length-4, 4);
        NSRange range2 = NSMakeRange(0, tipStr.length);
        [tipStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
        [tipStr addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"EFEFF4"] range:range2];
        
        [_btnCardStateTips setAttributedTitle:tipStr forState:UIControlStateNormal];
        
    }
    
    [self.view layoutIfNeeded];
}
- (IBAction)tapToHelpClick:(id)sender{
    NSLog(@"tapToHelpClick");
    NSDictionary *withdrawTipDic = [self.payInfo.bind_card_status valueForKey:@"pay"];
    NSString *webUrl = [withdrawTipDic valueForKey:@"url"];
    if (webUrl == nil || [webUrl isEqualToString:@""]) {
        return;
    }
    LMSWebViewController *web = [[LMSWebViewController alloc] init];
    web.webUrl = [webUrl normalH5Url];
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)tipsInfoCloseClick:(id)sender{
    _vwCardStateTips.hidden = YES;
    _height_vwCardStateTips.constant = 0;
    [self.view layoutIfNeeded];
}

- (IBAction)getSmsCodeBtnClick:(UIButton *)sender {
    
    [self getSmsCodeWithType:@0];
}

/*
 语音验证码
 */
- (IBAction)getSoundSmsCodeBtnClick:(UIButton *)sender {
    
    [self getSmsCodeWithType:@1];
}

- (void)getSmsCodeWithType:(NSNumber *)type{
    
    /*
     pay/recharge
     request:
     {
     bind_id: 1201, 绑卡id
     money: 90.23, 金额
     }
     
     response :
     {
     requestno:请求参数
     }
     */
    
    if([self.moneyTextFiled.text doubleValue] < [self.payInfo.pay_min_limit doubleValue]){
        
        NSDecimalNumber * payDeci = [LMSTool roundUp:[self.payInfo.pay_min_limit doubleValue] afterPoint:2];
        [self.view makeToast:[NSString stringWithFormat:@"最小充值金额为%@元",payDeci] duration:1.0 position:@"center"];
        return;
    }
    
    NSDictionary * cardsDic = self.sortArr[_pickview.selectRow];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           cardsDic[@"bind_id"],@"bind_id",
                           self.moneyTextFiled.text,@"money",
                           type,@"type",nil];
    
    __weak typeof(self) weakSelf = self;
    [LMSLoadingHUD showInView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[LMSPayViewModel sharePayViewModel] getPayRecharge:dict CallBack:^(BOOL success, id data) {
            
            if (success) {
                
                isGetsmsCode = 2;
                
                if ([type isEqual:@0]) {
                    
                    [self.view makeToast:@"短信验证码已发送成功，请注意查收" duration:1.0 position:@"center"];
                }else{
                    [self.view makeToast:@"语音验证码获取成功，请注意接听" duration:1.0 position:@"center"];
                }
                
                weakSelf.smsResponseModel = [LMSPayRechargeSmsCodeResponseModel mj_objectWithKeyValues:data];
                
                self.moneyTextFiled.userInteractionEnabled = NO;
                
                weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(refreshRechargeTimerUI) userInfo:nil repeats:YES];
                [weakSelf.timer fire];
                
            }else{
                [self zeroTimer];
            }
            [LMSLoadingHUD hide];
        }];
    });
}

- (void)refreshRechargeTimerUI{
    
    self.soundSmsCodeBtn.userInteractionEnabled = NO;
    self.getSmsCodeButton.userInteractionEnabled = NO;
    self.soundSmsCodeBtn.hidden = YES;
    self.smsSoundTimer.hidden   = NO;
    self.smsSoundTimer.text = [NSString stringWithFormat:@"%ds",self.time];
    [self.getSmsCodeButton setTitle:[NSString stringWithFormat:@"%ds",self.time] forState:UIControlStateNormal];
    self.time -= 1;
    if (self.time == 0) {
        
        [self zeroTimer];
    }
}

- (void)zeroTimer{
    
    self.soundSmsCodeBtn.userInteractionEnabled = YES;
    self.getSmsCodeButton.userInteractionEnabled = YES;
    self.soundSmsCodeBtn.hidden = NO;
    self.smsSoundTimer.hidden   = YES;
    [self.getSmsCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
    self.time = 120;
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)enSureRechargeBtnClick:(UIButton *)sender {
    
    /*
     pay/recharge/confirm  收到短信验证码后请求
     request:
     {
     smd_code : 14122, //办卡验证码
     requestno : RWHsdfssd, //请求编号
     source_type : 0, 充值结束后的操作
     source_id : 1， 充值后操作的对象
     bind_id :    绑定的银行卡id
     money：充值金额
     }
     
     response: 
     {
     status  : 0
     }
     */
    
    if([self.moneyTextFiled.text intValue] < [self.payInfo.pay_min_limit intValue]){
        
        NSDecimalNumber * payDeci = [LMSTool roundUp:[self.payInfo.pay_min_limit doubleValue] afterPoint:2];
        [self.view makeToast:[NSString stringWithFormat:@"最小充值金额为%@元",payDeci] duration:1.0 position:@"center"];
        return;
    }
    
    if ([LMSTool judgeStringIsEmpty:self.smsCodeTextFiled.text]) {
        
        [self.view makeToast:@"请填写验证码" duration:1.0 position:@"center"];
        return;
    }
    
    if (isGetsmsCode == 1) {
        
        [self.view makeToast:@"请先获取验证码" duration:1.0 position:@"center"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [LMSLoadingHUD showInView:self.view];
    NSDictionary * cardsDic = self.sortArr[_pickview.selectRow];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.smsCodeTextFiled.text,@"sms_code",
                           self.smsResponseModel.request_no,@"requestno",
                           @(self.rechargeType),@"source_type",
                           @(self.source_id),@"source_id",
                           cardsDic[@"bind_id"],@"bind_id",
                           self.moneyTextFiled.text,@"money",nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[LMSPayViewModel sharePayViewModel] getPayRechargeConfirm:params CallBack:^(BOOL success, id data) {
           
            if (success) {
                weakSelf.confirmResponseModel = [LMSPayRechargeConfirmResponseModel mj_objectWithKeyValues:data];
                
                [weakSelf rechagerQuery:0];
            }
            //[self zeroTimer];
            
            [LMSLoadingHUD hide];
        }];
    });
}

- (void)rechagerQuery:(int)over{
    
    [LMSLoadingHUD hide];
    if (over == 20)
    {
        [self.view makeToast:@"处理中,请稍后查询" duration:1.0 position:@"center"];
        return;
    }
    
    NSString * toastStr;
    if (self.rechargeType == LMSRechargeTypeRepayment) {
        
        toastStr = @"还款";
    }else{
        toastStr = @"充值";
    }

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.smsResponseModel.request_no,@"request_no",
                           nil];
    __weak typeof(self) weakSelf = self;
    [LMSLoadingHUD showInView:self.view];
    [[LMSPayViewModel sharePayViewModel] getPayRechargeQuery:dict type:self.rechargeType CallBack:^(BOOL success, id data) {
        
        if (success) {
            
            weakSelf.queryResponseModel = [LMSPayRechargeQueryResponseModel mj_objectWithKeyValues:data];
            
            if ([weakSelf.queryResponseModel.status intValue] == 1) {
                
                [LMSLoadingHUD hide];

                [weakSelf.view makeToast:[NSString stringWithFormat:@"%@成功!",toastStr] duration:1.0 position:@"center"];
                if(self.rechargeType == LMSRechargeTypeRepayment){
                    
                    [LMSNotificationCenter postNotificationName:LMSRepaySuccessReturnMyBill object:self userInfo:nil];
                    
                    [LMSNotificationCenter postNotificationName:LMSPepaySuccessReturnMyBillDetail object:nil];
                    
                    [self performSelector:@selector(goToBillVC) withObject:nil afterDelay:2.0];
                }else{
                                        
                    [self performSelector:@selector(goToRootVC) withObject:nil afterDelay:2.0];
                }
            }
            if ([weakSelf.queryResponseModel.status intValue] == 2 || [weakSelf.queryResponseModel.status intValue] == 0) {
                
                [LMSLoadingHUD hide];
                if(self.rechargeType == LMSRechargeTypeRepayment){
                    
                    [self.view makeToast:[NSString stringWithFormat:@"%@失败,请重试或使用支付宝还款",toastStr] duration:5.0 position:@"center"];
                }else{
                    [self.view makeToast:[NSString stringWithFormat:@"%@失败",toastStr] duration:2.0 position:@"center"];
                }
                return;
            }
            
            if([weakSelf.queryResponseModel.status intValue] == 4){
             
                [NSThread sleepForTimeInterval:3.0];
                [weakSelf rechagerQuery:over +1];
            }
        }else{
            
            [LMSLoadingHUD hide];
            if (self.rechargeType == LMSRechargeTypeRepayment) {
                
                [self.view makeToast:@"还款失败，请重试或使用支付宝还款" duration:5.0 position:@"center"];
            }
        }
    }];
}

- (IBAction)chooseBankLabelTap:(UITapGestureRecognizer *)sender {
    
//    [self pickerViewShow];
}

- (void)pickerViewShow{
    
    backBlackView.hidden = NO;
    
    NSMutableArray *bandArray = [NSMutableArray array];
    
    for (int i = 0; i < self.sortArr.count; i++) {
        
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:self.sortArr[i]];
        if ([dic[@"status"] intValue] == 1) {
            
            NSString * cardNo = dic[@"cardno"];
            NSString *lastFourNumber = [cardNo substringWithRange:NSMakeRange(cardNo.length - 4, 4)];
            NSString * bankNum = [NSString stringWithFormat:@"%@ 尾号%@",dic[@"bankname"],lastFourNumber];
            
            [bandArray addObject:bankNum];
        }
    }
    usageArr = bandArray;
    _pickview=[[ZHPickView alloc] initPickviewWithArray:bandArray isHaveNavControler:NO];
    [_pickview setPickViewColer:[UIColor whiteColor]];
    [_pickview setToolbarTintColor:[UIColor whiteColor]];
    _pickview.delegate=self;
    [_pickview show];
}

#pragma mark ZhpickVIewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    backBlackView.hidden = YES;
    self.bandLabel.text = resultString;
    _resultString = resultString;
}

- (void)textFieldChange:(UITextField *)textField
{
    NSMutableArray * textArray = [NSMutableArray array];
    NSArray *array = [textField.text componentsSeparatedByString:@"."];
    if (array.count > 2) {
        
        textField.text = [NSString stringWithFormat:@"%@.%@",array[0],array[1]];
    }
    if (array.count == 2) {
        
        if ([array.lastObject isEqual: @""]) {
            return;
        }
        for (int i = 0; i < 2; i++) {
            
            [textArray addObject:array[i]];
        }
        NSString * lastStr = [NSString stringWithFormat:@"%@",textArray.lastObject];
        NSString * last;
        if (lastStr.length > 2) {
            
            last = [lastStr substringWithRange:NSMakeRange(0, 2)];
        }else{
            last = lastStr;
        }
        NSString * textStr = [NSString stringWithFormat:@"%@.%@",textArray.firstObject,last];
        textField.text = textStr;
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

- (void)initNavigation{
    
    self.navigationItem.title = @"充值";
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

- (void)pickerViewToolBarCancelClick{
    
    backBlackView.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.smsCodeTextFiled resignFirstResponder];
    [self.moneyTextFiled resignFirstResponder];
    backBlackView.hidden = YES;
    [self.pickview remove];
}

- (void)backAction:(UIButton *)b
{
    if (self.rechargeType == LMSRechargeTypeRepayment) {
        
        [self goToBillVC];
        
    }else{
        [self goToRootVC];
    }
}

- (void)goToRootVC{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goToBillVC{
    
    if (self.fromVC == LMSRechargeFromMyBill) {
        
        for (int i=0; i < self.navigationController.viewControllers.count; i++) {
            if ([self.navigationController.viewControllers[i] isKindOfClass:[LMSMyBillVC class]]) {
                [self.navigationController popToViewController:self.navigationController.viewControllers[i] animated:YES];
                return;
            }
        }
    }
    if (self.fromVC == LMSRechargeFromMyDetailBill) {
        
        for (int i=0; i < self.navigationController.viewControllers.count; i++) {
            if ([self.navigationController.viewControllers[i] isKindOfClass:[LMSMyBillDetailVC class]]) {
                [self.navigationController popToViewController:self.navigationController.viewControllers[i] animated:YES];
                return;
            }
        }
    }
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
