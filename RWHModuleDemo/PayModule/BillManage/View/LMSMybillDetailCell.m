//
//  LMSMybillDetailCell.m
//  LetMeSpend
//
//  Created by lzj on 16/2/23.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSMybillDetailCell.h"

@implementation LMSMybillDetailCell

- (void)awakeFromNib {
    
    //设置日期样式
    self.viewForDay.layer.cornerRadius = self.viewForDay.frame.size.height/2;
    self.viewForDay.clipsToBounds = YES;
    self.viewForDay.layer.borderWidth = 1;
    
    self.btnPay.clipsToBounds = YES;
    self.btnPay.layer.cornerRadius = 6;
}

- (void)setRepayPlan:(LMSRepay_Plan *)repayPlan
{
    _repayPlan = repayPlan;
    self.lblReal_Money.text = [NSString stringWithFormat:@"%@",repayPlan.repay_money];
    self.serverMoneyLabel.text = [NSString stringWithFormat:@"服务费%@元",repayPlan.repayment_interest];
        //是否已还款
    if ([repayPlan.status integerValue]== 1) {
        
        self.btnPay.userInteractionEnabled = NO;
        
        [self.btnPay setTitle:@"已还款" forState:UIControlStateNormal];
        [self.btnPay setBackgroundColor:[UIColor hexStringToColor:@"#FFFFFF"]];
        [self.btnPay setTitleColor:[UIColor hexStringToColor:@"#C8C7CC"]];
        self.btnPay.layer.borderWidth = 0;
        
        [self.lblMonth setBackgroundColor:[UIColor hexStringToColor:@"#FFFFFF"]];
        self.lblMonth.textColor = [UIColor hexStringToColor:@"#C8C7CC"];
        self.viewForDay.backgroundColor = [UIColor whiteColor];
        
        self.lblReal_Money.textColor = [UIColor hexStringToColor:@"#C8C7CC"];
        self.serverMoneyLabel.textColor = [UIColor hexStringToColor:@"C8C7CC"];
        
        self.lblDay.textColor = [UIColor hexStringToColor:@"#C8C7CC"];
        self.viewForDay.layer.borderColor = [UIColor hexStringToColor:@"#C8C7CC"].CGColor;
            //是否罚息
        if ([repayPlan.penalty doubleValue] > 0) {
            self.lblPenalty_Money.text = [NSString stringWithFormat:@"违约金%@元",repayPlan.penalty];
            self.lblPenalty_Money.hidden = NO;
            self.lblPenalty_Money.textColor = [UIColor hexStringToColor:@"#C8C7CC"];
        }else{
            self.lblPenalty_Money.hidden = YES;
            self.severMoneyBottomConstraint.constant = -2;
        }
        
    }else{
        
        self.btnPay.userInteractionEnabled = YES;
        
        [self.btnPay setTitle:@"还款" forState:UIControlStateNormal];
        self.lblMonth.textColor = [UIColor hexStringToColor:@"#000000"];
            //是否罚息
        if ([repayPlan.penalty doubleValue] > 0) {
            self.lblPenalty_Money.text = [NSString stringWithFormat:@"违约金%@元",repayPlan.penalty];
            self.lblPenalty_Money.hidden = NO;
            [self.btnPay setBackgroundColor:[UIColor hexStringToColor:@"#FEF0F0"]];
            [self.btnPay setTitleColor:[UIColor hexStringToColor:@"#FF0000"]];
            self.lblPenalty_Money.textColor = [UIColor hexStringToColor:@"#686871"];
            self.lblReal_Money.textColor = [UIColor hexStringToColor:@"#FF0000"];
            self.serverMoneyLabel.textColor = [UIColor hexStringToColor:@"#686871"];
            
            self.lblDay.textColor = [UIColor hexStringToColor:@"#FFFFFF"];
            self.viewForDay.layer.borderColor = [UIColor hexStringToColor:@"#F73E3E"].CGColor;
            self.viewForDay.backgroundColor = [UIColor hexStringToColor:@"#F73E3E"];
            
            self.btnPay.layer.borderColor = [UIColor hexStringToColor:@"#F73E3E"].CGColor;
            self.btnPay.layer.borderWidth = 1;
            
        }else{
            self.lblPenalty_Money.hidden = YES;
            self.lblReal_Money.textColor = [UIColor hexStringToColor:@"#3399FF"];
            self.serverMoneyLabel.textColor = [UIColor hexStringToColor:@"#3399FF"];
            self.severMoneyBottomConstraint.constant = -2;
            
            
            [self.btnPay setBackgroundColor:[UIColor hexStringToColor:@"#EFF7FF"]];
            [self.btnPay setTitleColor:[UIColor hexStringToColor:@"#3399FF"]];
            
            self.lblDay.textColor = [UIColor hexStringToColor:@"#3399FF"];
            self.viewForDay.layer.borderColor = [UIColor hexStringToColor:@"#3399FF"].CGColor;
            self.viewForDay.backgroundColor = [UIColor whiteColor];
            
            self.btnPay.layer.borderColor = [UIColor hexStringToColor:@"#3399FF"].CGColor;
            self.btnPay.layer.borderWidth = 1;
        }
    }
}

- (void)setString:(NSString *)string
{
    _string = string;
    self.lblYear.text = [self subString:string andlc:0 len:4];
    self.lblMonth.text = [NSString stringWithFormat:@"%@月",[self MonthString:[self subString:string andlc:4 len:2]]];
    self.lblDay.text = [self MonthString:[self subString:string andlc:6 len:2]];
}

- (NSString *)subString:(NSString *)str andlc:(NSUInteger)lc len:(NSUInteger)len
{
    return [str substringWithRange:NSMakeRange(lc,len)];
}
- (NSString *)MonthString:(NSString *)str
{
    NSString *s = [str substringWithRange:NSMakeRange(0, 1)];
    if ([s isEqualToString:@"0"]) {
        return [str substringWithRange:NSMakeRange(1, 1)];
    }else{
        return str;
    }
}
- (IBAction)btnClick:(id)sender {
    if (self.btnClick) {
        self.btnClick();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
