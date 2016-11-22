//
//  LMSCustomAlertView.h
//  LetMeSpend
//
//  Created by 袁斌 on 16/3/2.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMSCustomAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *containerView;//height--145
@property (weak, nonatomic) IBOutlet UIView *buttonBgView;//height--36
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertContentHigh;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allHeight;


- (void)show;
- (void)dismiss;

@end
