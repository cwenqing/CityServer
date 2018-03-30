//
//  MemberDetailInfoViewController.h
//  CityServer
//
//  Created by jwdlh on 2018/2/2.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contacts.h"
#import "Recommend.h"
#import "FansFollow.h"
@interface MemberDetailInfoViewController : UIViewController
@property (nonatomic, strong)Contacts *contacts;
@property (nonatomic, strong)Recommend *recommend;
@property (nonatomic, strong)FansFollow *fansFollow;
@end
