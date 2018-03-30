//
//  RecommendTableViewCell.m
//  CityServer
//
//  Created by 陈文清 on 2018/1/1.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "RecommendTableViewCell.h"

@implementation RecommendTableViewCell
{
    __weak IBOutlet UIImageView *headImg;
    __weak IBOutlet UILabel *nickNameLabel;
    __weak IBOutlet UILabel *industryLabel;
    __weak IBOutlet UILabel *signLabel;
    __weak IBOutlet UILabel *followNumLabel;


    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setRecommend:(Recommend *)recommend{
    _recommend = recommend;
    [headImg sd_setImageWithURL:IMAGE(_recommend.avatarPath) placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    nickNameLabel.text = _recommend.userName;
    industryLabel.text = _recommend.industryDesc;
    signLabel.text = _recommend.userSignature;
    followNumLabel.text = [NSString stringWithFormat:@"%@人关注",_recommend.fansCount];
    _attentionButton.selected = (BOOL)recommend.attentionStatus;
}

- (IBAction)addAttention:(UIButton *)sender {
    [self.delegate addAttentionWithIndexPath:_indexPath];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
