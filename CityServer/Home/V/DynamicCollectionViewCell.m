//
//  CollectionViewCell.m
//  CityServer
//
//  Created by jwdlh on 2017/12/25.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import "DynamicCollectionViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
@implementation DynamicCollectionViewCell
{
    __weak IBOutlet UIImageView *dynamicImg;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIImageView *headImg;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *nameLabel;
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = 10;
    headImg.layer.masksToBounds = YES;
}

-(void)setDynamic:(Dynamic *)dynamic{
    _dynamic = dynamic;
    if (_dynamic.dynamicPicPath.count == 0) {
        dynamicImg.image = [UIImage imageNamed:@"noimage"];
    }else{
        DynamicPicPath *pic = _dynamic.dynamicPicPath.firstObject;
        if ([pic.fileType hasPrefix:@"image"]) {
            [dynamicImg sd_setImageWithURL:IMAGE(pic.filePath) placeholderImage:[UIImage imageNamed:@"noimage"]];
        }else{
            dynamicImg.image = [UIImage imageNamed:@"video"];
        }
    }
    
    
    titleLabel.text = _dynamic.dynamicContent;
    [headImg sd_setImageWithURL:IMAGE(_dynamic.avatarPath) placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    nameLabel.text = _dynamic.userName;

    if ([_dynamic.latitude floatValue] == 0) {
       timeLabel.text = [NSString stringWithFormat:@"%@",[ProjectConfig updateTimeForRow:_dynamic.createTime]];
    }else{
        CLLocation *orig;
        if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            orig=[[CLLocation alloc] initWithLatitude:[MEMBER.latitude doubleValue]  longitude:[MEMBER.longitude doubleValue]];
        }else{
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            orig=[[CLLocation alloc] initWithLatitude:app.latitude  longitude:app.longitude];
        }
        CLLocation* dist=[[CLLocation alloc] initWithLatitude:[_dynamic.latitude doubleValue] longitude:[_dynamic.longitude doubleValue] ];
        
        CLLocationDistance kilometers=[orig distanceFromLocation:dist]/1000;
        NSLog(@"距离:%f",kilometers);
        timeLabel.text = [NSString stringWithFormat:@"%.2fkm · %@",kilometers,[ProjectConfig updateTimeForRow:_dynamic.createTime]];
    }
    
    switch (_dynamic.supportStatus) {
        case 1:
            _supportButton.selected = YES;
            break;
        case 2:
            _supportButton.selected = NO;
            break;
        default:
            _supportButton.selected = NO;
            break;
    }
    
    [_supportButton setTitle:[NSString stringWithFormat:@"%ld",_dynamic.likeCount] forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"%ld",_dynamic.commentCount] forState:UIControlStateNormal];
}

- (IBAction)praiseButtonClicked:(UIButton *)sender {
    [self.delegate supportOrNotWithIndexPath:_indexPath];
}

- (IBAction)commentButtonClicked:(UIButton *)sender {
}





@end
