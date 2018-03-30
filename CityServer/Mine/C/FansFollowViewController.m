//
//  FansFollowViewController.m
//  CityServer
//
//  Created by 陈文清 on 2018/1/1.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "FansFollowViewController.h"
#import "FansFollow.h"
#import "FansFollowTableViewCell.h"
#import "MemberDetailInfoViewController.h"
@interface FansFollowViewController ()<UITableViewDelegate, UITableViewDataSource, AddAttentionFansFollowDelegate>
{
    UITableView *dataTableView;
    NSMutableArray *dataArray;
    int page;
}
@end

@implementation FansFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    switch (_viewType) {
        case 0:
            self.title = @"关注";
            break;
        case 1:
            self.title = @"粉丝";
            break;
        default:
            break;
    }
    dataArray = [NSMutableArray array];
    [self createUI];
    [self refresh];
    [self loadMore];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)createUI{
    dataTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth) style:UITableViewStylePlain];
    dataTableView.backgroundColor = BACColor;
    dataTableView.delegate = self;
    dataTableView.dataSource = self;
    [self.view addSubview:dataTableView];
    [self setExtraCellLineHidden:dataTableView];
    [dataTableView registerNib:[UINib nibWithNibName:@"FansFollowTableViewCell" bundle:nil] forCellReuseIdentifier:@"FansFollowTableViewCell"];
}

- (void)getData{
    page = 0;
    [dataArray removeAllObjects];
    NSDictionary*dic = @{
                         @"offset":@(page),
                         @"limit":@(10),
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestGetWithPath:_viewType ? FANS_URL :FOLLOWS_UEL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            for (NSDictionary *dic in obj[@"data"]) {
                FansFollow *fansFollow = [[FansFollow alloc]initWithDictionary:dic];
                [dataArray addObject:fansFollow];
            }
            if ([obj[@"data"] count] < 10) {
                [dataTableView.mj_footer endRefreshingWithNoMoreData];
            }else
                [dataTableView.mj_footer endRefreshing];
            
            [dataTableView reloadData];
            
            
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
        [dataTableView.mj_header endRefreshing];
    } Fail:^(id obj) {
        [dataTableView.mj_header endRefreshing];
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

- (void)getMoreData{
    NSDictionary*dic = @{
                         @"offset":@(page),
                         @"limit":@(10),
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestGetWithPath:_viewType ? FANS_URL :FOLLOWS_UEL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            for (NSDictionary *dic in obj[@"data"]) {
                FansFollow *fansFollow = [[FansFollow alloc]initWithDictionary:dic];
                [dataArray addObject:fansFollow];
            }
            if ([obj[@"data"] count] < 10) {
                [dataTableView.mj_footer endRefreshingWithNoMoreData];
            }else
                [dataTableView.mj_footer endRefreshing];
            [dataTableView reloadData];
            
            
        }else{
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
            [dataTableView.mj_footer endRefreshing];
        }
    } Fail:^(id obj) {
        [dataTableView.mj_footer endRefreshing];
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

#pragma mark---隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FansFollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FansFollowTableViewCell"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FansFollow *fansFollow = dataArray[indexPath.row];
    [cell setFansFollow:fansFollow];
    cell.indexPath = indexPath;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FansFollow *fansFollow = dataArray[indexPath.row];
    [self performSegueWithIdentifier:@"MemberDetail" sender:fansFollow];
}

-(void)addAttentionWithIndexPath:(NSIndexPath *)indexPath{
    FansFollow *fansFollow = dataArray[indexPath.row];
    
    NSDictionary*dic = @{
                         @"followerId":fansFollow.userId,
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestPostWithPath:fansFollow.attentionStatus ? CANCELATTENTION_URL:ADDATTENTION_URL andParameters:dic andSuccess:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
        fansFollow.attentionStatus = !fansFollow.attentionStatus;
        RCUserInfo *_currentUserInfo =
        [[RCUserInfo alloc] initWithUserId:fansFollow.rongyunId name:fansFollow.userName portrait:fansFollow.avatarPath];
        [[RCIM sharedRCIM] refreshUserInfoCache:_currentUserInfo withUserId:fansFollow.rongyunId];
        [dataTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

#pragma mark UITableView + 下拉刷新 上拉加载更多
- (void)refresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    dataTableView.mj_header = header;
}

- (void)loadMore{
    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page+=10;
        [self getMoreData];
    }];
    dataTableView.mj_footer = foot;
    
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
    if ([segue.identifier isEqualToString:@"MemberDetail"]) {
        MemberDetailInfoViewController *VC = (MemberDetailInfoViewController *)[segue destinationViewController];
        VC.fansFollow = (FansFollow *)sender;
    }
}


@end
