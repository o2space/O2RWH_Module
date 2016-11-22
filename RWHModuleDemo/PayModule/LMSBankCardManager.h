//
//  LMSBankCardManager.h
//  LetMeSpend
//
//  Created by wukexiu on 16/8/23.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMSBankCardManager : NSObject

+ (NSString *)returnBankName:(NSString *) cardNo;
+ (BOOL)checkCardNo:(NSString *) cardNo;

@end
