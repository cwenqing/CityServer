//
//  BaseTabbarController.m
//  IPadministrator
//
//  Created by transfar on 16/3/15.
//  Copyright © 2016年 transfar. All rights reserved.
//

#import "BaseTabbarController.h"

@interface BaseTabbarController ()

@end

@implementation BaseTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _noticeCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/8*5 + 8, 0, 20, 20)];
    _noticeCountLabel.backgroundColor = [UIColor redColor];
    _noticeCountLabel.textColor = [UIColor whiteColor];
    _noticeCountLabel.textAlignment = NSTextAlignmentCenter;
    _noticeCountLabel.layer.cornerRadius = 10;
    _noticeCountLabel.layer.masksToBounds = YES;
    [self.tabBar addSubview:_noticeCountLabel];
    _noticeCountLabel.hidden = YES;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
