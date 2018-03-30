//
//  ChangePswdViewController.m
//  CityServer
//
//  Created by qing on 2018/3/9.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "ChangePswdViewController.h"
#import "RCDRCIMDataSource.h"
@interface ChangePswdViewController ()
{
    __weak IBOutlet UITextField *phoneNumTF;
    __weak IBOutlet UITextField *codeTF;
    __weak IBOutlet UITextField *passwordTF;
    
    __weak IBOutlet UIButton *codeButton;
}
@end

@implementation ChangePswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
}
- (IBAction)getCode:(UIButton *)sender {
    NSDictionary*dic = @{
                         @"phone":phoneNumTF.text,
                         @"smsType":@"2"
                         };
    [CWNetWorkTool requestGetWithPath:SMSSEND_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            [self openCountdown];
        }
        [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
        
        
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

- (IBAction)srueChange:(UIButton *)sender {
    NSDictionary*dic = @{
                         @"newPassword":passwordTF.text,
                         @"smsCode":codeTF.text
                         };
    [CWNetWorkTool requestPostWithPath:UPDATEPASSWORD_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            MemberCofig *member = [MemberCofig shareInstance];
            [member updateWithDictionary:obj[@"data"]];
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
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
                NSLog(@"登陆的错误码为:%d", status);
            } tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                NSLog(@"token错误");
            }];
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
        
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                codeButton.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [codeButton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                
                codeButton.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
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
