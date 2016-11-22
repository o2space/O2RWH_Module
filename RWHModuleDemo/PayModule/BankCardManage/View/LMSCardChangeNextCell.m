//
//  LMSCardChangeNextCell.m
//  LetMeSpend
//
//  Created by wukexiu on 16/9/10.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSCardChangeNextCell.h"
#import "FSAlertView.h"

@implementation LMSCardChangeNextCell

+ (LMSCardChangeNextCell *)cellWithTableView:(UITableView *)tableView{
    LMSCardChangeNextCell *cell = (LMSCardChangeNextCell *)[tableView dequeueReusableCellWithIdentifier:[LMSCardChangeNextCell getID]];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMSCardChangeNextCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.clipsToBounds = YES;
    return cell;
}

+ (LMSCardChangeNextCell *)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    LMSCardChangeNextCell *cell = (LMSCardChangeNextCell *)[tableView dequeueReusableCellWithIdentifier:[LMSCardChangeNextCell getID] forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMSCardChangeNextCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.clipsToBounds = YES;
    return cell;
}

+ (NSString *)getID{
    return @"LMSCardChangeNextCell";
}

- (IBAction)nextBtnOnClick:(id)sender{
    if (_NextBlock) {
        _NextBlock();
    }
}

- (IBAction)CallTelBtnOnClick:(id)sender{
    FSAlertView *fs = [[FSAlertView alloc] initWithMessage:TEL_NUMBER cancelButtonTitle:@"取消" sureButtonTitle:@"拨打" cancelBlock:^{
        
    } sureBlock:^{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CALL_TEL_NUMBER]];
    }];
    [fs show];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
