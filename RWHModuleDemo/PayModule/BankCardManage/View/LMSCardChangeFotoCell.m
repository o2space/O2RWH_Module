//
//  LMSCardChangeFotoCell.m
//  LetMeSpend
//
//  Created by wukexiu on 16/9/8.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSCardChangeFotoCell.h"

@interface LMSCardChangeFotoCell()

@property(nonatomic,weak)IBOutlet UIImageView *ivPhoto;
@property(nonatomic,weak)IBOutlet UIButton *btnTip;
@property(nonatomic,weak)IBOutlet UIImageView *ivTakeicon;

@end

@implementation LMSCardChangeFotoCell

- (void)setModel:(LMSBankCardPhotoModel *)model{
    _model = model;
    if (model.state == 0 || model.img == nil) {
        _ivPhoto.image = [self getDefaultPhoto:model.icon];
        _ivTakeicon.hidden = NO;
    }else{
        _ivPhoto.image = model.img;
        _ivTakeicon.hidden = YES;
    }
    _btnTip.title = model.des;
    
    [self layoutIfNeeded];
}

- (UIImage *)getDefaultPhoto:(NSInteger) icon{
    UIImage *temp_img = nil;
    switch (icon) {
        case 1:
            temp_img = [UIImage imageNamed:@"bank_card2positive"];
            break;
        case 2:
            temp_img = [UIImage imageNamed:@"bank_card2back"];
            break;
        case 3:
            temp_img = [UIImage imageNamed:@"id_id_and_person"];
            break;
        case 4:
            temp_img = [UIImage imageNamed:@"id_front"];
            break;
        case 5:
            temp_img = [UIImage imageNamed:@"id_back"];
            break;
        case 6:
            temp_img = [UIImage imageNamed:@"bank_card2voucher"];
            break;
        case 7:
            temp_img = [UIImage imageNamed:@"bank_card2person"];
            break;
        default:
            temp_img = [UIImage imageNamed:@"banner_NO"];
            break;
    }
    return temp_img;
}

+ (LMSCardChangeFotoCell *)cellWithTableView:(UITableView *)tableView{
    LMSCardChangeFotoCell *cell = (LMSCardChangeFotoCell *)[tableView dequeueReusableCellWithIdentifier:[LMSCardChangeFotoCell getID]];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMSCardChangeFotoCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.clipsToBounds = YES;
    return cell;
}

+ (LMSCardChangeFotoCell *)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    LMSCardChangeFotoCell *cell = (LMSCardChangeFotoCell *)[tableView dequeueReusableCellWithIdentifier:[LMSCardChangeFotoCell getID] forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMSCardChangeFotoCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.clipsToBounds = YES;
    return cell;
}

+ (NSString *)getID{
    return @"LMSCardChangeFotoCell";
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
