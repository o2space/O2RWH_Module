//
//  LMSBankCardManageController.m
//  LetMeSpend
//
//  Created by wukexiu on 16/9/8.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSBankCardManageController.h"
#import "LMSBankCardChangeController.h"
#import "LMSPayViewModel.h"
#import "LMSPayInfoModel.h"
#import "LMSBankCardInfoModel.h"
#import "LMSCustomActionSheet.h"
#import "LMSAddBandCardVC.h"

@interface LMSBankCardManageController ()

@property(nonatomic,weak) IBOutlet UIScrollView *svMain;
@property(nonatomic,weak) IBOutlet UIView *vwCardMain;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *height_vwCardMain;
@property(nonatomic,weak) IBOutlet UIView *vwCardInfo;
@property(nonatomic,weak) IBOutlet UIView *vwCardAdd;
@property(nonatomic,weak) IBOutlet UIView *vwError;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *height_vwError;
@property(nonatomic,weak) IBOutlet UIView *vwCardState;
@property(nonatomic,weak) IBOutlet UIView *vwCardUseState;

@property(nonatomic,weak) IBOutlet UIImageView *ivCardBg;
@property(nonatomic,weak) IBOutlet UIImageView *ivCardIcon;
@property(nonatomic,weak) IBOutlet UILabel *lblBankName;
@property(nonatomic,weak) IBOutlet UILabel *lblBankStyle;
@property(nonatomic,weak) IBOutlet UILabel *lblBankNo;
@property(nonatomic,weak) IBOutlet UILabel *lblState;
@property(nonatomic,weak) IBOutlet UILabel *lblUseState;
@property(nonatomic,weak) IBOutlet UILabel *lblBankInter;
@property(nonatomic,weak) IBOutlet UILabel *lblChangeErr;

@property(nonatomic,strong) UIButton *navRightBtn;
@property(nonatomic,strong)LMSCustomActionSheet * changeView;
@property (nonatomic,strong) LMSPayInfoModel * payInfoModel;
@property (nonatomic,strong) LMSBankCardInfoModel * bankCardInfoModel;
@end

@implementation LMSBankCardManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _height_vwCardMain.constant = (121.0f/375.0f)*SCREEN_WIDTH;
    [self initNavigation];
    [self setupView];
    [self loadCardPayInfoData];
    [self.view layoutIfNeeded];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBankCardInfoData) name:@"LoadBankCardInfoData" object:nil];
}

//navBar-init
- (void)initNavigation{
    self.navigationItem.title = @"我的银行卡";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor hexStringToColor:@"333333"]}];
    self.navigationController.navigationBar.shadowImage = nil;
    [self setNavBarBgColorStyle:NavBarColorStyleMine];
    [self addNavBarButton];
}

- (void)setupView{
    //CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-15 * (CGFloat)M_PI / 45), 1, 0, 0);
    CGAffineTransform transform = CGAffineTransformMakeRotation(45 * M_PI/180.0);
    self.vwCardUseState.transform = transform;
;
}

- (void)initCardView{
    /*
    UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDo:)];
    longPressed.minimumPressDuration = 1;
    [self.vwCardInfo addGestureRecognizer:longPressed];
     */
}

- (void)addNavBarButton
{
    UIButton * backBtn;
    backBtn                 = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.bounds          = CGRectMake(0, 0, 30, 18);
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addLeftBarItemCustomButton:backBtn];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navRightBtn = rightBtn;
    self.navRightBtn.hidden = YES;
    rightBtn.frame = CGRectMake(0, 0, 60, 44);
    //[rightBtn setImageName:@"ic_dote_more"];
    [rightBtn setTitle:@"换卡" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor hexStringToColor:@"333333"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addRightBarItemCustomButton:rightBtn];
}

- (void)backAction:(UIButton *)b
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnAction:(UIButton *)b{
    
    if (!_changeView)
    {
        _changeView = [[LMSCustomActionSheet alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds andBtnArr:@[@"银行卡正常使用",@"银行卡已丢失、挂失"]];
        
        UIButton * changeCardBtn = (UIButton *)[_changeView viewWithTag:_changeView.thisTag + 0];
        [changeCardBtn setImage:[UIImage imageNamed:@"icon_cardup"] forState:UIControlStateNormal];
        changeCardBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -33, 0, 0);
        changeCardBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        changeCardBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        UIButton * changeCardTBtn = (UIButton *)[_changeView viewWithTag:_changeView.thisTag + 1];
        [changeCardTBtn setImage:[UIImage imageNamed:@"icon_cardlost"] forState:UIControlStateNormal];
        changeCardTBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        changeCardTBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        [changeCardBtn addTarget:self action:@selector(changeCardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [changeCardTBtn addTarget:self action:@selector(changeCardTBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:_changeView];
    [_changeView show];
    
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        //[self deleteCard:1];
    }
}

- (void)deleteCard:(NSInteger)caridID{
    __weak typeof(self) weakSelf = self;
    LMSCommonAlertView * alert = [LMSCommonAlertView alertViewwithTitle:@"" message:@"确定删除该银行卡吗?" cancelBtnTitle:@"取消" okBtnRedTitle:@"删除" buttonTouchedAction:^{
        [LMSLoadingHUD showInView:self.view];
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"bind_id",nil];
        [[LMSPayViewModel sharePayViewModel] getPayDelect:dict CallBack:^(BOOL success, id data) {
            if (success) {
                weakSelf.bankCardInfoModel = nil;
            }
        }];
        [LMSLoadingHUD hide];
    } dismissAction:^{
        [LMSLoadingHUD hide];
    }];
    
    [alert show];
}

- (void)changeCardBtnClick:(UIButton *)sender{
    [_changeView hide];
    LMSBankCardChangeController *vc = [LMSBankCardChangeController createViewController:0];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)changeCardTBtnClick:(UIButton *)sender{
    [_changeView hide];
    LMSBankCardChangeController *vc = [LMSBankCardChangeController createViewController:1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadCardPayInfoData{
    __weak typeof(self) weakSelf = self;
    [LMSLoadingHUD showInView:self.view];
    self.svMain.hidden = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"",nil];
        [[LMSPayViewModel sharePayViewModel] getPayInfo:dict CallBack:^(BOOL success, id data) {
            if (success) {
                [LMSLoadingHUD hide];
                weakSelf.payInfoModel = [LMSPayInfoModel mj_objectWithKeyValues:data];
                [LMSPayInfoModel savePayInfoToFile:weakSelf.payInfoModel];
                [weakSelf loadBankCardInfoData];
            }else{
                [LMSLoadingHUD hide];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
        }];
    });
}

- (void)loadBankCardInfoData{
    __weak typeof(self) weakSelf = self;
    [LMSLoadingHUD showInView:self.view];
    self.svMain.hidden = YES;
    self.navRightBtn.hidden = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary * dict_temp = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"",nil];
        
        [[LMSPayViewModel sharePayViewModel] getBankCardDetail:dict_temp CallBack:^(BOOL success, id data) {
            
            if (success) {
                //NSLog(@"getBankCardDetail:%@",data);
                NSDictionary *dic = [((NSDictionary *)data) valueForKey:@"bind_card"];
                //weakSelf.bankCardInfoModel = nil;
                weakSelf.bankCardInfoModel = [LMSBankCardInfoModel mj_objectWithKeyValues:dic];
                weakSelf.svMain.hidden = NO;
                [LMSLoadingHUD hide];
            }else{
                [LMSLoadingHUD hide];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
        }];
    });
}

- (void)setBankCardInfoModel:(LMSBankCardInfoModel *)bankCardInfoModel{
    //NSLog(@"bankCardInfoModel:%@,%@",bankCardInfoModel,[bankCardInfoModel mj_JSONString]);
    /*
    if (bankCardInfoModel) {
        if ([bankCardInfoModel.card_no isEqualToString:@""]) {
            bankCardInfoModel = nil;
        }
    }
     */
    
    _bankCardInfoModel = bankCardInfoModel;
    if (bankCardInfoModel == nil) {
        _vwCardInfo.hidden = YES;
        _vwCardState.hidden = YES;
        _vwCardAdd.hidden = NO;
        _vwError.hidden = YES;
        _height_vwError.constant = 0;
        self.navRightBtn.hidden = YES;
    }else{
        _vwCardInfo.hidden = NO;
        _vwCardState.hidden = NO;
        _vwCardAdd.hidden = YES;
        
        _lblBankName.text = bankCardInfoModel.bank_name;
        _lblBankStyle.text = bankCardInfoModel.card_type;
        _lblBankNo.text = [bankCardInfoModel.card_no substringWithRange:NSMakeRange(bankCardInfoModel.card_no.length - 4, 4)];
        _lblUseState.text = bankCardInfoModel.card_statusTopStr;
        if (bankCardInfoModel.card_status == 0) {
            _vwCardUseState.hidden = YES;
        }else{
            _vwCardUseState.hidden = NO;
        }
        _lblState.text = bankCardInfoModel.card_statusStr;
        if (bankCardInfoModel.card_status == 0 || bankCardInfoModel.card_status == 1) {
            self.navRightBtn.hidden = NO;
        }else{
            self.navRightBtn.hidden = YES;
        }
        _lblBankInter.text = bankCardInfoModel.pre_account_time;
        
        if ([bankCardInfoModel.charge_card_error_msg isEqualToString:@""]) {
            _vwError.hidden = YES;
            _height_vwError.constant = 0;
        }else{
            
            NSString  *charge_card_error_time= [[NSUserDefaults standardUserDefaults] objectForKey:@"charge_card_error_time"];
            if (charge_card_error_time == nil || [charge_card_error_time isEqualToString:@""] || ![charge_card_error_time isEqualToString:bankCardInfoModel.charge_card_error_time]) {
                _vwError.hidden = NO;
                _height_vwError.constant = 30;
                _lblChangeErr.text = bankCardInfoModel.charge_card_error_msg;
            }else{
                _vwError.hidden = YES;
                _height_vwError.constant = 0;
            }
        }
        
        [_ivCardBg sd_setImageWithURL:[NSURL URLWithString:bankCardInfoModel.bg] placeholderImage:[UIImage imageNamed:@"bk_RWH_bg"]];
        
        [_ivCardIcon sd_setImageWithURL:[NSURL URLWithString:bankCardInfoModel.icon] placeholderImage:[UIImage imageNamed:@"bk_rwh"]];
    }
    [self.view layoutIfNeeded];
}

- (IBAction)addBankCardClick:(id)sender{
    LMSAddBandCardVC * addVC = [[LMSAddBandCardVC alloc]init];
    addVC.addFrom = Credit;
    addVC.timeOut = NSNotFound;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (IBAction)errCloseBtnClick:(id)sender{
    _height_vwError.constant = 0;
    _vwError.hidden = YES;
    if (_bankCardInfoModel != nil && ![_bankCardInfoModel.charge_card_error_time isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setObject:_bankCardInfoModel.charge_card_error_time forKey:@"charge_card_error_time"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.view layoutIfNeeded];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:@"LoadBankCardInfoData"];
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
