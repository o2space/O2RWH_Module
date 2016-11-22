//
//  LMSMyBillCell.m
//  LetMeSpend
//
//  Created by lzj on 16/2/24.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSMyBillCell.h"
#import "LMSBillView.h"

#define viewDaysWidth ScreenWidth - 104

@implementation LMSMyBillCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
//    [self performSelector:@selector(a) withObject:nil afterDelay:0.5];
}

- (void)setArrayData:(NSArray *)arrayData
{
    _arrayData = [NSArray arrayWithArray:arrayData];
        //去除重用
    for (UIView *view in self.viewDays.subviews) {
        [view removeFromSuperview];
    }
    float PayTotalmoney = 0;
    for (int i = 0; i<arrayData.count; i++) {
        
        LMSRepay_Plan *planModel = arrayData[i];

        LMSBillView *v = [[[NSBundle mainBundle] loadNibNamed:@"LMSBillView" owner:nil options:nil]
                          firstObject];
        v.frame = CGRectMake(0, 0+i*80, viewDaysWidth, 80);
        
            //按钮tag值
        v.btnRepay.tag = 10+i;
            //按钮点击block
        v.btnBlock = ^(){
            if (self.blockBtn) {
                LMSRepay_Plan *planModel = arrayData[v.btnRepay.tag-10];
                self.blockBtn(v.btnRepay.tag-10,planModel);
            }
        };
            //还款view加tag值
        v.tag = 100+i;
            //还款view点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewForDaysTap:)];
        [v addGestureRecognizer:tap];

            //还款日
        v.lblRepay_Days.text = [self MonthString:[self subString:[LMSTimeHelper timeFormat:@"yyyyMMdd" andLongTime:[NSString stringWithFormat:@"%ld",(long)planModel.repay_time]] andlc:6 len:2]];
        
            //月份赋值
        if ([[self subString:[LMSTimeHelper timeFormat:@"yyyyMMdd" andLongTime:[NSString stringWithFormat:@"%ld",(long)planModel.repay_time]] andlc:0 len:6] isEqualToString:[self getLocalTime]]) {
            self.lblMonth.text = @"本月";
        }else{
            self.lblMonth.text = [NSString stringWithFormat:@"%@月",[self MonthString:[self subString:[LMSTimeHelper timeFormat:@"yyyyMMdd" andLongTime:[NSString stringWithFormat:@"%ld",(long)planModel.repay_time]] andlc:4 len:2]]];
        }
        
            //年份赋值
        self.lblYear.text = [self subString:[LMSTimeHelper timeFormat:@"yyyyMMdd" andLongTime:[NSString stringWithFormat:@"%ld",(long)planModel.repay_time]] andlc:0 len:4];
            //还款金额
        v.lblRepay_Money.text = [NSString stringWithFormat:@"%.2f",[planModel.repay_money doubleValue]];
        v.serverMoneyLabel.text = [NSString stringWithFormat:@"服务费%.2f元",[planModel.repayment_interest doubleValue]];
        
        [self.viewDays addSubview:v];
        
            //应还钱数
        PayTotalmoney = PayTotalmoney + [planModel.repay_money doubleValue] +[planModel.penalty doubleValue];
        self.lblTotalMoney.text = [NSString stringWithFormat:@"应还%.2f",PayTotalmoney];
        //还款金额
//        v.lblRepay_Money.text = [NSString stringWithFormat:@"%.2f",PayTotalmoney];
            //去除最后一条线
        if (i == arrayData.count - 1) {
            v.viewBottom.hidden = YES;
        }else{
            v.viewBottom.hidden = NO;
        }
        
            //设置日期样式
        v.viewBgForDays.layer.cornerRadius = v.viewBgForDays.frame.size.height/2;
        v.viewBgForDays.clipsToBounds = YES;
        v.viewBgForDays.layer.borderWidth = 1;
        
        v.btnRepay.clipsToBounds = YES;
        v.btnRepay.layer.cornerRadius = 6;
        
            //是否已还款
        if ([planModel.status integerValue]== 1) {
            
            
            v.btnRepay.userInteractionEnabled = NO;
            
            [v.btnRepay setTitle:@"已还款" forState:UIControlStateNormal];
            [v.btnRepay setBackgroundColor:[UIColor hexStringToColor:@"#FFFFFF"]];
            [v.btnRepay setTitleColor:[UIColor hexStringToColor:@"#C8C7CC"]];
            v.btnRepay.layer.borderWidth = 0;
            
            [self.lblMonth setBackgroundColor:[UIColor hexStringToColor:@"#FFFFFF"]];
            self.lblMonth.textColor = [UIColor hexStringToColor:@"#000000"];
            v.viewBgForDays.backgroundColor = [UIColor whiteColor];
            
            v.lblRepay_Money.textColor = [UIColor hexStringToColor:@"#C8C7CC"];
            v.serverMoneyLabel.textColor = [UIColor hexStringToColor:@"C8C7CC"];
            
            v.lblRepay_Days.textColor = [UIColor hexStringToColor:@"#C8C7CC"];
            v.viewBgForDays.layer.borderColor = [UIColor hexStringToColor:@"#C8C7CC"].CGColor;
                //是否罚息
            if ([planModel.penalty doubleValue] > 0) {
                v.lblPenalty_Money.text = [NSString stringWithFormat:@"违约金%@元",planModel.penalty];
                v.lblPenalty_Money.hidden = NO;
                v.lblPenalty_Money.textColor = [UIColor hexStringToColor:@"#C8C7CC"];
            }else{
                v.lblPenalty_Money.hidden = YES;
                v.severMoneyBottomConstraint.constant = -2;
            }
            
        }else{
            
            v.btnRepay.userInteractionEnabled = YES;
            
            [v.btnRepay setTitle:@"还款" forState:UIControlStateNormal];
                //是否罚息
            if ([planModel.penalty doubleValue] > 0) {
                v.lblPenalty_Money.text = [NSString stringWithFormat:@"违约金%@元",planModel.penalty];
                v.lblPenalty_Money.hidden = NO;
                [v.btnRepay setBackgroundColor:[UIColor hexStringToColor:@"#FEF0F0"]];
                [v.btnRepay setTitleColor:[UIColor hexStringToColor:@"#FF0000"]];
                v.lblPenalty_Money.textColor = [UIColor hexStringToColor:@"#686871"];
                
                v.lblRepay_Money.textColor = [UIColor hexStringToColor:@"#FF0000"];
                v.serverMoneyLabel.textColor = [UIColor hexStringToColor:@"686871"];
                
                v.lblRepay_Days.textColor = [UIColor hexStringToColor:@"#FFFFFF"];
                v.viewBgForDays.layer.borderColor = [UIColor hexStringToColor:@"#F73E3E"].CGColor;
                v.viewBgForDays.backgroundColor = [UIColor hexStringToColor:@"#F73E3E"];
                
                v.btnRepay.layer.borderColor = [UIColor hexStringToColor:@"#F73E3E"].CGColor;
                v.btnRepay.layer.borderWidth = 1;
                
            }else{
                v.lblPenalty_Money.hidden = YES;
                v.lblRepay_Money.textColor = [UIColor hexStringToColor:@"#3399FF"];
                v.serverMoneyLabel.textColor = [UIColor hexStringToColor:@"#3399FF"];
                v.severMoneyBottomConstraint.constant = -2;
                
                [v.btnRepay setBackgroundColor:[UIColor hexStringToColor:@"#EFF7FF"]];
                [v.btnRepay setTitleColor:[UIColor hexStringToColor:@"#3399FF"]];
                
                v.lblRepay_Days.textColor = [UIColor hexStringToColor:@"#3399FF"];
                v.viewBgForDays.layer.borderColor = [UIColor hexStringToColor:@"#3399FF"].CGColor;
                v.viewBgForDays.backgroundColor = [UIColor whiteColor];
                
                v.btnRepay.layer.borderColor = [UIColor hexStringToColor:@"#3399FF"].CGColor;
                v.btnRepay.layer.borderWidth = 1;
            }
        }
    }
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

#pragma mark 还款view点击
- (void)viewForDaysTap:(UITapGestureRecognizer *)tap
{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)tap;
    if (self.viewBlcokTap) {
        self.viewBlcokTap([singleTap view].tag-100);
    }
}

    //获取本地时间
- (NSString *)getLocalTime
{
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateformatter setDateFormat:@"yyyyMM"];
    NSString * locationString=[dateformatter stringFromDate:senddate];
    
    return locationString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
