//
//  FansFollowTableViewCell.m
//  CityServer
//
//  Created by 陈文清 on 2018/1/1.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "FansFollowTableViewCell.h"

@implementation FansFollowTableViewCell
{
    __weak IBOutlet UIImageView *headImg;
    __weak IBOutlet UILabel *nameLabel;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    headImg.layer.cornerRadius = 18;
    headImg.layer.masksToBounds = YES;
}

-(void)setFansFollow:(FansFollow *)fansFollow{
    _fansFollow = fansFollow;
    [headImg sd_setImageWithURL:[NSURL URLWithString:fansFollow.avatarPath] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    nameLabel.text = fansFollow.userName;
    _attentionButton.selected = (BOOL)fansFollow.attentionStatus;
}

-(void)setContacts:(Contacts *)contacts{
    _contacts = contacts;
    [headImg sd_setImageWithURL:IMAGE(_contacts.avatarPath) placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    nameLabel.text = _contacts.userName;
}

- (IBAction)attentionOrNotButtonClicked:(UIButton *)sender {
    [self.delegate addAttentionWithIndexPath:_indexPath];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
