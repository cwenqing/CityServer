//
//  UIView+Utils.m
//  CityServer
//
//  Created by 陈文清 on 2018/1/9.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)
- (UIView*)subViewOfClassName:(NSString*)className {
    for (UIView* subView in self.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className]) {
            return subView;
        }
        
        UIView* resultFound = [subView subViewOfClassName:className];
        if (resultFound) {
            return resultFound;
        }
    }
    return nil;
}


@end
