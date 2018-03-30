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
#import "MemberCofig.h"
#import <UShareUI/UShareUI.h>
#import "AppDelegate.h"

#define MainScreenFrame [[UIScreen mainScreen] bounds]

#define ScreenSize                             MainScreenFrame.size

#define ScreenWidth                             MainScreenFrame.size.width

#define ScreenHeigth                                MainScreenFrame.size.height

// iPhone X
#define  LL_iPhoneX (ScreenWidth == 375.f && ScreenHeigth == 812.f ? YES : NO)

#define TabBarHeight                           (LL_iPhoneX ? (49.f+34.f) : 49.f)

#define NavationBarHeigth                       (LL_iPhoneX ? 88.f : 64.f)

#define StatueBarHeight                         (LL_iPhoneX ? 44.f : 20.f)

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

#define NavColor RGBA(56,107,248,1)

#define BACColor RGBA(244,243,242,1)

#define NextPoint(view)    CGPointMake((view).frame.size.width+(view).frame.origin.x, (view).frame.size.height + (view).frame.origin.y)

#define MEMBER [MemberCofig shareInstance]

#define IMAGE(image) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PATH, image]]

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define KAppDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)

//状态条的高
#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//得到屏幕bounds
#define SCREEN_SIZE [UIScreen mainScreen].bounds
//得到屏幕height
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//得到屏幕width
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

typedef void (^Callback)(id obj);

@interface ProjectConfig : NSObject

+ (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath;

/** 通过行数, 返回更新时间 */
+ (NSString *)updateTimeForRow:(NSInteger)oldTime;

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

//友盟分享
+(void)UMSocialWithImage:(UIImage *)image AndTitle:(NSString *)title AndContent:(NSString *)content AndWebpageUrl:(NSString *)webpageUrl AndCurrentViewController:(id)currentViewController;

@end
