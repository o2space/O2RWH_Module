//
//  LMSCardChangeNextCell.h
//  LetMeSpend
//
//  Created by wukexiu on 16/9/10.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMSCardChangeNextCell : UITableViewCell

@property(nonatomic,copy)void (^NextBlock)();

+ (LMSCardChangeNextCell *)cellWithTableView:(UITableView *)tableView;
+ (LMSCardChangeNextCell *)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;
+ (NSString *)getID;
@end
