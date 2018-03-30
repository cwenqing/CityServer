//
//  VYLivePayCell.h
//  VYLiveShop
//
//  Created by 孙明 on 2017/9/13.
//  Copyright © 2017年 jwdlh. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol VYLiveOrderPayCellDelegate <NSObject>

-(void)didSected:(UIButton *)sender;

@end
@interface VYLivePayCell : UITableViewCell

@property(nonatomic,strong)UIImageView *Image;
@property(nonatomic,strong)UILabel *payLab;
@property(nonatomic,strong)UILabel *securityPayLab;

@property(nonatomic,strong)UIButton *selectedBtn;

@property(nonatomic,weak)id<VYLiveOrderPayCellDelegate>delegare;

@end
