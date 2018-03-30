//
//  CWNetWorkTool.m
//  CityServer
//
//  Created by 陈文清 on 2017/12/18.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import "CWNetWorkTool.h"

@implementation CWNetWorkTool

/**
 Get请求
 
 @param path       路径
 @param parameters 参数
 @param Success    成功回调
 @param Fail       失败回调
 */
+(void)requestGetWithPath:(NSString*)path andParameters:(id)parameters andSuccess:(Callback)Success
                      Fail:(Callback)Fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15.0f;
    NSString *mainPath = [NSString stringWithFormat:@"%@%@",MAIN_PATH, path];
    [manager GET:mainPath parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *returnMessage = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"------%@",returnMessage);
        if ([dic[@"status"] intValue] == 407) {
            [[RCIM sharedRCIM] logout];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MemberCofig"];
            UIStoryboard * destinationStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController * loginVC = [destinationStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            app.window.rootViewController =loginVC;

            [app.window makeKeyAndVisible];
            [ProjectConfig mbRpogressHUDAlertWithText:dic[@"message"] WithProgress:nil];
        }else
            Success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败%@",error);
        Fail(error);
    }];
    
}


/**
 Post请求
 
 @param path       路径
 @param parameters 参数
 @param Success    成功回调
 @param Fail       失败回调
 */
+(void)requestPostWithPath:(NSString*)path andParameters:(id)parameters andSuccess:(Callback)Success
                      Fail:(Callback)Fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15.0f;
    NSString *mainPath = [NSString stringWithFormat:@"%@%@",MAIN_PATH, path];
    [manager POST:mainPath parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *returnMessage = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"------%@",returnMessage);
        if ([dic[@"status"] intValue] == 407 && ![path isEqualToString:LOGIN_RUL]) {
            [[RCIM sharedRCIM] logout];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MemberCofig"];
            UIStoryboard * destinationStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController * loginVC = [destinationStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            app.window.rootViewController =loginVC;
            
            [app.window makeKeyAndVisible];
            [ProjectConfig mbRpogressHUDAlertWithText:dic[@"message"] WithProgress:nil];
            //            [self.view removeFromSuperview];
        }else
            Success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败%@",error);
        Fail(error);
    }];
    
}



/**
 Post图片

 @param path 路径
 @param parameters 参数
 @param imageArr 图片数组
 @param name 图片名
 @param Progress 上传进度
 @param Success 成功回调
 @param Fail 失败回调
 */
+(void)upLoadImgPostWithPath:(NSString*)path andParameters:(id)parameters andImageArr:(NSArray *)imageArr andName:(NSString *)name Progress:(Callback)Progress Success:(Callback)Success Fail:(Callback)Fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *mainPath = [NSString stringWithFormat:@"%@%@",MAIN_PATH, path];
    
    [manager POST:mainPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imageArr.count; i++)
        {
            NSData *imageData = imageArr[i];
            // 上传的参数名
            //NSString * Name = [NSString stringWithFormat:@"files%d",i+1];
            // 上传filename
            NSString * fileName = [NSString stringWithFormat:@"%@%d.png",[ProjectConfig getCurrentTime] ,i+1];
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        Progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *returnMessage = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"------%@",returnMessage);
        Success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败%@",error);
        Fail(error);
        
    }];
    
}

/**
 Post上传文件
 
 @param path 路径
 @param parameters 参数
 @param fileArr 文件数组
 @param name 参数
 @param Progress 上传进度
 @param Success 成功回调
 @param Fail 失败回调
 */
+(void)upLoadImgPostWithPath:(NSString*)path andParameters:(id)parameters andFileArr:(NSArray *)fileArr andName:(NSString *)name Progress:(Callback)Progress Success:(Callback)Success Fail:(Callback)Fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *mainPath = [NSString stringWithFormat:@"%@%@",MAIN_PATH, path];
    
    [manager POST:mainPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < fileArr.count; i++)
        {
//            NSData *imageData = fileArr[i];
            NSURL *fileUrl = fileArr[i];
            NSData *data = [NSData dataWithContentsOfURL:fileUrl];
            NSString *str1 = [fileUrl absoluteString];
            if ([str1 hasSuffix:@"mp4"]) {
                // 上传的参数名
                // 上传filename
                NSString * fileName = [NSString stringWithFormat:@"%@%d.mp4",[ProjectConfig getCurrentTime] ,i+1];
                [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"video/mp4"];
            }else{
                // 上传的参数名
                // 上传filename
                NSString * fileName = [NSString stringWithFormat:@"%@%d.png",[ProjectConfig getCurrentTime] ,i+1];
                [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpeg"];
            }
            
//            [formData appendPartWithFileURL:imageUrl name:name fileName:fileName mimeType:@"image/jpeg" error:nil];
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        Progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *returnMessage = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"------%@",returnMessage);
        Success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败%@",error);
        Fail(error);
        
    }];
    
}

-(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        
        NSLog(@"===%@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}

@end
