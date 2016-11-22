//
//  LMSBillView.h
//  LetMeSpend
//
//  Created by lzj on 16/2/24.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMSBillView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblRepay_Days;
@property (weak, nonatomic) IBOutlet UILabel *lblRepay_Money;
@property (weak, nonatomic) IBOutlet UILabel *lblPenalty_Money;
@property (weak, nonatomic) IBOutlet UIButton *btnRepay;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UIView *viewBgForDays;


@property (weak, nonatomic) IBOutlet UILabel *serverMoneyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *severMoneyBottomConstraint;



- (IBAction)btnClick:(id)sender;

@property (nonatomic,copy)void(^btnBlock)();

@end
