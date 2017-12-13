//
//  UIColor+extension.h
//  BigButler
//
//  Created by hezong002 on 15/7/8.
//  Copyright (c) 2015年 hezong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (extension)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
