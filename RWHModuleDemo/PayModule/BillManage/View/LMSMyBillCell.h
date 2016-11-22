//
//  LMSMyBillCell.h
//  LetMeSpend
//
//  Created by lzj on 16/2/24.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMSMyBillModel.h"

@interface LMSMyBillCell : UITableViewCell

@property (nonatomic,strong) NSArray *arrayData;

@property (weak, nonatomic) IBOutlet UIView *viewDays;

@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalMoney;

@property (nonatomic,copy) void(^blockBtn)(NSInteger IndexTag,LMSRepay_Plan *planModel);

@property (weak, nonatomic) IBOutlet UILabel *lblYear;
@property (nonatomic,copy) void(^viewBlcokTap)(NSInteger IndexTag);

//zy
@property (nonatomic,strong) LMSRepay_Plan *repayPlan;


@end
