//
//  VYLivePayCell.m
//  VYLiveShop
//
//  Created by 孙明 on 2017/9/13.
//  Copyright © 2017年 jwdlh. All rights reserved.
//

#import "VYLivePayCell.h"

@implementation VYLivePayCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        [self setupUI];
        [self addTarget];
    }
    
    return self;
}

-(void)setupUI
{
    _Image = [UIImageView new];
    [_Image setImage:[UIImage imageNamed:@"weixinzhifu"]];
    
    
    _payLab = [UILabel new];
    _payLab.font = [UIFont systemFontOfSize:15];
    
    _payLab.text = @"微信支付";
    
    
    _securityPayLab = [UILabel new];
    _securityPayLab.font = [UIFont systemFontOfSize:13];
    _securityPayLab.text = @"微信安全支付";
    
    
    
    _selectedBtn = [UIButton new];
    
    [_selectedBtn setImage:[UIImage imageNamed:@"weixuanze"] forState:UIControlStateNormal];
    [_selectedBtn setImage:[UIImage imageNamed:@"qiye-xuanzhong"] forState:UIControlStateSelected];
    
    NSArray *views = @[_Image,_payLab,_securityPayLab,_selectedBtn];
    
    [self.contentView sd_addSubviews:views];
    
    
    _Image.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .centerYEqualToView(self.contentView)
    .widthIs(35)
    .heightIs(35);
    
    _payLab.sd_layout
    .leftSpaceToView(_Image, 8)
    .topEqualToView(_Image)
    .widthIs(80)
    .heightIs(20);
    
    _securityPayLab.sd_layout
    .leftEqualToView(_payLab)
    .bottomEqualToView(_Image)
    .widthIs(120)
    .heightIs(20);
    
    _selectedBtn.sd_layout
    .rightSpaceToView(self.contentView, 5)
    .topSpaceToView(self.contentView, 0)
    .widthIs(25)
    .heightIs(60);
    

    
    
    
    
}
-(void)addTarget
{
    [_selectedBtn addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)selected:(UIButton *)sender

{    if(_delegare)
{
    [self.delegare didSected:sender];
}
    
}


//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
