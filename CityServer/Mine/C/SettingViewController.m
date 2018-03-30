//
//  SettingViewController.m
//  CityServer
//
//  Created by 陈文清 on 2017/12/22.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate>
{
    UITableView *settingTableView;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = BACColor;
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)createUI{
    settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth) style:UITableViewStylePlain];
    settingTableView.backgroundColor = BACColor;
    settingTableView.delegate = self;
    settingTableView.dataSource = self;
    [self.view addSubview:settingTableView];
    [self setExtraCellLineHidden:settingTableView];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 16)];
    headView.backgroundColor = BACColor;
    settingTableView.tableHeaderView = headView;
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 58)];
    headView.backgroundColor = BACColor;
    UIButton *logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 18, ScreenWidth, 40)];
    [logoutButton setBackgroundColor:[UIColor whiteColor]];
    [logoutButton setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
    logoutButton.titleLabel.font = FONT(14);
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:logoutButton];
    settingTableView.tableFooterView = footView;
}

#pragma mark---隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = FONT(14);
    cell.textLabel.textColor = RGBA(50, 50, 50, 1);
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"修改密码";
            break;
        case 1:{
            cell.textLabel.text = @"版本更新";
            if ([[ProjectConfig GetValueForKey:@"hasNew"] isEqualToString:@"1"]) {
                cell.detailTextLabel.text = @"有新版本!";
            }else{
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
                NSLog(@"app_version:%@----app——build:%@",app_Version,app_build);
                cell.detailTextLabel.text = app_Version;
            }
            
        }
            break;
        case 2:{
            cell.textLabel.text = @"清空缓存";
            cell.detailTextLabel.text = [self getCacheSize];
        }
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"ChangePswd" sender:nil];
            break;
        case 1:{
            if ([[ProjectConfig GetValueForKey:@"hasNew"] isEqualToString:@"1"]) {
                [self updateMethod];
            }
            
        }
            break;
        case 2:{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"确定清空缓存" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
            break;
        default:
            break;
    }
}

- (void)updateMethod{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的App不是最新版本，请问是否更新" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:action];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // itms-apps://itunes.apple.com/cn/app/wang-yi-yun-yin-le-pao-bufm/id590338362?mt=8
        NSURL *url = [NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://tchutong.com/cityimg/app/manifest.plist"];
        [[UIApplication sharedApplication] openURL:url];
        
    }];
    
    [alertVC addAction:action1];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark - 计算缓存大小
- (NSString *)getCacheSize
{
    //定义变量存储总的缓存大小
    long long sumSize = 0;
    //01.获取当前图片缓存路径
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    //02.创建文件管理对象
    NSFileManager *filemanager = [NSFileManager defaultManager];
    //获取当前缓存路径下的所有子路径
    NSArray *subPaths = [filemanager subpathsOfDirectoryAtPath:cacheFilePath error:nil];
    //遍历所有子文件
    for (NSString *subPath in subPaths) {
        //1）.拼接完整路径
        NSString *filePath = [cacheFilePath stringByAppendingFormat:@"/%@",subPath];
        //2）.计算文件的大小
        long long fileSize = [[filemanager attributesOfItemAtPath:filePath error:nil]fileSize];
        //3）.加载到文件的大小
        sumSize += fileSize;
    }
    float size_m = sumSize/(1000*1000);
    
    return [NSString stringWithFormat:@"%.2fM",size_m];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        //        [YSXMessageHint showHintViewWithActivity:YES AndMessage:@"正在清理缓存..." yOffset:0 parentView:self.view];
        //        [[SDWebImageManager sharedManager].imageCache clearMemory];
        //        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
        //01......
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //02.....
        NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
        //03......
        [fileManager removeItemAtPath:cacheFilePath error:nil];
        //04刷新第一行单元格
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [settingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //05 ：04和05使用其一即可
        [settingTableView reloadData];
        
        
        [ProjectConfig mbRpogressHUDAlertWithText:@"清理缓存成功" WithProgress:nil];
    }
}

- (void)logout{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MemberCofig"];
    [[RCIM sharedRCIM] logout];
    UIStoryboard * destinationStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController * loginVC = [destinationStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    self.view.window.rootViewController =loginVC;
    
    [self.view.window makeKeyAndVisible];
    
    [self.view removeFromSuperview];
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
