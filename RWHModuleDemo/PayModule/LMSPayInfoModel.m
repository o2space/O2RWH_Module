//
//  LMSPayInfoModel.m
//  LetMeSpend
//
//  Created by zy on 16/7/8.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSPayInfoModel.h"
#import "MJExtension.h"

@implementation LMSPayInfoModel

#define payInfoFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"payInfo.data"]

MJCodingImplementation

+ (void)savePayInfoToFile:(LMSPayInfoModel *)payInfo{
    
    [NSKeyedArchiver archiveRootObject:payInfo toFile:payInfoFilePath];
}

+ (LMSPayInfoModel *)getPayInfoFromFile{
    
//    BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:payInfoFilePath];
//    NSAssert(isFileExist, @"payInfoFilePath does not exist");
    
    LMSPayInfoModel * payInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:payInfoFilePath];
    if (!payInfo) {
        payInfo = [[LMSPayInfoModel alloc]init];
    }
    return payInfo;
}

+ (void)removePayInfoModel{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    NSError * error;
    [manager removeItemAtPath:payInfoFilePath error:&error];
}

@end

@implementation LMSPayRechargeSmsCodeResponseModel

@end

@implementation LMSPayRechargeConfirmResponseModel

//+(NSDictionary *)replacedKeyFromPropertyName
//{
//    return @{ @"status" : @"code" };
//}
@end

@implementation LMSPayRechargeQueryResponseModel

@end

@implementation LMSPayAddCardSmsCodeResponseModel

@end

@implementation LMSPayAddCardConfirmResponseModel

@end

