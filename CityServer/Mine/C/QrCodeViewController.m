//
//  QrCodeViewController.m
//  CityServer
//
//  Created by qing on 2018/3/9.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "QrCodeViewController.h"

@interface QrCodeViewController ()
{
    
    __weak IBOutlet UIImageView *qrCodeimg;
}
@property (nonatomic, copy)NSString *shareURL;
@end

@implementation QrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的推荐码";
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"tuijian-fenxiang"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]   style:UIBarButtonItemStylePlain target:self action:@selector(didClickShare)];
    
    self.navigationItem.rightBarButtonItem =share;
    [self getQrCode];
}

- (void)didClickShare{
    [ProjectConfig UMSocialWithImage:[UIImage imageNamed:@"矢量智能对象"] AndTitle:@"快来同城互通分享名片，快速了解周边行业达人，交换最有价值的商业信息！" AndContent:@"同城互通是一家从事以互联网信息业务为主的科技软件公司。从创立开始，本着“客户至上，质量为本”的原则， “以人才和技术为基础、创造最佳产品和服务”的经营理念。致力于为客户塑造个人形象，为客户提供服务。" AndWebpageUrl:[NSString stringWithFormat:@"%@?ts=%@",@"http://www.tchutong.com/h5share/after_share.html",[self currentTimeStr]] AndCurrentViewController:self];
}

//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

- (void)getQrCode{
    NSDictionary*dic = @{
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestGetWithPath:QRCODE_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            [qrCodeimg sd_setImageWithURL:[NSURL URLWithString:obj[@"data"][@"path"]]];
            
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
    
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
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
