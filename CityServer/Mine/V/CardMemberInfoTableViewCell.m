//
//  CardMemberInfoTableViewCell.m
//  CityServer
//
//  Created by jwdlh on 2018/2/2.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "CardMemberInfoTableViewCell.h"

@implementation CardMemberInfoTableViewCell
{
    __weak IBOutlet UIImageView *headImg;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *companyLabel;
    __weak IBOutlet UILabel *industryLabel;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    headImg.layer.cornerRadius = 28;
    headImg.layer.masksToBounds = YES;
}

-(void)setCardDetail:(CardDetail *)cardDetail{
    _cardDetail = cardDetail;
    [headImg sd_setImageWithURL:IMAGE(_cardDetail.userAvatarPath) placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    nameLabel.text = _cardDetail.realName;
    companyLabel.text = [NSString stringWithFormat:@"%@|%@",_cardDetail.companyName,_cardDetail.userProfession];
    industryLabel.text = [NSString stringWithFormat:@"%@|%@",_cardDetail.userIndustry,_cardDetail.userAddress];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
