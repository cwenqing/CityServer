//
//  IdentityChooseViewController.h
//  CityServer
//
//  Created by jwdlh on 2017/12/19.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdentityChooseViewController : UIViewController
@property (nonatomic, assign)int viewType;
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *userPhoneNum;
@property (nonatomic, copy)NSString *userPassword;
@end
