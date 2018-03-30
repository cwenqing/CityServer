//
//  AppDelegate.h
//  CityServer
//
//  Created by 陈文清 on 2017/12/12.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,assign)float latitude;
@property (nonatomic ,assign)float longitude;
@property (nonatomic ,copy)NSString *province;
@property (nonatomic ,copy)NSString *city;
@property (nonatomic ,copy)NSString *district;
@end

