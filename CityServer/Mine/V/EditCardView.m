//
//  EditCardView.m
//  CityServer
//
//  Created by qing on 2018/3/14.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "EditCardView.h"

@implementation EditCardView

-(void)awakeFromNib{
    [super awakeFromNib];
    _view0.layer.borderWidth = 1;
    _view0.layer.borderColor = GMColor(@"#cecece").CGColor;
    
    _view1.layer.borderWidth = 1;
    _view1.layer.borderColor = GMColor(@"#cecece").CGColor;
    
    _view2.layer.borderWidth = 1;
    _view2.layer.borderColor = GMColor(@"#cecece").CGColor;
    
    _view3.layer.borderWidth = 1;
    _view3.layer.borderColor = GMColor(@"#cecece").CGColor;
    
    _view4.layer.borderWidth = 1;
    _view4.layer.borderColor = GMColor(@"#cecece").CGColor;
    
    _view5.layer.borderWidth = 1;
    _view5.layer.borderColor = GMColor(@"#cecece").CGColor;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
