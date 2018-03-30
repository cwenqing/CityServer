//
//  CommentTableViewCell.m
//  CityServer
//
//  Created by 陈文清 on 2018/1/10.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell
{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_contentLabel;
    UILabel *_timeLabel;
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
    _nameLable.textColor = RGBA(120, 120, 120, 1);
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = RGBA(36, 37, 37, 1);
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = RGBA(163, 163, 163, 1);
    
    UIImageView *line = [UIImageView new];
    line.backgroundColor = RGBA(245, 245, 245, 1);
    
    NSArray *views = @[_iconView, _nameLable, _contentLabel, _timeLabel, line];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 14;
    CGFloat testMargin = 9;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(40)
    .heightIs(40);
    _iconView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, testMargin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, margin)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    line.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_timeLabel, margin)
    .rightSpaceToView(contentView, 0)
    .heightIs(1);
}

-(void)setModel:(Comment *)model{
    _model = model;
    [_iconView sd_setImageWithURL:IMAGE(_model.avatarPath) placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    _nameLable.text = model.userName;
    _contentLabel.text = model.commentContent;
    _timeLabel.text = [ProjectConfig updateTimeForRow:model.createTime];
    [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:15];
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
