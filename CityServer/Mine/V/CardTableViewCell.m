//
//  CardTableViewCell.m
//  CityServer
//
//  Created by jwdlh on 2018/2/2.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "CardTableViewCell.h"

@implementation CardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)editCard:(UIButton *)sender {
    [self.delegate editCardWithIndexPath:_indexPath];
}

- (IBAction)sendCard:(UIButton *)sender {
    [self.delegate shareCardWithIndexPath:_indexPath];
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 10;

    [super setFrame:frame];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
