//
//  MemberCenterViewController.m
//  CityServer
//
//  Created by jwdlh on 2017/12/21.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import "MemberCenterViewController.h"
#import "MemberCenterHeadView.h"
#import "MemberCenterTableViewCell.h"
#import "MemberInfoViewController.h"
#import "FansFollowViewController.h"
#import "ServerViewController.h"
#import "MemberCenterInfo.h"
#import "QrCodeViewController.h"
#import "IdentityChooseViewController.h"
#define TITLES @[@"我的动态",@"我的名片", @"充值中心",@"我发布的服务",@"我的推荐码", @"设置"]
#define ICONS  @[@"wodedongtai",@"wodemingpian",@"chongzhizhongxin",@"fabudefuwu",@"tuijianma-",@"shezhi"]
@interface MemberCenterViewController ()<UITableViewDelegate,UITableViewDataSource,MemberHeadViewDelegate>
{
    UITableView *memberCenterTabelView;
    MemberCenterHeadView *headView;
    MemberCenterInfo *memberInfo;
    NSMutableArray *titles;
    NSMutableArray *icons;
    
    BOOL iosType;
}
@end

@implementation MemberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人中心";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    [self createUI];
    titles = [NSMutableArray arrayWithArray:@[@"我的动态",@"我的公益",@"我的名片",@"我发布的服务",@"我的推荐码", @"设置"]];
    icons = [NSMutableArray arrayWithArray:@[@"wodedongtai",@"gongyi",@"wodemingpian",@"fabudefuwu",@"tuijianma-",@"shezhi"]];
}

- (void)createUI{
    memberCenterTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth) style:UITableViewStyleGrouped];
    memberCenterTabelView.backgroundColor = BACColor;
    memberCenterTabelView.delegate = self;
    memberCenterTabelView.dataSource = self;
    memberCenterTabelView.separatorColor = [UIColor clearColor];
    [memberCenterTabelView registerNib:[UINib nibWithNibName:@"MemberCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"MemberCenterTableViewCell"];
    [self.view addSubview:memberCenterTabelView];
    
    headView = [[[NSBundle mainBundle]loadNibNamed:@"MemberCenterHeadView" owner:self options:nil]lastObject];
    headView.frame = CGRectMake(0, 0, ScreenWidth, 180);
    memberCenterTabelView.tableHeaderView = headView;
    headView.delegate = self;

}

- (void)getMmberType{
    [CWNetWorkTool requestGetWithPath:MEMBERTYPE_RUL andParameters:nil andSuccess:^(id obj) {
        if ([obj[@"data"][@"iosType"] isEqualToString:@"2"]) {
            iosType = YES;
        }else{
            iosType = NO;
            titles = [NSMutableArray arrayWithArray:@[@"我的动态",@"我的公益",@"我的名片", @"充值中心",@"我发布的服务",@"我的推荐码", @"设置"]];
            icons = [NSMutableArray arrayWithArray:@[@"wodedongtai",@"gongyi",@"wodemingpian",@"chongzhizhongxin",@"fabudefuwu",@"tuijianma-",@"shezhi"]];
        }
        [self getMemberInfo];
        [memberCenterTabelView reloadData];
    } Fail:^(id obj) {
        
    }];
}

- (void)getMemberInfo{
    NSDictionary*dic = @{
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestGetWithPath:MEMBERCENTER_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            memberInfo = [[MemberCenterInfo alloc]initWithDictionary:obj[@"data"]];
            MEMBER.realName = memberInfo.realName;
            headView.memberInfo = memberInfo;
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];

    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = NavColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [UIApplication sharedApplication].statusBarStyle = UIBarStyleBlackOpaque;
    [self getMmberType];
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return icons.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MemberCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCenterTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.iconImg.image = [UIImage imageNamed:icons[indexPath.row]];
    cell.titleLabel.text = titles[indexPath.row];
 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (iosType) {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"MyDynamic" sender:@(indexPath.row)];
                break;
            case 1:
                [self performSegueWithIdentifier:@"MyDynamic" sender:@(indexPath.row)];
                break;
            case 2:
                [self performSegueWithIdentifier:@"MyCards" sender:nil];
                break;
            case 3:
                [self performSegueWithIdentifier:@"MyServer" sender:nil];
                break;
            case 4:
                [self performSegueWithIdentifier:@"QrCode" sender:nil];
                break;
            case 5:
                [self performSegueWithIdentifier:@"setting" sender:nil];
                break;
                
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"MyDynamic" sender:@(indexPath.row)];
                break;
            case 1:
                [self performSegueWithIdentifier:@"MyDynamic" sender:@(indexPath.row)];
                break;
            case 2:
                [self performSegueWithIdentifier:@"MyCards" sender:nil];
                break;
            case 3:
                [self performSegueWithIdentifier:@"PayCenter" sender:nil];
                break;
            case 4:
                [self performSegueWithIdentifier:@"MyServer" sender:nil];
                break;
            case 5:
                [self performSegueWithIdentifier:@"QrCode" sender:nil];
                break;
            case 6:
                [self performSegueWithIdentifier:@"setting" sender:nil];
                break;
                
            default:
                break;
        }
    }
    
    
}

-(void)checkMemberInfo{
    NSLog(@"checkMemberInfo");
    [self performSegueWithIdentifier:@"MemberInfo" sender:memberInfo];
}

-(void)checkFollowOrFans:(int)index{
    [self performSegueWithIdentifier:@"FansFollow" sender:@(index)];
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
    if ([segue.identifier isEqualToString:@"FansFollow"]) {
        FansFollowViewController *vc = (FansFollowViewController *)[segue destinationViewController];
        vc.viewType = [sender intValue];
    }else if([segue.identifier isEqualToString:@"MemberInfo"]) {
        MemberInfoViewController *vc = (MemberInfoViewController *)[segue destinationViewController];
        vc.memberInfo = sender;
    }else if([segue.identifier isEqualToString:@"MyDynamic"]) {
        ServerViewController *vc = (ServerViewController *)[segue destinationViewController];
        vc.viewType = [sender intValue]+2;
    }else if([segue.identifier isEqualToString:@"PayCenter"]) {
        IdentityChooseViewController *vc = (IdentityChooseViewController *)[segue destinationViewController];
        vc.viewType = 1;
        vc.userId = MEMBER.userId;
    }
}


@end
