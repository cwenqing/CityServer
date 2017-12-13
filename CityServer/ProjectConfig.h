//
//  ProjectConfig.h
//  SingerControl
//
//  Created by john on 14-3-7.
//  Copyright (c) 2014年 john. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+extension.h"
#import "NSString+MD5.h"
#import "MJRefresh.h"

#define MainScreenFrame [[UIScreen mainScreen] bounds]

#define ScreenSize                             MainScreenFrame.size

#define ScreenWidth                             MainScreenFrame.size.width

#define ScreenHeigth                                MainScreenFrame.size.height

#define TabBarHeight                           49

#define NavationBarHeigth                       64

#define StatueBarHeight                        20

#define ViewWidth(x)                           CGRectGetWidth(x.bounds)

#define ViewHeigth(x)                          CGRectGetHeight(x.bounds)

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define GMColor(rgbValue) [UIColor colorWithHexString:(rgbValue)]

#define FONT(FONTSIZE)  [UIFont systemFontOfSize:FONTSIZE]

#define SystemVersion  [[[UIDevice currentDevice] systemVersion] floatValue]//获取版本号

#define IPHONEVISION (ScreenWidth == 320) ? @"5" : (ScreenWidth == 375) ? @"6" : @"6plus"

#define degreesToRadians(x) (M_PI*(x)/180.0)

#define Version  [[[UIDevice currentDevice] systemVersion] floatValue]//获取版本号

#define YFlage (Version < 7) ? 20 : 0

#define NavColor RGBA(15,114,180,1)

#define NextPoint(view)    CGPointMake((view).frame.size.width+(view).frame.origin.x, (view).frame.size.height + (view).frame.origin.y)


typedef void (^Callback)(id obj);

@interface ProjectConfig : NSObject


+ (MBProgressHUD *)createMBProgressWithMessage:(NSString *)message;

+ (void)mbRpogressHUDAlertWithText:(NSString *)string WithProgress:(MBProgressHUD *)hud;

+ (void)mbRpogressHUDAlertWithText:(NSString *)string;

+(id)GetValueForKey:(NSString*)key;

+(void)SetValue:(id)value forKey:(NSString *)key;

+(void)setString:(NSString*)string forKey:(NSString*)key;

+(NSDictionary*)appInfo;

//32位MD5加密方式
+(NSString *)getMd5_32Bit_String:(NSString *)srcString;

+ (BOOL)isPureInt:(NSString*)string;

+ (NSString *)getCurrentTime;

+(UIImage*) createImageWithColor:(UIColor*) color;

@end
