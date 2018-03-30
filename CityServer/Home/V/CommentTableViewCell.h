//
//  CommentTableViewCell.h
//  CityServer
//
//  Created by 陈文清 on 2018/1/10.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
@interface CommentTableViewCell : UITableViewCell
@property (nonatomic, strong) Comment *model;
@end
