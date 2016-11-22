//
//  LMSBankCardChangeController.m
//  LetMeSpend
//
//  Created by wukexiu on 16/9/8.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSBankCardChangeController.h"
#import "LMSCardChangeFotoCell.h"
#import "LMSCardChangeNextCell.h"
#import "FSAlertView.h"
#import "LMSTakePhotoController.h"
#import "LMSPayViewModel.h"
#import "LMSBankCardPhotoModel.h"
#import "UploadFileHandler.h"
#import "LMSAddBandCardVC.h"

@interface LMSBankCardChangeController ()<UITableViewDelegate,UITableViewDataSource,LMSTakePhotoControllerDelegate>
{
    NSInteger selectedIdx;
}
@property(nonatomic,weak)IBOutlet UITableView *tableView;

@property(nonatomic,assign)NSInteger changeState;
@property(nonatomic,strong)NSMutableArray *photoList;

@end

@implementation LMSBankCardChangeController

+ (LMSBankCardChangeController *)createViewController:(NSInteger)changeState{
    LMSBankCardChangeController *tempVC = [[LMSBankCardChangeController alloc] initWithNibName:@"LMSBankCardChangeController" bundle:nil];
    tempVC.changeState = changeState;
    return tempVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigation];
    [self initTableView];
    [self loadChargeCardInfo];
}

//navBar-init
- (void)initNavigation{
    self.navigationItem.title = @"更换银行卡";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationController.navigationBar.shadowImage = nil;
    [self setNavBarBgColorStyle:NavBarColorStyleMine];
    [self addBackButton];
}
- (void)addBackButton
{
    UIButton * backBtn;
    backBtn                 = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.bounds          = CGRectMake(0, 0, 30, 18);
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addLeftBarItemCustomButton:backBtn];
    
}

- (void)initTableView{
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LMSCardChangeFotoCell class]) bundle:nil] forCellReuseIdentifier:[LMSCardChangeFotoCell getID]];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LMSCardChangeNextCell class]) bundle:nil] forCellReuseIdentifier:[LMSCardChangeNextCell getID]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)backAction:(UIButton *)b
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadChargeCardInfo{
    __weak typeof(self) weakSelf = self;
    self.photoList = [NSMutableArray array];
    [LMSLoadingHUD showInView:self.view];
    self.tableView.hidden = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",_changeState],@"charge_type",nil];
        [[LMSPayViewModel sharePayViewModel] getChargeCardInfo:dict CallBack:^(BOOL success, id data) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *arr = data;
                    for (int i = 0; i < arr.count; i++) {
                        LMSBankCardPhotoModel *model = [LMSBankCardPhotoModel mj_objectWithKeyValues:arr[i]];
                        model.state = 0;
                        model.img = nil;
                        [weakSelf.photoList addObject:model];
                    }
                    weakSelf.tableView.hidden = NO;
                    [weakSelf.tableView reloadData];
                });
            }
            [LMSLoadingHUD hide];
        }];
    });
}

- (void)pushChargeCardData{
    NSString *photo_key_str = @"";
    for (int i = 0; i < self.photoList.count; i++) {
        LMSBankCardPhotoModel *photoModel = self.photoList[i];
        if ([photoModel.photoKey isEqualToString:@""] || photoModel.state == 0) {
            [self.view makeToast:[NSString stringWithFormat:@"请拍摄%@",photoModel.des] duration:1.0 position:@"center"];
            return;
        }
        if (i == 0) {
            photo_key_str = [NSString stringWithFormat:@"%@",photoModel.photoKey];
        }else{
            photo_key_str = [NSString stringWithFormat:@"%@,%@",photo_key_str,photoModel.photoKey];
        }
    }
    __weak typeof(self) weakSelf = self;
    [LMSLoadingHUD showInView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:photo_key_str,@"photo_key_str",[NSString stringWithFormat:@"%ld",_changeState],@"charge_type",nil];
        [[LMSPayViewModel sharePayViewModel] pushChargeCardData:dict CallBack:^(BOOL success, id data) {
            if (success) {
                [LMSLoadingHUD hide];
                
                LMSAddBandCardVC * addVC = [[LMSAddBandCardVC alloc]init];
                addVC.addFrom = ReplaceCard;
                addVC.timeOut = NSNotFound;
                [weakSelf.navigationController pushViewController:addVC animated:YES];
            }else{
               [LMSLoadingHUD hide];
            }
        }];
    });
}

#pragma mark - 拍照
- (void)takePhotos {
    LMSTakePhotoController *take = [[LMSTakePhotoController alloc] init];
    take.delegate = self;
    LMSBankCardPhotoModel *photoModel = self.photoList[selectedIdx];
    NSInteger takeType = photoModel.type;
    switch (takeType) {
        case 1:
            take.position = TakePhotoPositionBack;
            break;
        case 0:
            take.position = TakePhotoPositionFront;
            break;
        default:
            break;
    }
    
    /*
    if (take.isAuthorizedCamera == NO || take.isCameraAvailable == NO) {
        
        FSAlertView * alert = [[FSAlertView alloc] initWithTitle:@"温馨提示" message:@"你已阻止任我花访问你的相机，请前往设置-隐私-相机中打开" cancelButtonTitle:@"取消" sureButtonTitle:@"前去设置" cancelBlock:^{
            
        } sureBlock:^{
            if ([[UIApplication sharedApplication] canOpenURL:LMSLOCATION_SERVICES_URL]) {
                [[UIApplication sharedApplication] openURL:LMSLOCATION_SERVICES_URL];
            }
        }];
        [alert show];
        return;
    }
    */
     
    UINavigationController *t_take = [[UINavigationController alloc] initWithRootViewController:take];
    [self presentViewController:t_take animated:YES completion:NULL];
}
-(void)didFinishPickingImage:(UIImage *)previewImage originalImage:(UIImage *)originalImage
{
    LMSBankCardPhotoModel *photoModel = self.photoList[selectedIdx];
    photoModel.img = previewImage;
    [self uploadFileWithImage:originalImage];
}
#pragma mark uploadFile
- (void)uploadFileWithImage:(UIImage *) image
{
    if (!image) return;
    __weak typeof(self) weakSelf = self;
    [LMSLoadingHUD showInView:self.view];
    [[UploadFileHandler sharedHandler] uploadObjectData:UIImageJPEGRepresentation(image, 0) AsyncWithBlock:^(BOOL isSuccess, NSString *objectKey) {
        [LMSLoadingHUD hide];
        if (isSuccess) {
            LMSBankCardPhotoModel *photoModel = self.photoList[selectedIdx];
            photoModel.state = 1;
            photoModel.photoKey = objectKey;
            [weakSelf.tableView reloadData];
        }else{
            ShowMsgTip(@"上传图片失败");
        }
        [LMSLoadingHUD hide];
    }];
}


#pragma mark - tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.photoList==nil?0:self.photoList.count;
    }else if (section == 1){
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return (257.0f/375.0f)*SCREEN_WIDTH;
    }else if (indexPath.section == 1){
        return 95.0;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        LMSCardChangeFotoCell *cell = [LMSCardChangeFotoCell cellWithTableView:tableView forIndexPath:indexPath];
        cell.model = self.photoList[indexPath.row];
        return cell;
    }else if (indexPath.section == 1){
        LMSCardChangeNextCell *cell = [LMSCardChangeNextCell cellWithTableView:tableView forIndexPath:indexPath];
        cell.NextBlock = ^(){
            [weakSelf pushChargeCardData];
        };
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        selectedIdx = indexPath.row;
        [self takePhotos];
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
