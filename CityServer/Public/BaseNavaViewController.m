//
//  BaseNavaViewController.m
//  IPadministrator
//
//  Created by transfar on 16/3/15.
//  Copyright © 2016年 transfar. All rights reserved.
//

#import "BaseNavaViewController.h"

@interface BaseNavaViewController ()

@end

@implementation BaseNavaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationBar setBarTintColor:NavColor];
//    self.navigationBar.opaque = YES;
//    self.navigationBar.translucent = YES;
//    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
//    [self.navigationBar setTintColor:[UIColor whiteColor]];
//    self.tabBarItem.selectedImage = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:NavColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.tintColor = [UIColor grayColor];

    
    self.navigationBar.barTintColor = NavColor;
    [UIApplication sharedApplication].statusBarStyle = UIBarStyleBlackOpaque;
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
