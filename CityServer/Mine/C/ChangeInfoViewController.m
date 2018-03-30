//
//  ChangeInfoViewController.m
//  CityServer
//
//  Created by 陈文清 on 2017/12/22.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import "ChangeInfoViewController.h"

@interface ChangeInfoViewController ()

@end

@implementation ChangeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    switch (_viewType) {
        case 1:
            self.title = @"修改昵称";
            break;
        case 2:
            self.title = @"修改真实姓名";
            break;
        case 5:
            self.title = @"修改个性签名";
            break;
        default:
            break;
    }
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
