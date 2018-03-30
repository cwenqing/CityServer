//
//  SearchDynamicViewController.m
//  CityServer
//
//  Created by jwdlh on 2018/1/11.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "SearchDynamicViewController.h"
#import "RecommendTableViewCell.h"
#import "MemberDetailInfoViewController.h"
@interface SearchDynamicViewController ()<UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource, AddAttentionDelegate>
{
    UISearchBar *searchBar;
    UIView *searchView;
    UITableView *tableView;
    NSMutableArray *searchHosArray;
    BOOL showResult;
    NSMutableArray *recommendArray;
    int page;
}
@end

@implementation SearchDynamicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    showResult = NO;
    recommendArray = [NSMutableArray array];
    searchHosArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"VIDEOSEARCHHOS"]];
    [self initUI];
    
}

-(void)initUI
{
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    searchBar.showsCancelButton = YES;
    [searchBar becomeFirstResponder];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorColor = RGBA(247, 247, 247, 1);
    [tableView registerNib:[UINib nibWithNibName:@"RecommendTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecommendTableViewCell"];
    
    searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    searchView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, ScreenWidth/2, 20)];
    titleLabel.text = @"最近搜索";
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [searchView addSubview:titleLabel];
    UIButton *clearButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-90, 5, 80, 20)];
    [clearButton setTitle:@"清空历史" forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [clearButton setTitleColor:NavColor forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearSearchHos) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:clearButton];
    
    tableView.tableHeaderView = searchView;
    
    [self.view addSubview:tableView];
    
    tableView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    
}

-(void)clearSearchHos{
    [searchHosArray removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:searchHosArray forKey:@"VIDEOSEARCHHOS"];
    [tableView reloadData];
}

- (void)searchServerUser{
    page = 0;
    [recommendArray removeAllObjects];
    NSString *searchKey;
    if (_searchType) {
        searchKey = @"targetName";
    }else{
        searchKey = @"keyword";
    }
    NSDictionary*dic = @{
                         searchKey:searchBar.text,
                         @"offset":@(page),
                         @"limit":@(10),
                         @"token":[MemberCofig shareInstance].token
                         };
    
    [CWNetWorkTool requestGetWithPath:_searchType ? RECOMMENDERS_URL:SEARCHSERVERUSER_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            for (NSDictionary *dic in obj[@"data"]) {
                Recommend *recommrnd = [[Recommend alloc]initWithDictionary:dic];
                [recommendArray addObject:recommrnd];
            }
            if ([obj[@"data"] count] < 10) {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            }else
                [tableView.mj_footer endRefreshing];
            
            [tableView reloadData];
            
            
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
        [tableView.mj_header endRefreshing];
    } Fail:^(id obj) {
        [tableView.mj_header endRefreshing];
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

- (void)searchMoreServerUser{
    NSString *searchKey;
    if (_searchType) {
        searchKey = @"targetName";
    }else{
        searchKey = @"keyword";
    }
    NSDictionary*dic = @{
                         searchKey:searchBar.text,
                         @"offset":@(page),
                         @"limit":@(10),
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestGetWithPath:_searchType ? RECOMMENDERS_URL:SEARCHSERVERUSER_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            for (NSDictionary *dic in obj[@"data"]) {
                Recommend *recommrnd = [[Recommend alloc]initWithDictionary:dic];
                [recommendArray addObject:recommrnd];
            }
            if ([obj[@"data"] count] < 10) {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            }else
                [tableView.mj_footer endRefreshing];
            [tableView reloadData];
            
            
        }else{
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
            [tableView.mj_footer endRefreshing];
        }
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
        [tableView.mj_footer endRefreshing];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (showResult) {
        return 104;
    }else
        return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (showResult) {
        return recommendArray.count;
    }else
        return searchHosArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (showResult) {
        RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTableViewCell"];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.recommend = recommendArray[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LiveSeacherCell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SeacherCell"];
        }
        cell.textLabel.text = searchHosArray[searchHosArray.count-1-indexPath.row];
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (showResult) {
        Recommend * model = recommendArray[indexPath.row];
        [self performSegueWithIdentifier:@"MemberDetail" sender:model];
    }else{
        searchBar.text = searchHosArray[searchHosArray.count-1-indexPath.row];
        [self searchBarSearchButtonClicked:searchBar];
    }
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    showResult = NO;
    tableView.tableHeaderView = searchView;
    [tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (![searchBar.text isEqualToString:@""]) {
        
        [self refresh];
        if (![searchHosArray containsObject:searchBar.text]) {
            [searchHosArray addObject:searchBar.text];
        }
        if (searchHosArray.count > 10) {
            [searchHosArray removeObjectAtIndex:0];
        }
        [[NSUserDefaults standardUserDefaults] setObject:searchHosArray forKey:@"VIDEOSEARCHHOS"];
        [searchBar resignFirstResponder];
        showResult = YES;
        tableView.tableHeaderView = nil;
        [tableView reloadData];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
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
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(searchServerUser)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    tableView.mj_header = header;
}

- (void)loadMore{
    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page+=10;
        [self searchMoreServerUser];
    }];
    tableView.mj_footer = foot;
    
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
        VC.recommend = (Recommend *)sender;
    }
}


@end
