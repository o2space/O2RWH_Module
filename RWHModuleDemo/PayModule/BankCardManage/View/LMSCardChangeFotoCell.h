//
//  LMSCardChangeFotoCell.h
//  LetMeSpend
//
//  Created by wukexiu on 16/9/8.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMSBankCardPhotoModel.h"

@interface LMSCardChangeFotoCell : UITableViewCell

@property(nonatomic,strong)LMSBankCardPhotoModel *model;

+ (LMSCardChangeFotoCell *)cellWithTableView:(UITableView *)tableView;

+ (LMSCardChangeFotoCell *)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

+ (NSString *)getID;

@end
