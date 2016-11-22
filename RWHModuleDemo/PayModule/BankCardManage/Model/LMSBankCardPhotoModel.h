//
//  LMSBankCardPhotoModel.h
//  LetMeSpend
//
//  Created by wukexiu on 16/9/12.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMSBankCardPhotoModel : NSObject

@property(nonatomic,copy)NSString *des;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,assign)NSInteger icon;

@property(nonatomic,strong)UIImage *img;
@property(nonatomic,assign)NSInteger state;
@property(nonatomic,copy)NSString *photoKey;

@end
