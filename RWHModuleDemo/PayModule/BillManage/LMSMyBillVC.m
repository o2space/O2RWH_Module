//
//  LMSMyBillVC.m
//  LetMeSpend
//
//  Created by lzj on 16/2/24.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSMyBillVC.h"
#import "LMSMyBillCell.h"
#import "LMSBillView.h"
#import "LMSMyBillModel.h"
#import "LMSMyBillDetailVC.h"
#import "LMSRepaymentVC.h"
#import "LMSWebViewController.h"

@interface LMSMyBillVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;
//排序之后 外层大数组
@property (nonatomic,strong) NSMutableArray *arrayBigMonth;

@property (nonatomic,strong) NSMutableArray * arr;

@end

@implementation LMSMyBillVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initNavigation];
    
    [LMSNotificationCenter addObserver:self selector:@selector(loadMyBillData) name:LMSRepaySuccessReturnMyBill object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.analyticName = @"MyBill";
    
    [self loadMyBillData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LMSMyBillCell" bundle:nil] forCellReuseIdentifier:@"LMSMyBillCell"];
    
    self.arrayBigMonth = [[NSMutableArray alloc]init];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataArray = [[NSMutableArray alloc]init];
}

#pragma mark 请求数据
- (void)loadMyBillData
{
    if (![[NetworkManager defaultManager] connectedToNetwork]) {
        
        [self.view makeToast:@"网络连接异常~" duration:1.5 position:@"center"];
        return ;
    }
    [LMSLoadingHUD showInView:self.view];
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:
                             MemberID,@"member_id",
                             nil];
    [[NetworkManager defaultManager]POSTWithURL:MEMBER_REPAYMENT_URL parameters:params success:^(id responseObject) {
        NetResponse *rep = (NetResponse *)responseObject;
        switch (rep.status) {
            case kServerStateSuccess:
            {
                NSMutableArray *billListArray = [NSMutableArray array];
                NSMutableArray *planArray = [NSMutableArray array];
                self.dataArray = (NSMutableArray *)rep.data;
                
                for (int i = 0; i < self.dataArray.count; i++)
                {
                    LMSMyBillModel *listModel = [LMSMyBillModel mj_objectWithKeyValues:self.dataArray[i]];
                    [billListArray addObject:listModel];
                    
                    NSArray *repay_plan_array = listModel.repay_plan;
                    [planArray addObjectsFromArray:repay_plan_array];
                    
                }
                self.arrayBigMonth = [self sortMonthAndDay:planArray];
        
                self.arr = [self repayMonth];
                
                if (self.dataArray.count == 0) {
                    [self noMessageViewAdd:YES];
                }else{
                    [self noMessageViewAdd:NO];
                }
                //zy
                [self.tableView reloadData];
            }
                break;
                
            default:
            {
                [self.view makeToast:rep.message duration:1 position:@"center"];
            }
                break;
        }
        [LMSLoadingHUD hide];
    } failure:^(NSError *error) {
        [LMSLoadingHUD hide];
        [self.view makeToast:@"网络连接失败" duration:1.5 position:@"center"];
    }];
}

-(void)noMessageViewAdd:(BOOL)isAdd
{
    UIView *nomsgView = [[UIView alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - 200)/2 - 50, SCREEN_WIDTH, 300)];
    [self.view addSubview:nomsgView];
    if (isAdd) {
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((nomsgView.frame.size.width - 100)/2, 0, 100, 100)];
        img.image = [UIImage imageNamed:@"id_no_list"];
        img.contentMode = UIViewContentModeScaleAspectFit;
        [nomsgView addSubview:img];
        
        UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(0, img.frame.size.height+5, SCREEN_WIDTH, 30)];
        lbl1.text = @"你现在还没有账单哦";
        lbl1.textColor = [UIColor hexStringToColor:@"#999ea3"];
        lbl1.textAlignment = NSTextAlignmentCenter;
        lbl1.font = HelveticaNeueLightFont(14);
        [nomsgView addSubview:lbl1];
        [nomsgView bringSubviewToFront:self.view];
    }else{
        [nomsgView removeFromSuperview];
    }
}
-(NSMutableArray *)sortMonthAndDay:(NSMutableArray *)planArray
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    for (int i = 0; i< planArray.count; i++)
    {
        LMSRepay_Plan *model = planArray[i];
        NSString *string = [LMSTimeHelper timeFormat:@"yyyyMM" andLongTime:[NSString stringWithFormat:@"%ld",(long)model.repay_time]];
        
        if ([dict[string] count]>0) {
            [dict[string] addObject:model];
        }else{
            [dict setObject:[NSMutableArray arrayWithObject:model] forKey:string];
        }
    }
        
    NSMutableArray *array = [NSMutableArray arrayWithArray:dict.allKeys];
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
     {
         return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
     }];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:array.count];
    for (int i = 0; i < array.count; i++) {
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"repay_time" ascending:YES]];
        NSMutableArray *dicArray = dict[array[i]];
        [dicArray sortUsingDescriptors:sortDescriptors];
        [resultArray addObject:dicArray];
    }
    NSLog(@"%@",resultArray);
    
    return resultArray;
}

#pragma mark UITabelView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMSMyBillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LMSMyBillCell"];
    

    cell.arrayData = self.arr[indexPath.row];
    
    //按钮block
    cell.blockBtn = ^(NSInteger IndexTag,LMSRepay_Plan *planModel)
    {
        if (indexPath.row != 0 || IndexTag != 0) {
            
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
    
    //viewBlock
    cell.viewBlcokTap = ^(NSInteger IndexTag){

        LMSRepay_Plan *planModel = self.arr[indexPath.row][IndexTag];
        
        LMSMyBillDetailVC *detailVC = [LMSMyBillDetailVC new];
        for (int i = 0; i<self.dataArray.count; i++) {
            LMSMyBillModel *listModel = [LMSMyBillModel mj_objectWithKeyValues:self.dataArray[i]];
            if ([listModel.order_id longValue] == [planModel.order_id longValue]) {
                detailVC.model = listModel;
            }
        }
        [self.navigationController pushViewController:detailVC animated:YES];
    };
    
    if (indexPath.row > 0) {
            
            LMSRepay_Plan *planModel = self.arr[indexPath.row][0];
            LMSRepay_Plan *planModel1 = self.arr[indexPath.row-1][0];

            if ([[self string:[LMSTimeHelper timeFormat:@"yyyyMMdd" andLongTime:[NSString stringWithFormat:@"%ld",(long)planModel.repay_time]] andlc:0 len:4] isEqualToString:[self string:[LMSTimeHelper timeFormat:@"yyyyMMdd" andLongTime:[NSString stringWithFormat:@"%ld",(long)planModel1.repay_time]] andlc:0 len:4]]) {
                cell.lblYear.hidden = YES;
            }else{
                cell.lblYear.text = [self string:[LMSTimeHelper timeFormat:@"yyyyMMdd" andLongTime:[NSString stringWithFormat:@"%ld",(long)planModel.repay_time]] andlc:0 len:4];
            }
    }
    return cell;
}

//去还款
- (void)goToRepaymentVCWithPlanModel:(LMSRepay_Plan *)planModel{
    
    NSLog(@"planModel----%@",planModel.repay_id);
    LMSRepaymentVC *repaymentVC = [[LMSRepaymentVC alloc]init];
    repaymentVC.paymentType = LMSPaymentFromSinglePayType;
    repaymentVC.source_id   = planModel.repay_id;
    repaymentVC.fromVC      = LMSRepaymentFromMyBill;
    [self.navigationController pushViewController:repaymentVC animated:YES];
}

- (NSMutableArray *)repayMonth{
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    NSInteger num = self.arrayBigMonth.count;
    
    for (int i = 0; i < num; i++) {
        
        NSInteger num2 = [self.arrayBigMonth[i] count];
      
        NSMutableArray *subArray = [NSMutableArray arrayWithArray:self.arrayBigMonth[i]];
         int k = 0;
        for (int j = 0; j < num2; j++) {
           
            LMSRepay_Plan * planMode = self.arrayBigMonth[i][j];
           
            if ([planMode.status integerValue] == 1) {
                [subArray removeObjectAtIndex:j-k];
                k++;
            }
        }
        
        if ([subArray checkNil] == nil || [subArray count] == 0) {
            continue;
        }
        [array addObject:subArray];
    }
    
    return array;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.arr[indexPath.row];
    return array.count*80+32;
}

#pragma mark 返回按钮
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
- (void)addRightBtn
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"借款记录" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 100, 13);
    [rightBtn setTitleColor:[UIColor hexStringToColor:@"#333333"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = HelveticaNeueLightFont(14);
    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    [rightBtn addTarget:self action:@selector(BtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)BtnAction
{
    if (![[NetworkManager defaultManager] connectedToNetwork]) {
        
        [self.view makeToast:@"网络连接异常~" duration:1.5 position:@"center"];
        return ;
    }
    
    if (!IS_LOGIN) {
        
        [self.view makeToast:@"你还没有登录" duration:1 position:@"center"];
        return;
    }
    
    LMSWebViewController *webVC = [[LMSWebViewController alloc]init];
    
    NSString *encValues = [EncryptUtil encryptWithText:[NSString stringWithFormat:@"member_id=%@",MemberID]];
    NSString *url = [NSString stringWithFormat:@"%@%@?i=%@",LMSDomain,H5_ORDER_LIST,encValues];
    
    webVC.webUrl = [url normalH5Url];
    [self.navigationController pushViewController:webVC animated:YES];
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

- (NSString *)string:(NSString *)str andlc:(NSUInteger)lc len:(NSUInteger)len
{
    return [str substringWithRange:NSMakeRange(lc,len)];
}

- (void)initNavigation{
    
    [self addBackButton];
    [self addRightBtn];
    self.navigationItem.title = @"我的账单";
    [self setNavBarBgColorStyle:NavBarColorStyleMine];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationController.navigationBar.shadowImage = nil;
}

-(void)dealloc
{
    [LMSNotificationCenter removeObserver:self name:LMSRepaySuccessReturnMyBill object:nil]                                                                                                                                                                                                                                                                                                                                                                                                     ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
