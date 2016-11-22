//
//  LMSMyBillModel.h
//  LetMeSpend
//
//  Created by lzj on 16/2/23.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
//{
//    "data": [
//             {
//             "order_id": 9999,
//             "loan_money": 200,
//             "periods": 3,
//             "pass_time": 1465432895,
//             "repay_plan": [
//                            {
//                            "order_id": 9999,
//                            "repay_id": 1,
//                            "repay_time": 1455811200,
//                            "repay_money": 260.43,
//                            "real_time": 0,
//                            "penalty": 0,
//                            "status": 0,
//                            "overdue_days": 0
//                            }
//                            ]
//             }
//             ],
//    "code": 1000,
//    "message": 200
//}

@interface LMSRepay_Plan : NSObject
@property (nonatomic,strong) NSNumber * order_id;
@property (nonatomic,strong) NSNumber * repay_id;
@property (nonatomic,assign) NSInteger  repay_time;
@property (nonatomic,strong) NSString * repay_money;
@property (nonatomic,assign) NSInteger  real_time;
@property (nonatomic,strong) NSDecimalNumber * penalty;//
@property (nonatomic,strong) NSNumber * status;
@property (nonatomic,strong) NSNumber * overdue_days;
@property (nonatomic,strong) NSString * repayment_interest;

@end


@interface LMSMyBillModel : NSObject

@property (nonatomic,strong) NSNumber * order_id;
@property (nonatomic,strong) NSString * contract;//查看合同url
@property (nonatomic,strong) NSNumber * loan_money;
@property (nonatomic,strong) NSNumber * periods;
@property (nonatomic,strong) NSNumber * pass_time;
@property (nonatomic,strong) NSArray  * repay_plan;


@end
