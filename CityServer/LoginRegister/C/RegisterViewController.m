//
//  RegisterViewController.m
//  CityServer
//
//  Created by jwdlh on 2017/12/18.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import "RegisterViewController.h"
#import "STPickerArea.h"
#import "RCDRCIMDataSource.h"
#import "IdentityChooseViewController.h"
@interface RegisterViewController ()
{
    __weak IBOutlet UITextField *phoneNumTF;
    __weak IBOutlet UITextField *codeTF;
    __weak IBOutlet UITextField *passwordTF;
    __weak IBOutlet UITextField *refereePhoneTF;
    __weak IBOutlet UITextField *nickNameTF;

    __weak IBOutlet UIButton *codeButton;
    
    
    NSString *choosedProvince;
    NSString *choosedCity;
    NSString *choosedArea;
    
    float latitude;
    float longitude;
    
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)areaChooseButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    [[[STPickerArea alloc]initWithDelegate:self] show];
}



- (IBAction)getCode:(UIButton *)sender {
    NSDictionary*dic = @{
                         @"phone":phoneNumTF.text,
                         @"smsType":@"1"
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


- (IBAction)identityChoose:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSDictionary*dic;
    
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        dic = @{
                @"phone":phoneNumTF.text,
                @"verificationCode":codeTF.text,
                @"password":passwordTF.text,
                @"userName":nickNameTF.text,
                @"introducer":refereePhoneTF.text,
                };
        [self registerWithDic:dic];
    }else{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //反地理编码
        CLLocation *loca = [[CLLocation alloc]initWithLatitude:app.latitude longitude:app.longitude];
        CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
        [geoCoder reverseGeocodeLocation:loca completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (placemarks.count > 0) {
                CLPlacemark *placeMark = placemarks[0];
                 NSDictionary*dic = @{
                        @"phone":phoneNumTF.text,
                        @"verificationCode":codeTF.text,
                        @"password":passwordTF.text,
                        @"userName":nickNameTF.text,
                        @"introducer":refereePhoneTF.text,
                        @"city":placeMark.locality,
                        @"district":placeMark.subLocality,
                        @"province":placeMark.administrativeArea,
                        @"latitude":[NSString stringWithFormat:@"%f",app.latitude],
                        @"longitude":[NSString stringWithFormat:@"%f",app.longitude]
                        };
                
                [self registerWithDic:dic];
            }
        }];
        
       
    }

}

- (void)registerWithDic:(NSDictionary*)dic{
    MBProgressHUD *progress = [ProjectConfig createMBProgressWithMessage:@"正在注册..."];
    
    NSString  *url;
    if ([[ProjectConfig GetValueForKey:@"iosType"] intValue] == 2) {
        url = IOSREGISTER_URL;
    }else{
        url = REGISTER_URL;
    }
    
    [CWNetWorkTool requestPostWithPath:url andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            
            if ([[ProjectConfig GetValueForKey:@"iosType"] intValue] == 2) {
                MemberCofig *member = [MemberCofig shareInstance];
                [member updateWithDictionary:obj[@"data"]];
                
                [ProjectConfig mbRpogressHUDAlertWithText:@"注册成功" WithProgress:progress];
                [self performSegueWithIdentifier:@"registerSuccess" sender:nil];
                
                //开启用户信息和群组信息的持久化
                [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
                //设置用户信息源和群组信息源
                [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
                [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
                
                RCUserInfo *_currentUserInfo =
                [[RCUserInfo alloc] initWithUserId:member.rongyunId name:@"我" portrait:@"https://upload-images.jianshu.io/upload_images/5978829-96950ecb95874a3d.jpg"];
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
            }else{
                [ProjectConfig mbRpogressHUDAlertWithText:@"注册成功" WithProgress:progress];
                [self performSegueWithIdentifier:@"identityChoose" sender:obj[@"data"][@"userId"]];
            }
            
            
            
            
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:progress];
        
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:progress];
    }];
}

- (IBAction)gotoLogin:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"identityChoose"]) {
        IdentityChooseViewController *vc = (IdentityChooseViewController *)[segue destinationViewController];
        vc.userId = (NSString *)sender;
        vc.userPhoneNum = phoneNumTF.text;
        vc.userPassword = passwordTF.text;
    }
    
}


@end
