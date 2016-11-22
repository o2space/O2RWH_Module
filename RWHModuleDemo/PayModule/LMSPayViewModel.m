//
//  LMSPayViewModel.m
//  LetMeSpend
//
//  Created by zy on 16/7/11.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSPayViewModel.h"

@implementation LMSPayViewModel

+ (instancetype)sharePayViewModel{
    
    static LMSPayViewModel * payModel = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        payModel = [[self alloc]init];
    });
    
    return payModel;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)getPayInfo:(NSDictionary *)dict
          CallBack:(void (^)(BOOL success,id data))block{
   /*
    [[NetworkManager defaultManager] POSTWithURL:PAY_INFO_URL parameters:dict success:^(id responseObject) {
        
        NetResponse *resp = (NetResponse *)responseObject;
        switch (resp.status) {
                
            case kServerStateSuccess:{
                
                block(YES,resp.data);
            }
                break;
            default:{
                ShowMsgTip(resp.message);
                block(NO,nil);
            }
                break;
        }
    } failure:^(NSError *error) {
        
        ShowConnectErrorMsg;
        block(NO,nil);
    }];
    */
}

- (void)getBankCardDetail:(NSDictionary *)dict
          CallBack:(void (^)(BOOL success,id data))block{
    /*
    [[NetworkManager defaultManager] POSTWithURL:PAY_BANKCARDDETAIL_URL parameters:dict success:^(id responseObject) {
        
        NetResponse *resp = (NetResponse *)responseObject;
        switch (resp.status) {
                
            case kServerStateSuccess:{
                
                block(YES,resp.data);
            }
                break;
            default:{
                ShowMsgTip(resp.message);
                block(NO,nil);
            }
                break;
        }
    } failure:^(NSError *error) {
        
        ShowConnectErrorMsg;
        block(NO,nil);
    }];
     */
}

- (void)getChargeCardInfo:(NSDictionary *)dict
                 CallBack:(void (^)(BOOL success,id data))block{
    /*
    [[NetworkManager defaultManager] POSTWithURL:PAY_CHARGECARDINFO_URL parameters:dict success:^(id responseObject) {
        
        NetResponse *resp = (NetResponse *)responseObject;
        switch (resp.status) {
                
            case kServerStateSuccess:{
                
                block(YES,resp.data);
            }
                break;
            default:{
                ShowMsgTip(resp.message);
                block(NO,nil);
            }
                break;
        }
    } failure:^(NSError *error) {
        
        ShowConnectErrorMsg;
        block(NO,nil);
    }];
     */
}

- (void)pushChargeCardData:(NSDictionary *)dict
                 CallBack:(void (^)(BOOL success,id data))block{
    /*
    [[NetworkManager defaultManager] POSTWithURL:PAY_CHARGECARDDATA_URL parameters:dict success:^(id responseObject) {
        
        NetResponse *resp = (NetResponse *)responseObject;
        switch (resp.status) {
                
            case kServerStateSuccess:{
                
                block(YES,resp.data);
            }
                break;
            default:{
                ShowMsgTip(resp.message);
                block(NO,nil);
            }
                break;
        }
    } failure:^(NSError *error) {
        
        ShowConnectErrorMsg;
        block(NO,nil);
    }];
     */
}

- (void)getPayBind:(NSDictionary *)dict
          CallBack:(void (^)(BOOL success,id data))block{
    /*
    [[NetworkManager defaultManager] POSTWithURL:PAY_CHANGECARD_URL parameters:dict success:^(id responseObject) {
        
        NetResponse *resp = (NetResponse *)responseObject;
        switch (resp.status) {
                
            case kServerStateSuccess:{
                
                block(YES,resp.data);
            }
                break;
            default:{
                ShowMsgTip(resp.message);
                block(NO,nil);
            }
                break;
        }
    } failure:^(NSError *error) {
        
        ShowConnectErrorMsg;
        block(NO,nil);
    }];
     */
}

- (void)getPayBindConfirm:(NSDictionary *)dict
                 CallBack:(void (^)(BOOL success,id data))block{
    /*
    [[NetworkManager defaultManager] POSTWithURL:PAY_CHANGECARD_CONFIRM_URL parameters:dict success:^(id responseObject) {
        
        NetResponse *resp = (NetResponse *)responseObject;
        switch (resp.status) {
                
            case kServerStateSuccess:{
                
                block(YES,resp.data);
            }
                break;
            default:{
                ShowMsgTip(resp.message);
                [[NSNotificationCenter defaultCenter] postNotificationName:getSmsCodeAddBank object:nil];
                block(NO,nil);
            }
                break;
        }
    } failure:^(NSError *error) {
        
        ShowConnectErrorMsg;
        block(NO,nil);
    }];
     */
}

- (void)getPayRecharge:(NSDictionary *)dict
              CallBack:(void (^)(BOOL success,id data))block{
    /*
    [[NetworkManager defaultManager] POSTWithURL:PAY_RECHARGE_URL parameters:dict success:^(id responseObject) {
        
        NetResponse *resp = (NetResponse *)responseObject;
        switch (resp.status) {
                
            case kServerStateSuccess:{
                
                block(YES,resp.data);
            }
                break;
            default:{
                ShowMsgTip(resp.message);
                block(NO,nil);
            }
                break;
        }
    } failure:^(NSError *error) {
        
        ShowConnectErrorMsg;
        block(NO,nil);
    }];
     */
}

- (void)getPayRechargeConfirm:(NSDictionary *)dict
                     CallBack:(void (^)(BOOL success,id data))block{
    /*
    [[NetworkManager defaultManager] POSTWithURL:PAY_RECHARGE_CONFIRM_URL parameters:dict success:^(id responseObject) {
        
        NetResponse *resp = (NetResponse *)responseObject;
        switch (resp.status) {
                
            case kServerStateSuccess:{
                
                block(YES,resp.data);
            }
                break;
            default:{
                ShowMsgTip(resp.message);
                [[NSNotificationCenter defaultCenter] postNotificationName:getSmsCode object:nil];
                block(NO,nil);
            }
                break;
        }
    } failure:^(NSError *error) {
        
        ShowConnectErrorMsg;
        [[NSNotificationCenter defaultCenter] postNotificationName:getSmsCode object:nil];
        block(NO,nil);
    }];
     */
}

- (void)getPayRechargeQuery:(NSDictionary *)dict
                       type:(int)type
                     CallBack:(void (^)(BOOL success,id data))block{
    /*
    [[NetworkManager defaultManager] POSTWithURL:PAY_RECHARGE_QUERY_URL parameters:dict success:^(id responseObject) {
        
        NetResponse *resp = (NetResponse *)responseObject;
        switch (resp.status) {
                
            case kServerStateSuccess:{
                
                block(YES,resp.data);
            }
                break;
            default:{
                if (type != 1) {
                    ShowMsgTip(resp.message);
                }
                block(NO,nil);
            }
                break;
        }
    } failure:^(NSError *error) {
        
        if (type != 1) {
            ShowConnectErrorMsg;
        }
        block(NO,nil);
    }];
     */
}

- (void)getPayWithdraw:(NSDictionary *)dict
                     CallBack:(void (^)(BOOL success,id data))block{
    /*
    [[NetworkManager defaultManager] POSTWithURL:PAY_WITHDRAW_URL parameters:dict success:^(id responseObject) {
        
        NetResponse *resp = (NetResponse *)responseObject;
        switch (resp.status) {
                
            case kServerStateSuccess:{
                
                block(YES,resp.data);
            }
                break;
            default:{
                ShowMsgTip(resp.message);
                block(NO,nil);
            }
                break;
        }
    } failure:^(NSError *error) {
        
        ShowConnectErrorMsg;
        block(NO,nil);
    }];
     */
}

- (void)getPayDelect:(NSDictionary *)dict
            CallBack:(void (^)(BOOL success,id data))block{
    /*
    [[NetworkManager defaultManager] POSTWithURL:PAY_DELECT_URL parameters:dict success:^(id responseObject) {
        
        NetResponse *resp = (NetResponse *)responseObject;
        switch (resp.status) {
                
            case kServerStateSuccess:{
                
                block(YES,resp.data);
            }
                break;
            default:{
                ShowMsgTip(resp.message);
                block(NO,nil);
            }
                break;
        }
    } failure:^(NSError *error) {
        
        ShowConnectErrorMsg;
        block(NO,nil);
    }];
     */
}

@end
