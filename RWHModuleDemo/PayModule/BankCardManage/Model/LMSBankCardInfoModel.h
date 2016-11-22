//
//  LMSBankCardInfoModel.h
//  LetMeSpend
//
//  Created by wukexiu on 16/9/12.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMSBankCardInfoModel : NSObject

@property(nonatomic,copy) NSString *card_type;
@property(nonatomic,copy) NSString *charge_card_error_msg;
@property(nonatomic,copy) NSString *bank_name;
@property(nonatomic,assign) NSInteger charge_card_status;
@property(nonatomic,copy) NSString *charge_card_statusStr;
@property(nonatomic,assign) NSInteger card_status;
@property(nonatomic,assign) NSString *card_statusStr;
@property(nonatomic,assign) NSString *card_statusTopStr;
@property(nonatomic,copy) NSString *card_no;
@property(nonatomic,copy) NSString *pre_account_time;
@property(nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSString *bg;
@property(nonatomic, copy) NSString *charge_card_error_time;

@end
