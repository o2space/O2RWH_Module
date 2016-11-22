//
//  LMSBankCardSuccessController.m
//  LetMeSpend
//
//  Created by wukexiu on 16/9/12.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSBankCardSuccessController.h"
#import "LMSRechargeVC.h"
#import "LMSWithdrawCashVC.h"

@interface LMSBankCardSuccessController ()

@end

@implementation LMSBankCardSuccessController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self initNavigation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigation];
}

- (void)onRightBtn{
    
    /*
     1  正常绑卡成功 返回我的银行卡列表
     2  个人中心 充值没绑卡先绑卡后返回充值页面
     3  个人中心 提现没绑卡先绑卡后返回提现页面
     4  还款  选择银行卡时 银行卡绑卡后跳到充值页面
     5  实名认证 返回实名认证
     6  购买商品
     7  更换银行卡申请成功 返回我的银行卡列表
     */
    if (self.vcStyle == 5 || self.vcStyle == 6) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
        [arr removeLastObject];
        [arr removeLastObject];
        [self.navigationController setViewControllers:arr animated:YES];
    }
    if (self.vcStyle == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadBankCardInfoData" object:nil];
        NSMutableArray *arr = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
        [arr removeLastObject];
        [arr removeLastObject];
        [self.navigationController setViewControllers:arr animated:YES];
    }
    if (self.vcStyle == 7) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadBankCardInfoData" object:nil];
        NSMutableArray *arr = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
        [arr removeLastObject];
        [arr removeLastObject];
        [arr removeLastObject];
        [self.navigationController setViewControllers:arr animated:YES];
    }
    if (self.vcStyle == 2) {
        
        LMSRechargeVC * rechargeVC = [[LMSRechargeVC alloc]init];
        rechargeVC.rechargeType = LMSRechargeTypeRecharge;
        [self.navigationController pushViewController:rechargeVC animated:YES];
    }
    if (self.vcStyle == 3) {
        
        LMSWithdrawCashVC * withdrawVC = [[LMSWithdrawCashVC alloc]init];
        [self.navigationController pushViewController:withdrawVC animated:YES];
    }
    if (self.vcStyle == 4) {
        
        LMSRechargeVC * repaymentVC = [[LMSRechargeVC alloc]init];
        repaymentVC.rechargeType = LMSRechargeTypeRepayment;
        repaymentVC.amount = self.addSuccessAmount;
        [self.navigationController pushViewController:repaymentVC animated:YES];
    }
}

- (void)initNavigation{
    
    self.navigationItem.title = @"添加银行卡";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationController.navigationBar.shadowImage = nil;
    [self setNavBarBgColorStyle:NavBarColorStyleMine];
    self.navigationItem.hidesBackButton = YES;
    
    [self addRightBarItemWithTitle:@"完成" Target:self Action:@selector(onRightBtn)];
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
