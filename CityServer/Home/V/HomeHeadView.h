//
//  HomeHeadView.h
//  CityServer
//
//  Created by jwdlh on 2017/12/25.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HomeHeadViewDelegate <NSObject>

- (void)serverButtonClicked:(int)index;

@end
@interface HomeHeadView : UIView
@property (nonatomic, assign)id<HomeHeadViewDelegate> delegate;
@end
