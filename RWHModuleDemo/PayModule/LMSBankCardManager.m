//
//  LMSBankCardManager.m
//  LetMeSpend
//
//  Created by wukexiu on 16/8/23.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSBankCardManager.h"

@interface LMSBankCardManager()

@property(nonatomic, strong) NSMutableArray *bankCardArray;

@end

@implementation LMSBankCardManager

+ (LMSBankCardManager *)shareManager{
    static LMSBankCardManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BankCardInfo" ofType:@"plist"];
        NSMutableArray *bankCardArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        shared_manager.bankCardArray=bankCardArray;
    });
    return shared_manager;
}

+ (NSString *)returnBankName:(NSString*) cardNo{
    
    NSMutableArray *bankBin = [self shareManager].bankCardArray;
    
    if(cardNo==nil || cardNo.length<16 || cardNo.length>19){
        return @"";
    }
    
    //6位Bin号
    NSString* cardbin_6 = [cardNo substringWithRange:NSMakeRange(0, 6)];
    for (int i = 0; i < bankBin.count; i++) {
        NSDictionary *dic = bankBin[i];
        if ([cardbin_6 isEqualToString:[dic valueForKey:@"bankBin"]]) {
            return [dic valueForKey:@"bankName"];
        }
    }
    //8位Bin号
    NSString* cardbin_8 = [cardNo substringWithRange:NSMakeRange(0, 8)];
    for (int i = 0; i < bankBin.count; i++) {
        NSDictionary *dic = bankBin[i];
        if ([cardbin_8 isEqualToString:[dic valueForKey:@"bankBin"]]) {
            return [dic valueForKey:@"bankName"];
        }
    }
    
    return @"";
}

+ (BOOL)checkCardNo:(NSString *)cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}


@end
