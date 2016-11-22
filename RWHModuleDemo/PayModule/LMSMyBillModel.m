//
//  LMSMyBillModel.m
//  LetMeSpend
//
//  Created by lzj on 16/2/23.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSMyBillModel.h"

@implementation LMSMyBillModel
+ (NSDictionary *)objectClassInArray
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            NSStringFromClass([LMSRepay_Plan class]),@"repay_plan",
            nil];
}
@end

@implementation LMSRepay_Plan


@end
