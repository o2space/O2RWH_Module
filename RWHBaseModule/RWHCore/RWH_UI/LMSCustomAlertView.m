//
//  LMSCustomAlertView.m
//  LetMeSpend
//
//  Created by 袁斌 on 16/3/2.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSCustomAlertView.h"
#import <objc/runtime.h>
#import "RWHMacros.h"
#import "UIView+borderLine.h"
@implementation LMSCustomAlertView


-(void)layoutSubviews
{
    _lineH.constant = OnePixelWidth;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [_contentView cornerRadius:6 borderColor:[UIColorWithHex(0xD8D7DD) CGColor] borderWidth:0];
    [super layoutSubviews];
}

- (void)show
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGAffineTransform transform = CGAffineTransformMakeScale(0.97, 0.97);
        self.contentView.transform = transform;
        
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGAffineTransform transform = CGAffineTransformMakeScale(1.02, 1.02);
            self.contentView.transform = transform;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.08 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                CGAffineTransform transform = CGAffineTransformMakeScale(0.99, 0.99);
                self.contentView.transform = transform;
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.06 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    self.contentView.transform = CGAffineTransformIdentity;
                    
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    });
}

- (void)dismiss
{
    /*
    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    hideAnimation.duration = 0.4;
    
    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)]];
     
    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    hideAnimation.delegate = self;
    hideAnimation.fillMode = kCAFillModeBoth;
    hideAnimation.removedOnCompletion = NO;
    [self.contentView.layer addAnimation:hideAnimation forKey:nil];
    */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.contentView.transform = transform;
        
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGAffineTransform transform = CGAffineTransformMakeScale(0.8, 0.8);
            self.contentView.transform = transform;
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
    
}


@end
