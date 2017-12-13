//
//  ProjectConfig.m
//  SingerControl
//
//  Created by john on 14-3-7.
//  Copyright (c) 2014年 john. All rights reserved.
//

#import "ProjectConfig.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
@implementation ProjectConfig


+ (MBProgressHUD *)createMBProgressWithMessage:(NSString *)message{
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MBProgressHUD *mbProgress = [MBProgressHUD showHUDAddedTo:appdelegate.window animated:YES];
    mbProgress.label.text = message;
    return mbProgress;
}

/**
 *  mbpogressHUD文字弹出框
 *
 *  @param string      显示文字
 *  @param hud 显示页面
 */

+ (void)mbRpogressHUDAlertWithText:(NSString *)string WithProgress:(MBProgressHUD *)hud{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (!hud) hud = [MBProgressHUD showHUDAddedTo:appdelegate.window animated:YES];
    //hud.color = [UIColor colorWithHexString:@"#ededed"];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = string;
    //hud.labelColor = [UIColor colorWithHexString:@"#8b8b8b"];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:.8];
    
}

/**
 *  mbpogressHUD文字弹出框
 *
 *  @param string      显示文字
 */

+ (void)mbRpogressHUDAlertWithText:(NSString *)string{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:appdelegate.window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = string;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:.5];
    
}

/**
 *  获取沙盒NSUserDefaults中数据
 *
 *  @param key key值
 *
 *  @return key所带的object
 */
+(id)GetValueForKey:(NSString*)key{
    
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (data) {
        id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([obj isKindOfClass:[NSArray class]]) {//如果是数组 ＝＝》转变为可变数组。
            NSMutableArray *array =[[NSMutableArray alloc]init];
            @autoreleasepool {
                for (id subobj in obj) {
                    if ([subobj isKindOfClass:[NSDictionary class]]) {//如果是字典，转变为可变字典。
                        NSMutableDictionary *mutabledic =[NSMutableDictionary dictionaryWithDictionary:subobj];
                        [array addObject:mutabledic];
                    }else{
                        [array addObject:subobj];
                    }
                }
            }
            obj = nil;
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            return array;
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return obj;
    }else{
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return nil;
    }
}

/**
 *  存入数据至沙盒NSUserDefaults
 *
 *  @param value object
 *  @param key   key
 */

+(void)SetValue:(id)value forKey:(NSString *)key{
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:
     [NSKeyedArchiver archivedDataWithRootObject:value]
                                              forKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setString:(NSString*)string forKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}

/**
 *  获取项目所需文件
 *
 *  @return infoDictionary 包含了项目中几乎所有的基本信息，SDK版本，项目名称等。
 */
+(NSDictionary*)appInfo{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary;
}

/**
 *  32位MD5加密方式
 *
 *  @param srcString 加密前数据
 *
 *  @return 加密后数据
 */

+(NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

/**
 *  判断是否为整数
 *
 *  @param string 判断的数
 *
 *  @return 是否为整数
 */

+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (NSString *)getCurrentTime{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    
    return  currentTime;
}

+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end
