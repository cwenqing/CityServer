//
//  HomeHeadView.m
//  CityServer
//
//  Created by jwdlh on 2017/12/25.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import "HomeHeadView.h"

@implementation HomeHeadView
- (IBAction)serverButtonClicked:(UIButton *)sender {
    [self.delegate serverButtonClicked:(int)sender.tag-600];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
