//
//  MemberCenterHeadView.h
//  CityServer
//
//  Created by jwdlh on 2017/12/21.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberCenterInfo.h"

@protocol MemberHeadViewDelegate <NSObject>

-(void)checkFollowOrFans:(int)index;

-(void)checkMemberInfo;

@end

@interface MemberCenterHeadView : UIView
@property (nonatomic, assign)id<MemberHeadViewDelegate> delegate;
@property (nonatomic, strong)MemberCenterInfo *memberInfo;
@end
