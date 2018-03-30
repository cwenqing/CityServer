//
//  SDTimeLineCell.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 459274049
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDTimeLineCell.h"
#import <CoreLocation/CoreLocation.h>
#import "UIView+SDAutoLayout.h"
#import "SDWeiXinPhotoContainerView.h"


const CGFloat contentLabelFontSize = 15;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定



@implementation SDTimeLineCell

{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_contentLabel;
    SDWeiXinPhotoContainerView *_picContainerView;
    UILabel *_locationLabel;
    UILabel *_timeLabel;
    
    UIImageView *_commontImg;
    UILabel *_commontCountLabel;
    
    UIImageView *_likeImg;
    UILabel *_likeCountLabel;
    
    UIButton *_likeButton;
    
    UIImageView *_separatorView;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup
{
    
    
    _iconView = [UIImageView new];
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:15];
    _nameLable.textColor = RGBA(44, 45, 45, 1);
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = RGBA(44, 45, 45, 1);
  
    _picContainerView = [SDWeiXinPhotoContainerView new];

    _locationLabel = [UILabel new];
    _locationLabel.font = [UIFont systemFontOfSize:12];
    _locationLabel.textColor = RGBA(45, 45, 45, 1);
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = RGBA(163, 163, 163, 1);
    
    UIImageView *line = [UIImageView new];
    line.backgroundColor = RGBA(245, 245, 245, 1);
    
    _commontImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pinlun"]];
    
    _commontCountLabel = [UILabel new];
    _commontCountLabel.font = [UIFont systemFontOfSize:12];
    _commontCountLabel.textColor = RGBA(174, 174, 174, 1);
    
//    _likeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"grayzan"]];
//
//    _likeCountLabel = [UILabel new];
//    _likeCountLabel.font = [UIFont systemFontOfSize:12];
//    _likeCountLabel.textColor = RGBA(174, 174, 174, 1);
    
    _likeButton = [[UIButton alloc]init];
    [_likeButton setImage:[UIImage imageNamed:@"grayzan"] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateSelected];
    [_likeButton setTitleColor:RGBA(174, 174, 174, 1) forState:UIControlStateNormal];
    [_likeButton setTitleColor:RGBA(174, 174, 174, 1) forState:UIControlStateSelected];
    _likeButton.titleLabel.font = FONT(12);
    [_likeButton addTarget:self action:@selector(addLike:) forControlEvents:UIControlEventTouchUpInside];
    
    _deleteButton = [[UIButton alloc]init];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = FONT(14);
    [_deleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteDynamic:) forControlEvents:UIControlEventTouchUpInside];
    _deleteButton.hidden = YES;
    
    _separatorView = [UIImageView new];
    _separatorView.backgroundColor = BACColor;
    
    
    
    
    NSArray *views = @[_iconView, _nameLable, _contentLabel, _picContainerView, _locationLabel, _timeLabel, line,_commontImg,_commontCountLabel,_likeButton, _deleteButton,_separatorView];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 14;
    CGFloat testMargin = 12;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(40)
    .heightIs(40);
    _iconView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .centerYEqualToView(_iconView)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_iconView, testMargin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    
    _locationLabel.sd_layout
    .leftSpaceToView(contentView, 22)
    .topSpaceToView(_picContainerView, testMargin)
    .heightIs(15)
    .widthIs(300);
    
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_locationLabel, testMargin)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    line.sd_layout
    .leftSpaceToView(contentView, 0)
    .topSpaceToView(_timeLabel, testMargin)
    .rightSpaceToView(contentView, 0)
    .heightIs(1);
    
    _commontImg.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(line, testMargin)
    .heightIs(15)
    .widthIs(15);
    
    _commontCountLabel.sd_layout
    .leftSpaceToView(_commontImg, 5)
    .centerYEqualToView(_commontImg)
    .heightIs(15);
    [_commontCountLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _likeButton.sd_layout
    .leftSpaceToView(_commontCountLabel, 20)
    .topSpaceToView(line, testMargin)
    .heightIs(15)
    .widthIs(50);
    
    _likeButton.imageView.sd_layout
    .leftSpaceToView(_likeButton, 0)
    .topSpaceToView(_likeButton, 0)
    .heightIs(15)
    .widthIs(15);
    
    _likeButton.titleLabel.sd_layout
    .leftSpaceToView(_likeButton.imageView, 5)
    .topSpaceToView(_likeButton, 0)
    .heightIs(15)
    .widthIs(30);
    
    _deleteButton.sd_layout
    .leftSpaceToView(_likeButton, 0)
    .centerYEqualToView(_likeButton)
    .heightIs(20)
    .widthIs(30);
    
    _separatorView.sd_layout
    .leftSpaceToView(contentView, 0)
    .topSpaceToView(_commontImg, testMargin)
    .rightSpaceToView(contentView, 0)
    .heightIs(5);
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setModel:(Dynamic *)model
{
    _model = model;

    
    [_iconView sd_setImageWithURL:IMAGE(_model.avatarPath) placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    _nameLable.text = model.userName;
    _contentLabel.text = model.dynamicContent;
    _picContainerView.picPathStringsArray = model.dynamicPicPath;
    
    if ([_model.latitude floatValue] == 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%@",[ProjectConfig updateTimeForRow:_model.createTime]];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
        
        // 第一段：图片
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"dingwei"];
        attachment.bounds = CGRectMake(0, -3, 10, 15);
        NSAttributedString *substring1 = [NSAttributedString attributedStringWithAttachment:attachment];
        // 第二段：placeholder
        NSAttributedString *substring2 = [[NSAttributedString alloc] initWithString:@"  未知"];
        
        [string appendAttributedString:substring1];
        [string appendAttributedString:substring2];
        
        _locationLabel.attributedText = string;
        
    }else{
        CLLocation *orig;
        if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            orig=[[CLLocation alloc] initWithLatitude:[MEMBER.latitude doubleValue]  longitude:[MEMBER.longitude doubleValue]];
        }else{
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            orig=[[CLLocation alloc] initWithLatitude:app.latitude  longitude:app.longitude];
        }
        CLLocation* dist=[[CLLocation alloc] initWithLatitude:[_model.latitude doubleValue] longitude:[_model.longitude doubleValue] ];
        
        CLLocationDistance kilometers=[orig distanceFromLocation:dist]/1000;
        NSLog(@"距离:%f",kilometers);
        _timeLabel.text = [NSString stringWithFormat:@"%.2fkm · %@",kilometers,[ProjectConfig updateTimeForRow:_model.createTime]];
        
        CLGeocoder * grader =[[CLGeocoder alloc]init];
        CLLocation * location=[[CLLocation alloc]initWithLatitude:[_model.latitude doubleValue] longitude:[_model.longitude doubleValue]];
        [grader reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *clp= placemarks.firstObject;
            NSString *place =[NSString stringWithFormat:@"  %@",clp.locality];
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
            
            // 第一段：图片
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = [UIImage imageNamed:@"dingwei"];
            attachment.bounds = CGRectMake(0, -3, 10, 15);
            NSAttributedString *substring1 = [NSAttributedString attributedStringWithAttachment:attachment];
            // 第二段：placeholder
            NSAttributedString *substring2 = [[NSAttributedString alloc] initWithString:place];
            
            [string appendAttributedString:substring1];
            [string appendAttributedString:substring2];
            
            _locationLabel.attributedText = string;
        }];
    }
    
    
    
    _commontCountLabel.text = [NSString stringWithFormat:@"%ld",model.commentCount];
//    _likeCountLabel.text = [NSString stringWithFormat:@"%ld",model.likeCount];
    switch (model.supportStatus) {
        case 1:
            _likeButton.selected = YES;
            break;
        case 2:
            _likeButton.selected = NO;
            break;
        default:
            _likeButton.selected = NO;
            break;
    }
    
    [_likeButton setTitle:[NSString stringWithFormat:@"%ld",_model.likeCount] forState:UIControlStateNormal];
    [_likeButton setTitle:[NSString stringWithFormat:@"%ld",_model.likeCount] forState:UIControlStateSelected];
    
    CGFloat picContainerTopMargin = 0;
    if (model.dynamicPicPath.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_contentLabel, picContainerTopMargin);
 
    [self setupAutoHeightWithBottomView:_separatorView bottomMargin:0];
    
    

}

- (void)addLike:(UIButton *)sender{
    [self.delegate supportOrNotWithIndexPath:_indexPath];

}

- (void)deleteDynamic:(UIButton *)sender{
    [self.delegate deleteDynamicWithIndexPath:_indexPath];
    
}


@end

