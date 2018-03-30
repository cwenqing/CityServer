//
//  CardInfoTableViewCell.m
//  CityServer
//
//  Created by jwdlh on 2018/2/2.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "CardInfoTableViewCell.h"

@implementation CardInfoTableViewCell
{
    __weak IBOutlet UILabel *phoneNumLabel;
    __weak IBOutlet UILabel *companyLabel;
    __weak IBOutlet UILabel *professionLabel;
    __weak IBOutlet UILabel *QQNumLabel;
    __weak IBOutlet UILabel *companyAddressLabel;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCardDetail:(CardDetail *)cardDetail{
    _cardDetail = cardDetail;
    phoneNumLabel.text = _cardDetail.userPhone;
    companyLabel.text = _cardDetail.companyName;
    professionLabel.text = _cardDetail.userProfession;
    QQNumLabel.text = _cardDetail.userQQ;
    companyAddressLabel.text = _cardDetail.userAddress;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
