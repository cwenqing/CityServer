//
//  LoginViewController.m
//  CityServer
//
//  Created by jwdlh on 2017/12/18.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import "LoginViewController.h"
#import "RCDRCIMDataSource.h"
@interface LoginViewController ()
{
    __weak IBOutlet UITextField *phoneNumTF;
    
    __weak IBOutlet UITextField *passwordTF;
    
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getMmberType];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.barTintColor = RGBA(247, 246, 246, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBA(55, 55, 55, 1),NSForegroundColorAttributeName,nil]];
    [UIApplication sharedApplication].statusBarStyle = UIBarStyleDefault;
}

- (void)getMmberType{
    [CWNetWorkTool requestGetWithPath:MEMBERTYPE_RUL andParameters:nil andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            [ProjectConfig SetValue:obj[@"data"][@"iosType"] forKey:@"iosType"];
        }
    } Fail:^(id obj) {
        
    }];
}

- (IBAction)loginSuccess:(UIButton *)sender {
//    [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
    MBProgressHUD *progress = [ProjectConfig createMBProgressWithMessage:@"正在登录..."];
    NSDictionary*dic = @{
                         @"userName":phoneNumTF.text,
                         @"password":passwordTF.text
                         };
    [CWNetWorkTool requestPostWithPath:LOGIN_RUL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            MemberCofig *member = [MemberCofig shareInstance];
            [member updateWithDictionary:obj[@"data"]];
            [ProjectConfig mbRpogressHUDAlertWithText:@"登录成功" WithProgress:progress];
            [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
            
            //开启用户信息和群组信息的持久化
            [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
            //设置用户信息源和群组信息源
            [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
            [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
            
            RCUserInfo *_currentUserInfo =
            [[RCUserInfo alloc] initWithUserId:member.rongyunId name:member.userName portrait:member.avatarPath];
            [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
            
            [[RCIM sharedRCIM] connectWithToken:member.rongyunToken success:^(NSString *userId) {
                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            } error:^(RCConnectErrorCode status) {
                NSLog(@"登陆的错误码为:%ld", status);
            } tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                NSLog(@"token错误");
            }];
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:progress];
        
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:progress];
    }];
    
    
    
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
