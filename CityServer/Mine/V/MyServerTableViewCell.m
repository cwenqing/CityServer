//
//  MyServerTableViewCell.m
//  CityServer
//
//  Created by 陈文清 on 2018/1/16.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "MyServerTableViewCell.h"

@implementation MyServerTableViewCell
{
    __weak IBOutlet UIImageView *serverImg;
    __weak IBOutlet UILabel *serverTitleLabel;
    __weak IBOutlet UILabel *serverTimeLabel;
    __weak IBOutlet UIButton *closeServerButton;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

-(void)setDynamic:(Dynamic *)dynamic{
    _dynamic = dynamic;
    DynamicPicPath *pic = _dynamic.dynamicPicPath.firstObject;
    if ([pic.fileType hasPrefix:@"image"]) {
        [serverImg sd_setImageWithURL:IMAGE(pic.filePath) placeholderImage:[UIImage imageNamed:@"noimage"]];
    }else{
        serverImg.image = [UIImage imageNamed:@"video"];
    }
    
    serverTitleLabel.text = _dynamic.dynamicContent;
    serverTimeLabel.text = [NSString stringWithFormat:@"发布于%@",[ProjectConfig updateTimeForRow:_dynamic.createTime]];
    if (dynamic.supportStatus == 1) {
        closeServerButton.layer.borderWidth = 1;
        closeServerButton.layer.cornerRadius = 3;
        closeServerButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        closeServerButton.layer.masksToBounds = YES;
        closeServerButton.selected = YES;
        closeServerButton.userInteractionEnabled = NO;
    }else{
        closeServerButton.layer.borderWidth = 1;
        closeServerButton.layer.cornerRadius = 3;
        closeServerButton.layer.borderColor = RGBA(56, 107, 248, 1).CGColor;
        closeServerButton.layer.masksToBounds = YES;
        
        closeServerButton.selected = NO;
        closeServerButton.userInteractionEnabled = YES;
    }
}

- (IBAction)closeServerButtonClicked:(UIButton *)sender {
    [self.delegate closeServerAtIndexPath:_indexPath];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
