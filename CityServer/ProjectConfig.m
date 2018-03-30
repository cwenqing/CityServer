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
#import <AVFoundation/AVFoundation.h>
@implementation ProjectConfig

+ (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath{

    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = IMAGE(filePath);
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    shotImage = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return shotImage;
    
}

/** 通过行数, 返回更新时间 */
+ (NSString *)updateTimeForRow:(NSInteger)oldTime {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = oldTime/1000;
    // 时间差
    NSTimeInterval time = currentTime - createTime;

    //分钟
    NSInteger sec = time/60;
    if (sec<60) {
        if (sec == 0) {
            return @"刚刚";
        }else
            return [NSString stringWithFormat:@"%ld分钟前",sec];
    }
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld个月前",months];
    }
    //秒转年
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",years];
}

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

+(UIImage*)createImageWithColor:(UIColor*) color
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

//友盟分享
+(void)UMSocialWithImage:(UIImage *)image AndTitle:(NSString *)title AndContent:(NSString *)content AndWebpageUrl:(NSString *)webpageUrl AndCurrentViewController:(id)currentViewController{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        //        NSString* thumbURL =  imageUrl;
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:image];
        
        //设置网页地址
        shareObject.webpageUrl = webpageUrl;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentViewController completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
    }];
    
}

@end
