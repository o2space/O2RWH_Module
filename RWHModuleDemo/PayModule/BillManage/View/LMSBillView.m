//
//  LMSBillView.m
//  LetMeSpend
//
//  Created by lzj on 16/2/24.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSBillView.h"

@implementation LMSBillView


- (IBAction)btnClick:(id)sender {
    if (self.btnBlock) {
        self.btnBlock();
    }
}
@end
