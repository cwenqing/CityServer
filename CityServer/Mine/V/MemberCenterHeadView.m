//
//  MemberCenterHeadView.m
//  CityServer
//
//  Created by jwdlh on 2017/12/21.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import "MemberCenterHeadView.h"

@implementation MemberCenterHeadView
{
    __weak IBOutlet UIImageView *headImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *followCountLabel;
    __weak IBOutlet UILabel *fansCountLabel;
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    headImageView.layer.cornerRadius = 34;
    headImageView.layer.masksToBounds = YES;
}

-(void)setMemberInfo:(MemberCenterInfo *)memberInfo{
    _memberInfo = memberInfo;
    [headImageView sd_setImageWithURL:IMAGE(_memberInfo.avatarPath) placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    nameLabel.text = _memberInfo.userName;
    followCountLabel.text = _memberInfo.followersCount;
    fansCountLabel.text = _memberInfo.fansCount;

}

- (IBAction)checkMenberInfo:(UIButton *)sender {
    [self.delegate checkMemberInfo];
}

- (IBAction)checkFollowOrFans:(UIButton *)sender {
    [self.delegate checkFollowOrFans:(int)sender.tag-100];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code_avatarPath	__NSCFString *	@"http://img1.imgtn.bdimg.com/it/u=1361625286,2548277448&fm=214&gp=0.jpg"	0x0000600000059290
}
*/

@end
