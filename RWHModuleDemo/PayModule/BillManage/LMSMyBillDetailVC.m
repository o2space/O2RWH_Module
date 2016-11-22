//
//  LMSMyBillDetailVC.m
//  LetMeSpend
//
//  Created by lzj on 16/2/23.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSMyBillDetailVC.h"
#import "LMSMybillDetailHeadView.h"
#import "LMSMybillDetailCell.h"
#import "LMSMybillYearView.h"
#import "LMSRepaymentVC.h"
#import "LMSMyBillModel.h"
#import "LMSWebViewController.h"

@interface LMSMyBillDetailVC ()<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate>
{
    LMSMybillYearView *yearView;
    
    NSArray *dataArray;
    //排序之后的年数组
    NSArray *resultArray;
    //排序之后整体数组
    NSMutableArray *arrayMoney;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIDocumentInteractionController * documentIC;

@property (nonatomic,strong) NSIndexPath * index;

@end

@implementation LMSMyBillDetailVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self initNavigation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.analyticName = @"MyBillDetail";
    
    [self createUI];
    
    [self loadMyBillDetailData];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [LMSNotificationCenter addObserver:self selector:@selector(refreshLoadDetailVC) name:LMSPepaySuccessReturnMyBillDetail object:nil];
}

- (void)refreshLoadDetailVC{
   
    [LMSLoadingHUD showInView:self.view];
    NSMutableArray * refreshArr = [NSMutableArray arrayWithArray:arrayMoney];
    LMSRepay_Plan * repayModel = refreshArr[self.index.row];
    repayModel.status = @1;
    arrayMoney = [NSMutableArray arrayWithArray:refreshArr];
    [self.tableView reloadData];
    [LMSLoadingHUD hide];
}

#pragma mark 加载UI
- (void)createUI
{
    LMSMybillDetailHeadView *headView = [[[NSBundle mainBundle] loadNibNamed:@"LMSMybillDetailHeadView" owner:nil options:nil]firstObject];
    headView.height = 180;
    
    if (self.model.loan_money == nil) {
        headView.lblLoan_money.text = @"0";
    }else{
        headView.lblLoan_money.text = [NSString stringWithFormat:@"%@",self.model.loan_money];
    }
    
    NSArray *arrayPay_Plan = self.model.repay_plan;
    headView.lblPay_Month.text = [NSString stringWithFormat:@"分期%zd个月",arrayPay_Plan.count];
    headView.lblPass_time.text = [NSString stringWithFormat:@"审核通过%@",[LMSTimeHelper timeFormat:@"yyyy-MM-dd" andLongTime:[NSString stringWithFormat:@"%@",self.model.pass_time]]];
    self.tableView.tableHeaderView = headView;
        
    [self.tableView registerNib:[UINib nibWithNibName:@"LMSMybillDetailCell" bundle:nil] forCellReuseIdentifier:@"LMSMybillDetailCell"];
}
#pragma mark 跳转到合同预览
- (void)contractClick
{
    if (self.model.contract == nil || [self.model.contract isEqualToString:@""]) {
        ShowMsgTip(@"合同正在审核中");
        return;
    }
    LMSWebViewController *web = [[LMSWebViewController alloc] init];
    web.webUrl = [self.model.contract normalH5Url];
    web.flagFobbidenHttpHeader = YES;
    [self.navigationController pushViewController:web animated:YES];
}
#pragma mark 请求数据
- (void)loadMyBillDetailData
{
    dataArray = self.model.repay_plan;
    
    [self formYearToRecord];
    
    [self.tableView reloadData];
}

#pragma mark UITabelView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMSMybillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LMSMybillDetailCell"];
    
    cell.repayPlan = arrayMoney[indexPath.row];
    
    cell.string = resultArray[indexPath.row];
    
    if (indexPath.row > 0) {
        if ([[self string:resultArray[indexPath.row] andlc:0 len:4] isEqualToString:[self string:resultArray[indexPath.row-1] andlc:0 len:4]] ) {
            cell.TopView.hidden = YES;
            cell.lblTopContraint.constant = -8;
        }else{
            cell.TopView.hidden = NO;
            cell.lblTopContraint.constant = 20;
        }
    }
    
    __weak LMSMybillDetailCell *weakCell = cell;
    cell.btnClick = ^(){
        
        self.index = indexPath;
        __strong LMSMybillDetailCell *wsCell = weakCell;
        UITableViewCell *tempCell = (LMSMybillDetailCell *)[[wsCell.btnPay superview] superview];
        NSIndexPath *index = [tableView indexPathForCell:tempCell];
    
        LMSRepay_Plan *planModel = arrayMoney[index.row];
        
        int k = 0;
        for (int i = 0; i < arrayMoney.count; i++) {
            
            LMSRepay_Plan *planM = arrayMoney[i];
            if ([planM.status integerValue] != 1) {
                
                k = i;
                break;
            }
        }
        
        if (index.row != k) {
            
            NSString * str = [NSString stringWithFormat:@"确定先还%@月%@日的吗？",[self BillMonthString:[self string:[LMSTimeHelper timeFormat:@"yyyyMMdd" andLongTime:[NSString stringWithFormat:@"%ld",(long)planModel.repay_time]] andlc:4 len:2]],[self BillMonthString:[self string:[LMSTimeHelper timeFormat:@"yyyyMMdd" andLongTime:[NSString stringWithFormat:@"%ld",(long)planModel.repay_time]] andlc:6 len:2]]];
            LMSCommonAlertView * alert = [LMSCommonAlertView alertViewWithChangeTitle:@""
                                                                              message:str
                                                                       cancelBtnTitle:@"取消"
                                                                           okBtnTitle:@"确定"
                                                                  buttonTouchedAction:^{
                                                                      
                                                                      [self goToRepaymentVCWithPlanModel:planModel];
                                                                  }
                                                                        dismissAction:^{
                                                                            
                                                                            
                                                                        }];
            
            [alert show];
            return;
        }
        
        [self goToRepaymentVCWithPlanModel:planModel];
    };
    
    return cell;
}


//去还款
- (void)goToRepaymentVCWithPlanModel:(LMSRepay_Plan *)planModel{
    
    NSLog(@"planModel----%@",planModel.repay_id);
    LMSRepaymentVC *repaymentVC = [[LMSRepaymentVC alloc]init];
    repaymentVC.paymentType = LMSPaymentFromSinglePayType;
    repaymentVC.source_id   = planModel.repay_id;
    repaymentVC.fromVC      = LMSRepaymentFromMyDetailBill;
    [self.navigationController pushViewController:repaymentVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    LMSMybillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LMSMybillDetailCell"];
//    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height + 1;
    LMSMybillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LMSMybillDetailCell"];
    
    cell.repayPlan = arrayMoney[indexPath.row];
    cell.string = resultArray[indexPath.row];
    if (indexPath.row > 0) {
        if ([[self string:resultArray[indexPath.row] andlc:0 len:4] isEqualToString:[self string:resultArray[indexPath.row-1] andlc:0 len:4]] ) {
            cell.TopView.hidden = YES;
            cell.lblTopContraint.constant = -8;
            return 70;
        }else{
            cell.TopView.hidden = NO;
            cell.lblTopContraint.constant = 20;
            return 100;
        }
    }
    return 100;
}


#pragma mark 对年份进行排序
- (void)formYearToRecord
{
    NSMutableArray *arrayDate = [[NSMutableArray alloc]init];
    for (int i = 0; i<dataArray.count; i++) {
        LMSRepay_Plan *repayModel = dataArray[i];
        [arrayDate addObject:[LMSTimeHelper timeFormat:@"yyyyMMdd" andLongTime:[NSString stringWithFormat:@"%ld",(long)repayModel.repay_time]]];
    }
    NSComparator finderSort = ^(id string1,id string2){
        if ([string1 integerValue] > [string2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([string1 integerValue] < [string2 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
        //数组排序：
    resultArray = [arrayDate sortedArrayUsingComparator:finderSort];
    
    arrayMoney = [[NSMutableArray alloc]init];
    for (int i = 0; i<dataArray.count; i++) {
        for (int j = 0; j<dataArray.count; j++) {
            LMSRepay_Plan *repayModel = dataArray[j];
            if ([resultArray[i] isEqualToString:[LMSTimeHelper timeFormat:@"yyyyMMdd" andLongTime:[NSString stringWithFormat:@"%ld",(long)repayModel.repay_time]]]) {
                [arrayMoney addObject:dataArray[j]];
            }
        }
    }
}

- (NSString *)string:(NSString *)str andlc:(NSUInteger)lc len:(NSUInteger)len
{
    return [str substringWithRange:NSMakeRange(lc,len)];
}

- (NSString *)BillMonthString:(NSString *)str
{
    NSString *s = [str substringWithRange:NSMakeRange(0, 1)];
    if ([s isEqualToString:@"0"]) {
        return [str substringWithRange:NSMakeRange(1, 1)];
    }else{
        return str;
    }
}

#pragma mark UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}

- (void)initNavigation{
    
    self.navigationItem.title = @"账单详情";
    [self addBackButton];
    [self setNavBarBgColorStyle:NavBarColorStyleMine];
    [self addRightBarItemWithTitle:@"借款合同" Target:self Action:@selector(contractClick)];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
