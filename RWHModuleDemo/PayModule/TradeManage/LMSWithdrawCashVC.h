//
//  LMSWithdrawCashVC.h
//  LetMeSpend
//
//  Created by zy on 16/7/11.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "RWHBaseViewController.h"

@interface LMSWithdrawCashVC : RWHBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *rightTopLabel;

@property (weak, nonatomic) IBOutlet UITextField *withdrawTextFiled;

@property (weak, nonatomic) IBOutlet UILabel *bandLabel;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@property (weak, nonatomic) IBOutlet UIButton *withDrawBtn;

@property (weak, nonatomic) IBOutlet UILabel *lastLabel;

@property (weak, nonatomic) IBOutlet UIView *vwCardStateTips;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_vwCardStateTips;
@property (weak, nonatomic) IBOutlet UIButton * btnCardStateTips;

@end
