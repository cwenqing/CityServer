//
//  MyServerTableViewCell.h
//  CityServer
//
//  Created by 陈文清 on 2018/1/16.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dynamic.h"

@protocol MyServerCellDelegate <NSObject>

- (void)closeServerAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MyServerTableViewCell : UITableViewCell
@property (nonatomic, strong)Dynamic *dynamic;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, assign)id<MyServerCellDelegate> delegate;
@end
