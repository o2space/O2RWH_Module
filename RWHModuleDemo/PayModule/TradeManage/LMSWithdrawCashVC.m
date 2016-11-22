//
//  LMSWithdrawCashVC.m
//  LetMeSpend
//
//  Created by zy on 16/7/11.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSWithdrawCashVC.h"
#import "LMSPayInfoModel.h"
#import "LMSPayViewModel.h"
#import "ZHPickView.h"
#import "LMSIntrodutionView.h"

@interface LMSWithdrawCashVC ()<ZHPickViewDelegate,UITextFieldDelegate>{
    
    NSArray *usageArr;
    NSString *_resultString;
    UIView * backBlackView;
}


@property (nonatomic,strong) LMSPayInfoModel * payInfo;

@property (nonatomic,strong) LMSUserAllInfoModel * allInfo;

@property (nonatomic,strong) ZHPickView *pickview;

@property (nonatomic,strong)LMSCustomAlertView *alert;

@property (nonatomic,strong) NSArray * sortArr;

@end

@implementation LMSWithdrawCashVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self initNavigation];
    
    self.view.hidden = YES;
    
    [self loadPayInfoData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.enablePanGesture = NO;
    
    if (IS_LOGIN) {
        _withdrawTextFiled.delegate = self;
        [_withdrawTextFiled addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerViewToolBarCancelClick) name:LMSPickerViewCancel object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    backBlackView.hidden = YES;
    [_pickview remove];
}

- (void)refreshWithdrawUI{
    
    self.withDrawBtn.layer.cornerRadius = 6.0;
    self.withDrawBtn.layer.masksToBounds = YES;
    
    NSNumber * balance_money;
    if (self.payInfo.balance_money == nil) {
        balance_money = @600;
    }else{
        
        NSDecimalNumber * str = [LMSTool roundUp:[self.payInfo.balance_money doubleValue] afterPoint:2];
        balance_money = str;
    }
    
    self.rightTopLabel.text = [NSString stringWithFormat:@"可提现金额%@元",balance_money];
    
    self.noticeLabel.text = self.payInfo.withdraw_notice;
    [self showView2CardStateTips];
    
    if (self.sortArr.count != 0) {
     
        NSDictionary * cardDic = self.sortArr[0];
        NSString * cardNo = cardDic[@"cardno"];
        NSString *lastFourNumber = [cardNo substringWithRange:NSMakeRange(cardNo.length - 4, 4)];
        self.bandLabel.text = [NSString stringWithFormat:@"%@ 尾号%@",cardDic[@"bankname"],lastFourNumber];
        self.lastLabel.text = [NSString stringWithFormat:@"%@",cardDic[@"expect_time"]];
    }
    
    if (!backBlackView) {
    
        backBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:backBlackView];
        backBlackView.backgroundColor = [UIColor blackColor];
        backBlackView.alpha = 0.6f;
        backBlackView.hidden = YES;
    }
}

- (void)loadPayInfoData{
    
    __weak typeof(self) weakSelf = self;
    
    [LMSLoadingHUD showInView:LMKeyWindow];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil];
    [[LMSPayViewModel sharePayViewModel] getPayInfo:params CallBack:^(BOOL success, id data) {
        
        if (success) {
            
            weakSelf.payInfo = [LMSPayInfoModel mj_objectWithKeyValues:data];
            [LMSPayInfoModel savePayInfoToFile:self.payInfo];
            weakSelf.sortArr = [weakSelf sortCardsArr];
            [weakSelf refreshWithdrawUI];
            weakSelf.view.hidden = NO;
            [weakSelf.withdrawTextFiled becomeFirstResponder];
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

- (void)showView2CardStateTips{
    if (self.payInfo.bind_card_status == nil) {
        _vwCardStateTips.hidden = YES;
        _height_vwCardStateTips.constant = 0;
    }
    NSDictionary *withdrawTipDic = [self.payInfo.bind_card_status valueForKey:@"withdraw"];
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
    NSDictionary *withdrawTipDic = [self.payInfo.bind_card_status valueForKey:@"withdraw"];
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

- (IBAction)withDrawBtnClick:(UIButton *)sender {
    
    [self.withdrawTextFiled resignFirstResponder];
    
    if ([self.withdrawTextFiled.text doubleValue] < [self.payInfo.withdraw_min_limit doubleValue]) {
        
        [self.view makeToast:[NSString stringWithFormat:@"提现金额不能小于%d元！",[self.payInfo.withdraw_min_limit intValue]] duration:1.0 position:@"center"];
        return;
    }
    
    if ([self.withdrawTextFiled.text doubleValue] > [self.payInfo.balance_money doubleValue]) {
        
        NSDecimalNumber * pay_fee = [LMSTool roundUp:[self.payInfo.balance_money doubleValue] afterPoint:2];
        [self.view makeToast:[NSString stringWithFormat:@"最多可提现%@元",pay_fee] duration:1.0 position:@"center"];
        return;
    }
    
    [self.withdrawWarningAlert show];
}

- (IBAction)chooseBankTap:(UITapGestureRecognizer *)sender {
    
//    [self pickerViewShow];
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

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.withdrawTextFiled.text doubleValue] > [self.payInfo.balance_money doubleValue]) {
        
        NSDecimalNumber * pay_fee = [LMSTool roundUp:[self.payInfo.balance_money doubleValue] afterPoint:2];
        [self.view makeToast:[NSString stringWithFormat:@"最多可提现%@元",pay_fee] duration:1.0 position:@"center"];
        return;
    }
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
    NSDictionary * cardDic = self.sortArr[_pickview.selectRow];
    NSString * cardNo = cardDic[@"cardno"];
    NSString *lastFourNumber = [cardNo substringWithRange:NSMakeRange(cardNo.length - 4, 4)];
    self.bandLabel.text = [NSString stringWithFormat:@"%@ 尾号%@",cardDic[@"bankname"],lastFourNumber];
    self.lastLabel.text = [NSString stringWithFormat:@"%@",cardDic[@"expect_time"]];
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

#pragma mark -提现弹框提醒
- (LMSCustomAlertView *)withdrawWarningAlert
{
    /*
     0.成功
     1.未学信
     2.未实名
     3.未同盾不达标
     4.学校不达标
     5.年级不达标
     6.已经有一笔借款申请中
     7.小额 有一笔小额正在还款（）
     8.商品 有一笔商品正在还款（）
     */    
    
    if (!_alert) {
        _alert = [LMSCustomAlertView viewFromXib];
        _alert.alertContentHigh.constant = 80;
        _alert.allHeight.constant = 130;
        _alert.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [[UIApplication sharedApplication].keyWindow addSubview:_alert];
        
        LMSIntrodutionView *comm = [LMSIntrodutionView viewFromXib];
        comm.frame = CGRectMake(0, 0, 295, 50);
        comm.titleLabel.text = @"";
        comm.titleLabel.textColor = [UIColor hexStringToColor:@"000000"];
        comm.textLabel.text = @"承诺为你代还的都是骗子,逾期后果还需自己承担";
        comm.textLabel.font = HelveticaNeueLightFont(15);
        comm.textLabel.textAlignment = NSTextAlignmentCenter;
        
        [_alert.containerView addSubview:comm];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, _alert.buttonBgView.width, _alert.buttonBgView.height);
        [btn setTitle:@"知道了"];
        btn.titleLabel.font = HelveticaNeueLightFont(16);
        [btn setTitleColor:UIColorWithHex(0xF73E3E)];
        [btn addTarget:self action:@selector(dismissAlert1)];
        [_alert.buttonBgView addSubview:btn];
    }
    return _alert;
}

- (void)dismissAlert1
{
    [self.alert dismiss];
    self.alert = nil;
    
    /*
     pay/withdraw  提现
     {
     bind_id: 1201, 绑卡id
     money: 90.23, 金额
     }
     response:
     {
     status : 0
     }
     */
    
    [LMSLoadingHUD showInView:self.view];
    
    if (self.sortArr.count != 0){
        
        NSDictionary * cardsDic = [NSDictionary dictionaryWithDictionary: self.sortArr[_pickview.selectRow]];
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               cardsDic[@"bind_id"],@"bind_id",
                               self.withdrawTextFiled.text,@"money",nil];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [[LMSPayViewModel sharePayViewModel] getPayWithdraw:dict CallBack:^(BOOL success, id data) {
                
                if (success) {
                    
                    [LMSNotificationCenter postNotificationName:LMSWithdrawSuccess object:nil];
                    [self.view makeToast:@"提现请求提交成功,最迟次日到账" duration:1.0 position:@"center"];
                    
                    [self performSelector:@selector(backAction:) withObject:nil afterDelay:2.0];
                }
                [LMSLoadingHUD hide];
            }];
        });
    }
}

#pragma mark -导航栏等
- (void)initNavigation{
    
    self.navigationItem.title = @"提现";
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
    
    [self.withdrawTextFiled resignFirstResponder];
    backBlackView.hidden = YES;
    [self.pickview remove];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
