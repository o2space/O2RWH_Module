//
//  LMSRepaymentVC.h
//  LetMeSpend
//
//  Created by liuhongmei on 16/2/20.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWHBaseViewController.h"

//0支付跑腿费  1单期还款  2提前还款
typedef NS_ENUM(int, LMSPaymentFromType){
    LMSPaymentFromRunSpendingType=1,
    LMSPaymentFromSinglePayType,
    LMSPaymentFromAdvancePayType,
};

typedef NS_ENUM(int,LMSRepaymentWhereFrom){
    
    LMSRepaymentFromMyBill = 1,
    LMSRepaymentFromMyDetailBill,
};

@interface LMSRepaymentVC : RWHBaseViewController

@property (nonatomic,strong) NSNumber *source_id;

@property (nonatomic,assign) LMSPaymentFromType paymentType;

@property (nonatomic,assign) LMSRepaymentWhereFrom fromVC;

@end
