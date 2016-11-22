//
//  LMSCustomActionSheet.h
//  LetMeSpend
//
//  Created by wukexiu on 16/9/10.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+RWHAdd.h"

@interface LMSCustomActionSheet : UIView


/**
 *  弹出的view
 */
@property(nonatomic,strong)UIView * popView;

/**
 *  thisTag 50000
 */
@property(nonatomic,assign)NSInteger  thisTag;

- (instancetype)initWithFrame:(CGRect)frame andBtnArr:(NSArray *)btnArr;

- (void)show;

- (void)hide;



@end
