//
//  ChoosePayTypeViewController.m
//  CityServer
//
//  Created by jwdlh on 2018/2/1.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "ChoosePayTypeViewController.h"
#import "VYLivePayCell.h"
#import "RCDRCIMDataSource.h"

#define VYLiveOrderPayCellID @"VYLivePayCell"
@interface ChoosePayTypeViewController ()<UITableViewDelegate,UITableViewDataSource,VYLiveOrderPayCellDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIButton *selectButton;
@property(nonatomic,strong)NSString *paykey;
@property(nonatomic,strong)NSString *buytype;

@end

@implementation ChoosePayTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess) name:@"PAYSUCCESS" object:nil];
    
    [self createUI];
    _buytype = @"1";
}

-(void)createUI;
{
    self.navigationItem.title = @"支付方式";
    
    self.view.backgroundColor = BACColor;
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[VYLivePayCell class] forCellReuseIdentifier:VYLiveOrderPayCellID];
    
    UIButton *addBtn = [[UIButton alloc]init];
    [addBtn setBackgroundColor:NavColor];
    
    [addBtn setTitle:@"支付" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [addBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    _tableView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 50);
    
    addBtn.sd_layout
    .topSpaceToView(_tableView, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
}

- (void)pay{
    NSDictionary*dic = @{
                         @"userId":_userId,
                         };
    NSString *payUrl;
    switch ([_buytype intValue]) {
        case 0:
            return;
            break;
        case 1:
            payUrl = WXMEMBERPAYORDER_URL;
            break;
        case 2:
            payUrl = ALIMEMBERPAYORDER_URL;
            break;
            
        default:
            break;
    }
    
    [CWNetWorkTool requestPostWithPath:payUrl andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            switch ([_buytype intValue]) {
                case 1:
                    {
                        PayReq *request = [[PayReq alloc] init];
                        request.partnerId = obj[@"data"][@"partnerid"];
                        request.prepayId = obj[@"data"][@"prepayid"];
                        request.package = obj[@"data"][@"package"];
                        request.nonceStr = obj[@"data"][@"noncestr"];
                        request.timeStamp = [obj[@"data"][@"timestamp"] intValue];
                        request.sign= obj[@"data"][@"sign"];
                        [WXApi sendReq:request];
                    }
                    break;
                case 2:
                    {
                        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
                        NSString *appScheme = @"tchutong";
                        // NOTE: 调用支付结果开始支付
                        [[AlipaySDK defaultService] payOrder:obj[@"data"][@"orderInfo"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                            NSLog(@"reslut = %@",resultDic);
                            
                        }];
                    }
                    break;
                    
                default:
                    break;
            }
   
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
        
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

- (void)paySuccess{
    if (_userPhoneNum) {
        [self loginWithCount:3];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)loginWithCount:(int)count{
    MBProgressHUD *progress = [ProjectConfig createMBProgressWithMessage:@"正在登录..."];
    NSDictionary*dic = @{
                         @"userName":_userPhoneNum,
                         @"password":_userPassword
                         };
    [CWNetWorkTool requestPostWithPath:LOGIN_RUL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            MemberCofig *member = [MemberCofig shareInstance];
            [member updateWithDictionary:obj[@"data"]];
            [ProjectConfig mbRpogressHUDAlertWithText:@"登录成功" WithProgress:progress];
            [self performSegueWithIdentifier:@"paySuccess" sender:nil];
            
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
        }else{
            __block int blockCount  = count;
            if (blockCount > 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    blockCount--;
                    [self loginWithCount:blockCount];
                });
            }else{
                [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:progress];
            }
        }
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:progress];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    lab.font = [UIFont systemFontOfSize:15];
    lab.text = @"选择支付方式";
    [view addSubview:lab];
    
    return view;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VYLivePayCell *cell = [tableView dequeueReusableCellWithIdentifier:VYLiveOrderPayCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.securityPayLab.textColor = [UIColor grayColor];
    
    cell.delegare = self;
    
    cell.selectedBtn.tag = indexPath.row;
    cell.selectedBtn.selected = YES;
    if (indexPath.row == 0) {
        self.selectButton = cell.selectedBtn;
    }
    
    if (indexPath.row ==1) {
        [cell.Image setImage:[UIImage imageNamed:@"zhifubaozhifu"]];
        cell.securityPayLab.text = @"支付宝安全支付";
        cell.payLab.text = @"支付宝支付";
        cell.selectedBtn.selected = NO;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)didSected:(UIButton *)sender
{
    
    
    if (sender.tag ==0) {
        _buytype = @"1";
    }else if (sender.tag == 1)
    {
        _buytype = @"2";
    }
    if (sender!= self.selectButton) {
        self.selectButton.selected = NO;
        sender.selected = YES;
        self.selectButton = sender;
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
