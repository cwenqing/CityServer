//
//  FansFollowTableViewCell.h
//  CityServer
//
//  Created by 陈文清 on 2018/1/1.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FansFollow.h"
#import "Contacts.h"
@protocol AddAttentionFansFollowDelegate <NSObject>

- (void)addAttentionWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface FansFollowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)FansFollow *fansFollow;
@property (nonatomic, strong)Contacts *contacts;
@property (nonatomic, assign)id<AddAttentionFansFollowDelegate> delegate;
@end
