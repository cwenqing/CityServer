
//
//  AppDelegate.m
//  CityServer
//
//  Created by 陈文清 on 2017/12/12.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "BaseTabbarController.h"
#import "BaseNavaViewController.h"
#import "MemberCofig.h"
#import "RCDRCIMDataSource.h"
#import <CoreLocation/CoreLocation.h>
@interface AppDelegate ()<CLLocationManagerDelegate,RCIMReceiveMessageDelegate>

@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,strong)UITabBarItem *item;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 60.0f;
    
    [WXApi registerApp:@"wxe73e1b62504ef168"];
    
    [[RCIM sharedRCIM] initWithAppKey:@"n19jmcy5ns3a9"];
    
    /* 设置友盟社会化分享appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5a98fc0f8f4a9d7f32000092"];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    // 设置用户反馈界面激活方式为三指拖动
    [[PgyManager sharedPgyManager] setFeedbackActiveType:kPGYFeedbackActiveTypeThreeFingersPan];
    
    [[PgyManager sharedPgyManager] setThemeColor:NavColor];
    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"fc03e46bded82b39c8c257c9a8ab4ffb"];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"fc03e46bded82b39c8c257c9a8ab4ffb"];
    
    [[PgyUpdateManager sharedPgyManager] checkUpdate];

    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self createLocationManager];
    [_locationManager startUpdatingLocation];
    
    UIStoryboard * destinationStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //判断是否登录
    NSDictionary *DIC = [ProjectConfig GetValueForKey:@"MemberCofig"];
    if (DIC) {
        NSLog(@"%@",DIC);
        MemberCofig *member = [MemberCofig shareInstance];
        [member updateWithDictionary:DIC];
         UITabBarController* homeVC = [destinationStoryboard instantiateViewControllerWithIdentifier:@"BaseTabbarController"];
        
        _item = [homeVC.tabBar.items objectAtIndex:1];
        
        self.window.rootViewController = homeVC;
        
        //开启用户信息和群组信息的持久化
        [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
        //设置用户信息源和群组信息源
        [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
        [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
        [RCIM sharedRCIM].receiveMessageDelegate = self;
        
        RCUserInfo *_currentUserInfo =
        [[RCUserInfo alloc] initWithUserId:member.rongyunId name:member.userName portrait:member.avatarPath];
        [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
        
        [[RCIM sharedRCIM] connectWithToken:member.rongyunToken success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            int totalUnreadCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                 [_item pp_addBadgeWithNumber:totalUnreadCount];
            });
           
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", status);
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NSLog(@"token错误");
        }];
    }else{

        BaseNavaViewController * loginVC = [destinationStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.window.rootViewController = loginVC;
    }
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self.window makeKeyAndVisible];
    
    [self checkUpdate];
    return YES;
}

- (void)checkUpdate{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString * versionNum = [app_Version stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSDictionary*dic = @{
                         @"versionNum":versionNum,
                         @"systemType":@"2"
                         };
    [CWNetWorkTool requestGetWithPath:CHECKUPDATE_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            if ([obj[@"data"][@"updateStatus"] integerValue] == 1) {
                [ProjectConfig SetValue:@"1" forKey:@"hasNew"];
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的App不是最新版本，请问是否更新" preferredStyle:UIAlertControllerStyleAlert];
                
                if ([obj[@"data"][@"forceUpdate"] integerValue] != 1){
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertVC addAction:action];
                }
                
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    // itms-apps://itunes.apple.com/cn/app/wang-yi-yun-yin-le-pao-bufm/id590338362?mt=8
                    NSURL *url = [NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://tchutong.com/cityimg/app/manifest.plist"];
                    [[UIApplication sharedApplication] openURL:url];
                    
                }];
                
                [alertVC addAction:action1];
                [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
            }
        }
    } Fail:^(id obj) {
    }];
}

-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    int totalUnreadCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        [_item pp_addBadgeWithNumber:totalUnreadCount];
    });
}

#pragma mark - 初始化定位
-(void) createLocationManager{
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
        //        _currentCity = [[NSString alloc]init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0;
        [_locationManager startUpdatingLocation];
    }
}

#pragma mark - 定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//        [[UIApplication sharedApplication]openURL:settingURL];
//    }];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [alert addAction:cancel];
//    [alert addAction:ok];
//    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations firstObject];
    //当前的经纬度
    NSLog(@"当前的经纬度 %f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    _latitude = currentLocation.coordinate.latitude;
    _longitude = currentLocation.coordinate.longitude;
    NSLog(@"经度：%f",_latitude);
    NSLog(@"纬度：%f",_longitude);
    
    //这里的代码是为了判断didUpdateLocations调用了几次 有可能会出现多次调用 为了避免不必要的麻烦 在这里加个if判断 如果大于1.0就return
    NSTimeInterval locationAge = -[currentLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 1.0){//如果调用已经一次，不再执行
        return;
    }
    
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    
    //反地理编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];

            /*看需求定义一个全局变量来接收赋值*/
            NSLog(@"----%@",placeMark.administrativeArea);//当前国家
            self.province = placeMark.administrativeArea;
            NSLog(@"%@",placeMark.locality);//具体地址
            self.city = placeMark.locality;
            NSLog(@"%@",placeMark.subLocality);//具体地址
            self.district = placeMark.subLocality;
            
        }
    }];
    
}

#pragma mark - 友盟社会化分享初始化
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxe73e1b62504ef168" appSecret:@"9ec32961f0a1ccf2b21199a9429ee61a" redirectURL:nil];

    
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            switch ([resultDic[@"resultStatus"] intValue]) {
                case 9000:
                    {
                        [ProjectConfig mbRpogressHUDAlertWithText:@"支付成功" WithProgress:nil];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"ALIPAYSUCCESS" object:nil];
                    }
                    break;
                    
                default:
                    break;
            }
        }];
    }else if([url.host isEqualToString:@"pay"]){
        NSLog(@"%@",url.host);
        return [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
        
        
        //微信第三方登录
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            switch ([resultDic[@"resultStatus"] intValue]) {
                case 9000:
                {
                    [ProjectConfig mbRpogressHUDAlertWithText:@"支付成功" WithProgress:nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"PAYSUCCESS" object:nil];
                }
                    break;
                    
                default:
                    break;
            }
        }];
    }else if([url.host isEqualToString:@"pay"]){
        NSLog(@"%@",url.host);
        return [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
        
        
        //微信第三方登录
    }
    return YES;
}

- (void)onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    if([resp isKindOfClass:[PayResp class]]){
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"支付成功！";
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PAYSUCCESS" object:nil];
            }
                break;
            case WXErrCodeUserCancel:
                strMsg = @"订单取消！";
                
                break;
            case WXErrCodeSentFail:
                strMsg = @"发送失败！";
                
                break;
            case WXErrCodeAuthDeny:
                strMsg = @"授权失败！";
                
                break;
            case -10010:
                strMsg = @"请求服务器查看交易结果!";
                break;
            default:
                strMsg = @"微信不支持！";
                
                break;
        }
        [ProjectConfig mbRpogressHUDAlertWithText:strMsg WithProgress:nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
