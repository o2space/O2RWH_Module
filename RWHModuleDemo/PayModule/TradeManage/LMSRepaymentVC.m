//
//  LMSRepaymentVC.m
//  LetMeSpend
//
//  Created by liuhongmei on 16/2/20.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSRepaymentVC.h"
#import "LMSRepaymentTypeView.h"
#import "LMSMyBillVC.h"
#import "LMSMyBillDetailVC.h"
#import "LMSlineButton.h"
#import "LMSSimilarPickerView.h"
#import "LMSLoanViewModel.h"
#import "LMSWebViewController.h"
#import "LMSRechargeVC.h"
#import "LMSAddBandCardVC.h"

@interface LMSRepaymentVC ()<LMSRepaymentTypeViewDelegate>
{
    __weak IBOutlet NSLayoutConstraint *topViewWidthConstraints;
    LMSRepaymentTypeView *typeView;
    //还款方式
    int payMode;
}

///抵用券view
@property (nonatomic,strong) LMSSimilarPickerView *similarPicker;
///抵用券列表
@property (nonatomic,strong) NSMutableArray *couponListArray;
@property (weak, nonatomic) IBOutlet UIView *repaymentTypeView;
@property (weak, nonatomic) IBOutlet UILabel *repaymentTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *repaymentMoneyLabel;
//还款失败支付宝转账
@property (weak, nonatomic) IBOutlet UIButton *redTextButton;
@property(nonatomic,strong)LMSLoadPayTaskModel *payTaskModel;

@end

@implementation LMSRepaymentVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [LMSLoanViewModel sharedLoan].applyLoan.coupon_id = nil;
    
    [self initNavigation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.analyticName = @"Repayment";
    // Do any additional setup after loading the view from its nib.
    
    payMode = 1;
    
    self.enablePanGesture = NO;
    
    [self loadPaymentWithFromType];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectRepaymentType:)];
    [self.repaymentTypeView addGestureRecognizer:tap];
    
    [self createTypeView];
}

- (IBAction)redTextButton:(LMSlineButton *)sender {
    
    LMSWebViewController *web = [[LMSWebViewController alloc] init];
    web.webUrl = [[NSString stringWithFormat:@"%@%@",LMSDomain,ALIPAY_URL] normalH5Url];
    [self.navigationController pushViewController:web animated:YES];
}

-(void)configUI
{
    self.repaymentMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[self.payTaskModel.recharge_amount doubleValue]];
    
    if ([self judgeAccountLeftIsEnough])
    {
        payMode = 1;
        self.repaymentTypeLabel.text = [NSString stringWithFormat:@"账户余额"];
    }
    else
    {
        payMode = 2;
        NSString *bankName = self.payTaskModel.bankname;
        NSString *cardno = self.payTaskModel.cardno;
        if ([LMSTool judgeStringIsEmpty:cardno]) {
            self.repaymentTypeLabel.text = @"暂无银行卡";
        }
        else
        {
            self.repaymentTypeLabel.text = (([LMSTool judgeStringIsEmpty:cardno]) ? @"暂无银行卡" : [NSString stringWithFormat:@"%@ 尾号%@",bankName ,[cardno substringWithRange:NSMakeRange(cardno.length - 4, 4)]]);
        }
    }
    [typeView updateTypeValue:[self judgeAccountLeftIsEnough] dataModel:self.payTaskModel];
}

- (IBAction)ensurePayBtnClick:(id)sender
{
    if (payMode == 2) {
        
        if ([LMSTool judgeStringIsEmpty:self.payTaskModel.cardno]) {
            
            LMSAddBandCardVC * addVC = [[LMSAddBandCardVC alloc]init];
            addVC.addFrom = Repayment;
            addVC.timeOut = NSNotFound;
            addVC.addBandAmount = [self.payTaskModel.recharge_amount doubleValue];
            [self.navigationController pushViewController:addVC animated:YES];
        }else{
            
            LMSRechargeVC * rechargeVC = [[LMSRechargeVC alloc]init];
            rechargeVC.rechargeType    = LMSRechargeTypeRepayment;
            rechargeVC.source_id       = [self.source_id integerValue];
            rechargeVC.amount          = [self.payTaskModel.recharge_amount doubleValue];
            if (self.fromVC == LMSRepaymentFromMyBill) {
                
                rechargeVC.fromVC      =  LMSRechargeFromMyBill;
            }
            if (self.fromVC == LMSRepaymentFromMyDetailBill) {
                
                rechargeVC.fromVC      = LMSRechargeFromMyDetailBill;
            }
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
    }else{
     
         [self confirmPayment];
    }
}

-(void)confirmPayment
{
    [LMSLoadingHUD showInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          Token,@"Authorization",
                          MemberID,@"member_id",
                          self.source_id,@"source_id",
                          @(self.paymentType),@"source_type",
                          @(payMode),@"pay_mode",
                          nil];
    //只有余额在这提交
    [[NetworkManager defaultManager] POSTWithURL:paymentSubmitPayURL parameters:dic success:^(id responseObject) {
        NetResponse *rep = (NetResponse *)responseObject;
        [LMSLoadingHUD hide];
        switch (rep.status) {
            case kServerStateSuccess:
            {
                [weakSelf.view makeToast:@"支付成功" duration:1.0 position:@"center"];
                
                [LMSNotificationCenter postNotificationName:LMSRepaySuccessReturnMyBill object:self.payTaskModel.recharge_amount];
                
                [LMSNotificationCenter postNotificationName:LMSPepaySuccessReturnMyBillDetail object:nil];
                
                [self performSelector:@selector(gotoOrderProgressVC) withObject:nil afterDelay:2.0];
            }
                break;
                
            default:
            {
                [weakSelf.view makeToast:rep.message duration:1 position:@"center"];
            }
                break;
        }
        
    } failure:^(NSError *error)
     {
         [LMSLoadingHUD hide];
         [weakSelf.view makeToast:[NSString stringWithFormat:@"%@",error] duration:1 position:@"center"];
     }];
}

#pragma mark -  LMSRepaymentTypeViewDelegate
-(void)deliverMode:(int)mode
{
    payMode = mode;
    if (payMode == 1)
    {
        self.repaymentTypeLabel.text = [NSString stringWithFormat:@"账户余额"];
    }
    else
    {
        NSString *bankName = self.payTaskModel.bankname;
        NSString *cardno = self.payTaskModel.cardno;
         self.repaymentTypeLabel.text = (([LMSTool judgeStringIsEmpty:cardno]) ? @"暂无银行卡" : [NSString stringWithFormat:@"%@ 尾号%@",bankName ,[cardno substringWithRange:NSMakeRange(cardno.length - 4, 4)]]);
    }
}

-(BOOL)judgeAccountLeftIsEnough
{
    //1.判断余额是否足够
    NSString *truePaymentStr = [NSString stringWithFormat:@"%@",self.payTaskModel.recharge_amount];
    NSString *accountLeftStr = [NSString stringWithFormat:@"%@",self.payTaskModel.balance_money];;
    float tmpValue = [truePaymentStr doubleValue] - [accountLeftStr doubleValue];
    if (tmpValue > 0) {
        //不足
        return NO;
    }else{
        return YES;
    }
}

-(void)gotoOrderProgressVC
{
    //还款   调回还款列表
    if (self.fromVC == LMSRepaymentFromMyBill) {
        
        for (int i=0; i < self.navigationController.viewControllers.count; i++) {
            if ([self.navigationController.viewControllers[i] isKindOfClass:[LMSMyBillVC class]]) {
                [self.navigationController popToViewController:self.navigationController.viewControllers[i] animated:YES];
                return;
            }
        }
    }
    
    if (self.fromVC == LMSRepaymentFromMyDetailBill) {
        
        for (int i=0; i < self.navigationController.viewControllers.count; i++) {
            if ([self.navigationController.viewControllers[i] isKindOfClass:[LMSMyBillDetailVC class]]) {
                [self.navigationController popToViewController:self.navigationController.viewControllers[i] animated:YES];
                return;
            }
        }
    }
//    }
}

//支付信息
-(void)loadPaymentWithFromType
{
    [LMSLoadingHUD showInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    NSDictionary * dic= [NSDictionary dictionaryWithObjectsAndKeys:
                         Token,@"Authorization",
                         MemberID,@"member_id",
                         @(self.paymentType),@"source_type",
                         self.source_id,@"source_id",
                         nil];
    
    [[NetworkManager defaultManager] POSTWithURL:paymentConfirmPayURL parameters:dic success:^(id responseObject) {
        NetResponse *rep = (NetResponse *)responseObject;
        [LMSLoadingHUD hide];
        switch (rep.status) {
            case kServerStateSuccess:
            {
                NSDictionary *dic = (NSDictionary *)rep.data;
                weakSelf.payTaskModel = [LMSLoadPayTaskModel mj_objectWithKeyValues:dic];
                [weakSelf configUI];
            }
                break;
                
            default:
            {
                [weakSelf.view makeToast:rep.message duration:1 position:@"center"];
            }
                break;
        }
    } failure:^(NSError *error)
     {
         [LMSLoadingHUD hide];
         [weakSelf.view makeToast:@"网络连接失败" duration:1 position:@"center"];
     }];
}

- (void)createTypeView{
    
    typeView = [[NSBundle mainBundle]loadNibNamed:@"LMSRepaymentTypeView" owner:self options:nil][0];
    typeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    typeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:typeView];
    typeView.delegate = self;
    
    typeView.hidden = YES;
}

-(void)selectRepaymentType:(UITapGestureRecognizer *)tap
{
    typeView.hidden = NO;
    typeView.bottomConstraints.constant = 0;
    // 更改约束条件
    [UIView animateWithDuration:0.5 animations:^{
        
        [typeView layoutIfNeeded];
        [typeView updateConstraints];
    }];
}

- (void)initNavigation{
    
    [self addBackButton];
    self.navigationItem.title = @"还款";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.view resetDeviderLineToOnePixel];
    [self setNavBarBgColorStyle:NavBarColorStyleMine];
    topViewWidthConstraints.constant = ScreenWidth;
}

#pragma mark - 返回按钮
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

- (void)backAction:(UIButton *)sender
{
    [self gotoOrderProgressVC];
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
