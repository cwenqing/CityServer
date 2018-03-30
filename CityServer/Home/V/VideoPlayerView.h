//
//  VideoPlayerView.h
//  CityServer
//
//  Created by 陈文清 on 2018/1/12.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface VideoPlayerView : UIView
@property (nonatomic, copy)NSString *playUrl;
@property (nonatomic, weak) UIView *sourceImagesContainerView;
- (void)show;

@end
