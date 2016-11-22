//
//  LMSBankCardInfoModel.m
//  LetMeSpend
//
//  Created by wukexiu on 16/9/12.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSBankCardInfoModel.h"

@implementation LMSBankCardInfoModel

-(NSString *)charge_card_statusStr
{
    NSString *str = @"";
    switch (_charge_card_status) {
        case 0:
            str = @"没有换卡";
            break;
        case 1:
            str = @"换卡成功";
            break;
        case 2:
            str = @"换卡失败";
            break;
    }
    
    return str;
}

- (NSString *)card_statusStr{
    NSString *str = @"";
    switch (_card_status) {
        case 0:
            str = @"正常使用";
            break;
        case 1:
            str = @"银行维护中";
            break;
        case 2:
            str = @"换卡中";
            break;
    }
    return str;
}

- (NSString *)card_statusTopStr{
    NSString *str = @"";
    switch (_card_status) {
        case 0:
            str = @"正常使用";
            break;
        case 1:
            str = @"维护中";
            break;
        case 2:
            str = @"换卡中";
            break;
    }
    return str;
}

@end
