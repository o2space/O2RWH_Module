//
//  LMSAddBandCardVC.h
//  LetMeSpend
//
//  Created by zy on 16/7/8.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "RWHBaseViewController.h"

typedef NS_ENUM(int, AddBandFrom) {
  
    Credit = 1,
    Recharge,
    Withdraw,
    Repayment,
    Authentication,
    BuyProduct,
    ReplaceCard,
};

@interface LMSAddBandCardVC : RWHBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *bandNumTextFiled;

@property (weak, nonatomic) IBOutlet UITextField *telephoneTextFiled;

@property (weak, nonatomic) IBOutlet UITextField *codeTextFiled;

@property (weak, nonatomic) IBOutlet UIButton *chooseBandButton;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UILabel *reachTimeLabel;

@property (nonatomic,assign) AddBandFrom addFrom;

@property (nonatomic,assign) NSInteger timeOut;

@property (nonatomic,assign) float addBandAmount;//代付金额

@property (nonatomic,assign) BOOL isLastOne;

@end
