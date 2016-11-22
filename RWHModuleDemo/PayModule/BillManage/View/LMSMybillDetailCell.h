//
//  LMSMybillDetailCell.h
//  LetMeSpend
//
//  Created by lzj on 16/2/23.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMSMyBillModel.h"

@interface LMSMybillDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblReal_Money;
@property (weak, nonatomic) IBOutlet UILabel *lblPenalty_Money;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UIView *TopView;

@property (weak, nonatomic) IBOutlet UILabel *lblYear;
@property (weak, nonatomic) IBOutlet UIView *viewForDay;


@property (weak, nonatomic) IBOutlet UILabel *serverMoneyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *severMoneyBottomConstraint;


    //距离顶部距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblTopContraint;

@property (nonatomic,strong) LMSRepay_Plan *repayPlan;
@property (nonatomic,strong) NSString *string;


@property (nonatomic,copy) void(^btnClick)();
@end
