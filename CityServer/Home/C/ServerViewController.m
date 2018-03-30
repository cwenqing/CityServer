//
//  ServerViewController.m
//  CityServer
//
//  Created by jwdlh on 2018/1/9.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "ServerViewController.h"
#import "SDTimeLineCell.h"
#import "UIView+Utils.h"
#import "DynaimcDetailViewController.h"
#import "ReleaseViewController.h"
@interface ServerViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SDTimeLineCellDelegate,DynamicDetailDelegate>
{
    UITableView *serverTableView;
    NSMutableArray *serverArray;
    int page;
}
@end

@implementation ServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    
    serverArray = [NSMutableArray array];
    [self createUI];
    [self refresh];
    [self loadMore];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)getServers{
    page = 0;
    [serverArray removeAllObjects];
    
    NSDictionary*dic;
    if (_viewType == 4) {
        dic = @{
                @"offset":@(page),
                @"limit":@(10),
                @"userId":_userId,
                @"dynamicType":@(1),
                @"token":[MemberCofig shareInstance].token
                };
    }else{
        dic = @{
                @"offset":@(page),
                @"limit":@(10),
                @"token":[MemberCofig shareInstance].token
                };
    }
    
    
    NSString *url;
    switch (_viewType) {
        case 0:
            url = SAMESERVER_URL;
            break;
        case 1:
            url = WEALSERVER_URL;
            break;
        case 2:
            url = MYDYNAMIC_URL;
            break;
        case 3:
            url = MYCOMMONWEAL_URL;
            break;
        case 4:
            url = USERDYNAMIC_URL;
            break;
        default:
            break;
    }
    
    [CWNetWorkTool requestGetWithPath:url andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            for (NSDictionary *dic in obj[@"data"]) {
                Dynamic *dynamic = [[Dynamic alloc]initWithDictionary:dic];
                [serverArray addObject:dynamic];
            }
            if ([obj[@"data"] count] < 10) {
                [serverTableView.mj_footer endRefreshingWithNoMoreData];
            }else
                [serverTableView.mj_footer endRefreshing];
            [serverTableView reloadData];
            
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
        [serverTableView.mj_header endRefreshing];
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
        [serverTableView.mj_header endRefreshing];
    }];
}

-(void)getMoreServers{
    NSDictionary*dic;
    if (_viewType == 4) {
        dic = @{
                @"offset":@(page),
                @"limit":@(10),
                @"userId":_userId,
                @"dynamicType":@(1),
                @"token":[MemberCofig shareInstance].token
                };
    }else{
        dic = @{
                @"offset":@(page),
                @"limit":@(10),
                @"token":[MemberCofig shareInstance].token
                };
    }
    NSString *url;
    switch (_viewType) {
        case 0:
            url = SAMESERVER_URL;
            break;
        case 1:
            url = WEALSERVER_URL;
            break;
        case 2:
            url = MYDYNAMIC_URL;
            break;
        case 3:
            url = MYCOMMONWEAL_URL;
            break;
        case 4:
            url = USERDYNAMIC_URL;
            break;
        default:
            break;
    }
    [CWNetWorkTool requestGetWithPath:url andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            for (NSDictionary *dic in obj[@"data"]) {
                Dynamic *dynamic = [[Dynamic alloc]initWithDictionary:dic];
                [serverArray addObject:dynamic];
            }
            if ([obj[@"data"] count] < 10) {
                [serverTableView.mj_footer endRefreshingWithNoMoreData];
            }else
                [serverTableView.mj_footer endRefreshing];
            [serverTableView reloadData];
            
        }else{
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
            [serverTableView.mj_footer endRefreshing];
        }
        [serverTableView.mj_header endRefreshing];
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
        [serverTableView.mj_footer endRefreshing];
    }];
}

-(void)releaseServer{
    [self performSegueWithIdentifier:@"releaseVC" sender:nil];
}

-(void)createUI{
    
    switch (_viewType) {
        case 0:
        {
            UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
            searchButton.frame = CGRectMake(0, 0, ScreenWidth-140, 30);
            [searchButton setBackgroundColor:[UIColor colorWithWhite:1 alpha:.5]];
            [searchButton setTitle:@" 搜索你想要的服务" forState:UIControlStateNormal];
            searchButton.titleLabel.font = FONT(12);
            [searchButton setImage:[UIImage imageNamed:@"sousuo"] forState:UIControlStateNormal];
            [searchButton addTarget:self action:@selector(searchServer) forControlEvents:UIControlEventTouchUpInside];
            searchButton.layer.cornerRadius = 3;
            searchButton.layer.masksToBounds = YES;
            self.navigationItem.titleView = searchButton;
            
            UIBarButtonItem *releaseButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(releaseServer)];
            self.navigationItem.rightBarButtonItem = releaseButton;
        }
            break;
        case 1:
        {
            self.title = @"公益服务";
            
            UIBarButtonItem *releaseButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(releaseServer)];
            self.navigationItem.rightBarButtonItem = releaseButton;
        }
            break;
        case 2:
        {
            self.title = @"我的动态";
        }
            break;
        case 3:
        {
            self.title = @"我的公益";
        }
            break;
        case 4:
        {
            self.title = [NSString stringWithFormat:@"%@的动态",_userName];
        }
            break;
        default:
            break;
    }
    
    
    

    serverTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth) style:UITableViewStylePlain];
    serverTableView.backgroundColor = BACColor;
    serverTableView.delegate = self;
    serverTableView.dataSource = self;
    serverTableView.separatorColor = [UIColor clearColor];
    
    [serverTableView registerClass:[SDTimeLineCell class] forCellReuseIdentifier:@"SDTimeLineCell"];
    [self.view addSubview:serverTableView];
}

- (void)searchServer{
    [self performSegueWithIdentifier:@"SearchDynamic" sender:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return serverArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SDTimeLineCell"];
    if (_viewType == 2 || _viewType == 3) {
        cell.deleteButton.hidden = NO;
    }
    cell.indexPath = indexPath;
    
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    ///////////////////////////////////////////////////////////////////////
    
    cell.model = serverArray[indexPath.row];
    cell.delegate= self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    Dynamic * model = serverArray[indexPath.row];
    NSDictionary *dic = @{@"model":model,@"index":indexPath};
    [self performSegueWithIdentifier:@"dynamicDetail" sender:dic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = serverArray[indexPath.row];
    return [serverTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SDTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

-(void)supportOrNotWithIndexPath:(NSIndexPath *)indexPath{
    Dynamic * dynamic = serverArray[indexPath.row];
    NSDictionary*dic = @{
                         @"dynamicId":dynamic.dynamicId,
                         @"token":[MemberCofig shareInstance].token
                         };
    BOOL isSup;
    if (dynamic.supportStatus == 1) {
        isSup = YES;
    }else
        isSup = NO;
    
//    DynamicCollectionViewCell *cell = (DynamicCollectionViewCell *)[dynamicCollectionView cellForItemAtIndexPath:indexPath];
    
    [CWNetWorkTool requestPostWithPath: isSup ? DYNAMICUNSUPPORT : DYNAMICSUPPORT andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            if (isSup) {
                [ProjectConfig mbRpogressHUDAlertWithText:@"取消点赞" WithProgress:nil];
                
                dynamic.likeCount--;
                dynamic.supportStatus = 2;
                
            }else{
                [ProjectConfig mbRpogressHUDAlertWithText:@"点赞成功" WithProgress:nil];
                dynamic.likeCount++;
                dynamic.supportStatus = 1;
                
            }
            
            [serverTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

-(void)deleteDynamicWithIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.title = @"确定删除";
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *otherButton1 = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             Dynamic * dynamic = serverArray[indexPath.row];
                                                             
                                                             int a;
                                                             switch (_viewType) {
                                                                 case 2:
                                                                     a = 1;
                                                                     break;
                                                                 case 3:
                                                                     a = 3;
                                                                     break;
                                                                 default:
                                                                     a = 0;
                                                                     break;
                                                             }
                                                             
                                                             NSDictionary*dic = @{
                                                                                  @"token":[MemberCofig shareInstance].token,
                                                                                  @"dynamicId":dynamic.dynamicId,
                                                                                  @"dynamicType":@(a)
                                                                                  };
                                                             [CWNetWorkTool requestPostWithPath:DELETEDYNAMIC_URL andParameters:dic andSuccess:^(id obj) {
                                                                 if ([obj[@"status"] intValue] == 200) {
                                                                     [ProjectConfig mbRpogressHUDAlertWithText:@"删除成功" WithProgress:nil];
                                                                     [serverArray removeObjectAtIndex:indexPath.row];
                                                                     [serverTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                 }else
                                                                     [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
                                                                 
                                                             } Fail:^(id obj) {
                                                                 [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
                                                             }];
                                                             
                                                         }];
    
    [alertController addAction:cancelButton];
    [alertController addAction:otherButton1];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//    [searchBar setShowsCancelButton:YES animated:YES];
}

//-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    [self.view endEditing:YES];
//    searchBar.text = @"";
//    [serverTableView reloadData];
//    [searchBar setShowsCancelButton:NO animated:YES];
//}

-(void)bringBackWithIndexPath:(NSIndexPath *)indexPath andDynamic:(Dynamic *)dynamic{
    [serverArray replaceObjectAtIndex:indexPath.row withObject:dynamic];
    [serverTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark UITableView + 下拉刷新 上拉加载更多
- (void)refresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getServers)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    serverTableView.mj_header = header;
}

- (void)loadMore{
    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page+=10;
        [self getMoreServers];
    }];
    serverTableView.mj_footer = foot;
    
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
    if ([segue.identifier isEqualToString:@"dynamicDetail"]) {
        DynaimcDetailViewController *vc = (DynaimcDetailViewController *)[segue destinationViewController];
        NSDictionary *dic = (NSDictionary *)sender;
        vc.dynamic = dic[@"model"];
        vc.indexPath = dic[@"index"];
        vc.delegate = self;
    }else if ([segue.identifier isEqualToString:@"releaseVC"]) {
        ReleaseViewController *vc = (ReleaseViewController *)[segue destinationViewController];
        switch (_viewType) {
            case 0:
                vc.viewType = 1;
                break;
            case 1:
                vc.viewType = 2;
                break;
            default:
                break;
        }
        
    }
}

@end
