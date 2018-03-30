//
//  RecommendViewController.m
//  CityServer
//
//  Created by jwdlh on 2017/12/22.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import "RecommendViewController.h"
#import "SearchDynamicViewController.h"
#import "MemberDetailInfoViewController.h"
#import "RecommendTableViewCell.h"
#import "Recommend.h"
@interface RecommendViewController ()<UITableViewDelegate, UITableViewDataSource, AddAttentionDelegate>
{
    UITableView *recommendTableView;
    NSMutableArray *recommendArray;
    int page;
}
@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"推荐用户";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    recommendArray = [NSMutableArray array];
    [self createUI];
    [self refresh];
    [self loadMore];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)createUI{
    recommendTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth) style:UITableViewStylePlain];
    recommendTableView.backgroundColor = BACColor;
    recommendTableView.delegate = self;
    recommendTableView.dataSource = self;
    recommendTableView.separatorColor = [UIColor clearColor];
    [recommendTableView registerNib:[UINib nibWithNibName:@"RecommendTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecommendTableViewCell"];
    [self.view addSubview:recommendTableView];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchRecommend)];
    [searchButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = searchButton;
}

- (void)searchRecommend{
    [self performSegueWithIdentifier:@"Search" sender:nil];
}

- (void)getRecommenders{
    page = 0;
    NSDictionary*dic = @{
                         @"offset":@(page),
                         @"limit":@(10),
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestGetWithPath:RECOMMENDERS_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            [recommendArray removeAllObjects];
            for (NSDictionary *dic in obj[@"data"]) {
                Recommend *recommrnd = [[Recommend alloc]initWithDictionary:dic];
                [recommendArray addObject:recommrnd];
            }
            if ([obj[@"data"] count] < 10) {
                [recommendTableView.mj_footer endRefreshingWithNoMoreData];
            }else
                [recommendTableView.mj_footer endRefreshing];
            
            [recommendTableView reloadData];

            
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
        [recommendTableView.mj_header endRefreshing];
    } Fail:^(id obj) {
        [recommendTableView.mj_header endRefreshing];
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

- (void)getMoreRecommenders{
    NSDictionary*dic = @{
                         @"offset":@(page),
                         @"limit":@(10),
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestGetWithPath:RECOMMENDERS_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            for (NSDictionary *dic in obj[@"data"]) {
                Recommend *recommrnd = [[Recommend alloc]initWithDictionary:dic];
                [recommendArray addObject:recommrnd];
            }
            if ([obj[@"data"] count] < 10) {
                [recommendTableView.mj_footer endRefreshingWithNoMoreData];
            }else
                [recommendTableView.mj_footer endRefreshing];
            [recommendTableView reloadData];
            
            
        }else{
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
            [recommendTableView.mj_footer endRefreshing];
        }
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
        [recommendTableView.mj_footer endRefreshing];
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return recommendArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTableViewCell"];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.recommend = recommendArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Recommend * model = recommendArray[indexPath.row];
    [self performSegueWithIdentifier:@"MemberDetail" sender:model];
}

-(void)addAttentionWithIndexPath:(NSIndexPath *)indexPath{
    Recommend *recommend = recommendArray[indexPath.row];
    NSDictionary*dic = @{
                         @"followerId":recommend.userId,
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestPostWithPath:recommend.attentionStatus ? CANCELATTENTION_URL:ADDATTENTION_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            recommend.attentionStatus = !recommend.attentionStatus;
            RCUserInfo *_currentUserInfo =
            [[RCUserInfo alloc] initWithUserId:recommend.rongyunId name:recommend.userName portrait:recommend.avatarPath];
            [[RCIM sharedRCIM] refreshUserInfoCache:_currentUserInfo withUserId:recommend.rongyunId];
            [recommendTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
        
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}


#pragma mark UITableView + 下拉刷新 上拉加载更多
- (void)refresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRecommenders)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    recommendTableView.mj_header = header;
}

- (void)loadMore{
    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page+=10;
        [self getMoreRecommenders];
    }];
    recommendTableView.mj_footer = foot;
    
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
    if ([segue.identifier isEqualToString:@"Search"]) {
        SearchDynamicViewController *VC = (SearchDynamicViewController *)[segue destinationViewController];
        VC.searchType = 1;
    }else if ([segue.identifier isEqualToString:@"MemberDetail"]) {
        MemberDetailInfoViewController *VC = (MemberDetailInfoViewController *)[segue destinationViewController];
        VC.recommend = (Recommend *)sender;
    }
}


@end
