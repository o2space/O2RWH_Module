//
//  LMSRechargeVC.h
//  LetMeSpend
//
//  Created by zy on 16/7/11.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "RWHBaseViewController.h"

/*
 source_type
 (required)
 充值类型 1 单纯充值
         2 还款充值
         3 买花瓣充值
         4 买商品充值
 */
typedef NS_ENUM(NSInteger, LMSRechargeType) {
    
    LMSRechargeTypeRecharge = 1,
    LMSRechargeTypeRepayment,
    LMSRechargeTypeBuyPetals,
    LMSRechargeTypeBuyProduct,
};

typedef NS_ENUM(int,LMSRechargeWhereFrom){
    
    LMSRechargeFromMyBill = 1,
    LMSRechargeFromMyDetailBill,
};

@interface LMSRechargeVC : RWHBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *moneyTextFiled;

@property (weak, nonatomic) IBOutlet UILabel *bandLabel;

@property (weak, nonatomic) IBOutlet UITextField *smsCodeTextFiled;

@property (weak, nonatomic) IBOutlet UIButton *getSmsCodeButton;

@property (weak, nonatomic) IBOutlet UIButton *rechargebtn;

@property (weak, nonatomic) IBOutlet UILabel *lastLabel;


@property (weak, nonatomic) IBOutlet UIView *vwCardStateTips;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_vwCardStateTips;
@property (weak, nonatomic) IBOutlet UIButton * btnCardStateTips;

@property(nonatomic,assign) float amount;//代付金额

/*
 source_id
 (required)
 充值类型关联ID   source_id = 0       单纯充值 + 买花瓣充值
                source_id = 订单ID   还款充值
 
 */
@property (nonatomic,assign) NSInteger source_id;

@property (nonatomic,assign) LMSRechargeType rechargeType;

@property (nonatomic,assign) LMSRechargeWhereFrom fromVC;

@end
