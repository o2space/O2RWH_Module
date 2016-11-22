//
//  LMSPayViewModel.h
//  LetMeSpend
//
//  Created by zy on 16/7/11.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMSPayViewModel : NSObject

+ (instancetype)sharePayViewModel;

//获取支付信息
- (void)getPayInfo:(NSDictionary *)dict
          CallBack:(void (^)(BOOL success,id data))block;

- (void)getBankCardDetail:(NSDictionary *)dict
          CallBack:(void (^)(BOOL success,id data))block;

- (void)getChargeCardInfo:(NSDictionary *)dict
          CallBack:(void (^)(BOOL success,id data))block;

- (void)pushChargeCardData:(NSDictionary *)dict
          CallBack:(void (^)(BOOL success,id data))block;

- (void)getPayBind:(NSDictionary *)dict
          CallBack:(void (^)(BOOL success,id data))block;

- (void)getPayBindConfirm:(NSDictionary *)dict
                 CallBack:(void (^)(BOOL success,id data))block;

- (void)getPayRecharge:(NSDictionary *)dict
              CallBack:(void (^)(BOOL success,id data))block;

- (void)getPayRechargeConfirm:(NSDictionary *)dict
              CallBack:(void (^)(BOOL success,id data))block;

- (void)getPayRechargeQuery:(NSDictionary *)dict
                       type:(int)type
                   CallBack:(void (^)(BOOL success,id data))block;

- (void)getPayWithdraw:(NSDictionary *)dict
                     CallBack:(void (^)(BOOL success,id data))block;

- (void)getPayDelect:(NSDictionary *)dict
            CallBack:(void (^)(BOOL success,id data))block;

@end
