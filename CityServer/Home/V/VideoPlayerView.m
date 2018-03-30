//
//  VideoPlayerView.m
//  CityServer
//
//  Created by 陈文清 on 2018/1/12.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "VideoPlayerView.h"

@implementation VideoPlayerView
{
    AVPlayerItem *item;
    AVPlayer *player;
    AVPlayerLayer *layer;
    UIActivityIndicatorView *activityIndicatorView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        
        
        
        
    }
    return self;
}

-(void)setPlayUrl:(NSString *)playUrl{
    _playUrl = playUrl;
    // 2.创建AVPlayerItem
    item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_playUrl]];
    
    //通过KVO来观察status属性的变化，来获得播放之前的错误信息
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    
    // 3.创建AVPlayer
    player = [AVPlayer playerWithPlayerItem:item];
    
    // 4.添加AVPlayerLayer
    layer = [AVPlayerLayer playerLayerWithPlayer:player];

    layer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
    [self.layer addSublayer:layer];
    
    [player play];
    
    activityIndicatorView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0,0,100,100)];
    activityIndicatorView.center=CGPointMake(ScreenWidth/2, ScreenHeigth/2);
    [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    [button addTarget:self action:@selector(playerClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                NSLog(@"item 有误");
                
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准好播放了");
                [activityIndicatorView stopAnimating];
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"视频资源出现未知错误");
                
                break;
            default:
                break;
        }
    }
    //移除监听（观察者）
    [object removeObserver:self forKeyPath:@"status"];
}


- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [window addSubview:self];
}

- (void)playerClicked{
    [layer removeFromSuperlayer];
    [self removeFromSuperview];
   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
