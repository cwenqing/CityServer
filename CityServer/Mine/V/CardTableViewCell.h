//
//  CardTableViewCell.h
//  CityServer
//
//  Created by jwdlh on 2018/2/2.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardTableViewCellDelegate <NSObject>

- (void)editCardWithIndexPath:(NSIndexPath *)indexPath;

- (void)shareCardWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface CardTableViewCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, assign)id<CardTableViewCellDelegate> delegate;
@end
