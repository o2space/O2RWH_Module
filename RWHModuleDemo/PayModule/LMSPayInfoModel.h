//
//  LMSPayInfoModel.h
//  LetMeSpend
//
//  Created by zy on 16/7/8.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 pay/info 获取支付信息
 
 request:
 
 response:
 {
 balance_money: 100.00, 用户余额
 left_withdraw_count : 0, 剩余免费提现次数
 withraw_free_limit : 3, 每月免费限额
 recharge_min_limit : 1, 最小充值限额
 support:[
 {
 bank_name : '中国银行',
 bank_code : "cba",
 time : '当日到账',
 min: '最小支付限额',
 max: '最大支付限额',
 },
 ....
 ,
 {
 bank_name : '中国银行',
 bank_code : "cba",
 time : '当日到账',
 min: '最小支付限额',
 max: '最大支付限额',
 }
 ]
 cards: [
 {
 card_no:'12132021', 银行卡卡号
 holder: 'xxx', 持卡人姓名
 type:'储蓄卡',
 bank_name:'中国银行', 银行名称
 bind_time:121212312, 绑卡时间戳
 bind_id: 绑卡id
 },
 ....
 {
 card_no:'12132021', 银行卡卡号
 holder: 'xxx', 持卡人姓名
 type:'储蓄卡',
 bank_name:'中国银行', 银行名称
 bind_time:121212312, 绑卡时间戳
 bind_id: 绑卡id
 }
 ]
 
 
 }
 */

@interface LMSPayInfoModel : NSObject

@property (nonatomic,strong) NSNumber * balance_money;
@property (nonatomic,strong) NSNumber * left_withdraw_count;
@property (nonatomic,strong) NSNumber * withdraw_free_limit;
@property (nonatomic,strong) NSNumber * pay_min_limit;
@property (nonatomic,strong) NSNumber * withdraw_min_limit;
@property (nonatomic,strong) NSNumber * pay_fee;
@property (nonatomic,strong) NSDictionary * bind_card_status;//提现界面和充值界面中顶部tip提示
@property (nonatomic,strong) NSArray <NSDictionary *> * support;
@property (nonatomic,strong) NSArray <NSDictionary *> * cards;

@property (nonatomic,copy) NSString *withdraw_notice;//提现说明
@property (nonatomic,copy) NSString *pay_notice;//充值说明

+ (void)savePayInfoToFile:(LMSPayInfoModel *)payInfo;

+ (LMSPayInfoModel *)getPayInfoFromFile;

+ (void)removePayInfoModel;

@end

@interface LMSPayRechargeSmsCodeResponseModel : NSObject

/*
 request_no = "RWH20160716122927I604Y"
 action = "sms"
 */

@property (nonatomic,copy) NSString * request_no;
@property (nonatomic,copy) NSString * action;

@end

@interface LMSPayRechargeConfirmResponseModel : NSObject

/*
 action = "recharge"
 cardno = "6230580000048981240"
 request_no = "RWH20160716123402F614D"
 code = 4
 platform = 1
 bankname = "平安银行"
 bankcode = "SZPA"
 */

@property (nonatomic,copy)   NSString * action;
@property (nonatomic,copy)   NSString * cardno;
@property (nonatomic,copy)   NSString * request_no;
@property (nonatomic,strong) NSNumber * code;
@property (nonatomic,strong) NSNumber * platform;
@property (nonatomic,copy)   NSString * bankname;
@property (nonatomic,copy)   NSString * bankcode;

@end

@interface LMSPayRechargeQueryResponseModel : NSObject

/*
 status = "4"
 */
@property (nonatomic,strong) NSNumber * status;

@end


@interface LMSPayAddCardSmsCodeResponseModel : NSObject

/*
 request_no = "RWH20160716013119F9A3Z"
 */
@property (nonatomic,copy) NSString * request_no;
@property (nonatomic,copy) NSString * bank_code;

@end

@interface LMSPayAddCardConfirmResponseModel : NSObject

/*
 status = 4
 bind_id = "66"
 */
@property (nonatomic,copy)   NSString * bind_id;
@property (nonatomic,strong) NSNumber * status;

@end


