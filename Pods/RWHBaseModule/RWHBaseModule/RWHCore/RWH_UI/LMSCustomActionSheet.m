//
//  LMSCustomActionSheet.m
//  LetMeSpend
//
//  Created by wukexiu on 16/9/10.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSCustomActionSheet.h"

@implementation LMSCustomActionSheet
{
    CGFloat _height;
}

- (instancetype)initWithFrame:(CGRect)frame andBtnArr:(NSArray *)btnArr;
{
    if (self = [super initWithFrame:frame])
    {
        _thisTag = 50000;
        
        _height = 0;
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        self.userInteractionEnabled = YES;
        
        UIControl * control = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [control addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:control];
        
        [self createPopViewWithArr:btnArr];
    }
    return self;
}

- (void)createPopViewWithArr:(NSArray *)arr
{
    float wGiveHeight = [UIScreen mainScreen].bounds.size.height/667.0;
    _height = (45 * (arr.count + 1)) * wGiveHeight + (10) * wGiveHeight;
    
    _popView = ({
        
        UIView * popView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width,_height)];
        popView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:231/255.0 alpha:1];
        popView;
    });
    [self addSubview:self.popView];
    
    for (int i = 0 ; i < arr.count; i++)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i * (45) * wGiveHeight, self.frame.size.width, (44) * wGiveHeight);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor hexStringToColor:@"383840"] forState:UIControlStateNormal];
        //[btn setBackgroundImage:[UIImage imageNamed:@"filter_slider_trackbg"] forState:UIControlStateHighlighted];
        btn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:16];
        btn.tag = _thisTag + i;
        [_popView addSubview:btn];
    }
    
    //取消按钮
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.frame = CGRectMake(0, _height - (45) * wGiveHeight, self.frame.size.width, (45) * wGiveHeight);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor hexStringToColor:@"B0B0B4"] forState:UIControlStateNormal];
    //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"filter_slider_trackbg"] forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:17];//Medium,Semibold
    [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [_popView addSubview:cancelBtn];
}

- (void)show
{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.popView.frame = CGRectMake(0, self.frame.size.height - _height, self.frame.size.width, _height);
        
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        
        _popView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, _height);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end
