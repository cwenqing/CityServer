//
//  MyServerViewController.m
//  CityServer
//
//  Created by 陈文清 on 2018/1/16.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "MyServerViewController.h"
#import "MyServerTableViewCell.h"
#import "Dynamic.h"
@interface MyServerViewController ()<UITableViewDelegate, UITableViewDataSource,MyServerCellDelegate>
{
    UITableView *myServerTableView;
    NSMutableArray *myServerArray;
    int page;
}
@end

@implementation MyServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myServerArray = [NSMutableArray array];
    self.title = @"我发布的服务";
    [self createUI];
    [self refresh];
    [self loadMore];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)createUI{
    myServerTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth) style:UITableViewStylePlain];
    myServerTableView.backgroundColor = BACColor;
    myServerTableView.delegate = self;
    myServerTableView.dataSource = self;
    [myServerTableView registerNib:[UINib nibWithNibName:@"MyServerTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyServerTableViewCell"];
    [self.view addSubview:myServerTableView];
    [self setExtraCellLineHidden:myServerTableView];
}

- (void)getMyServer{
    page = 0;
    [myServerArray removeAllObjects];
    NSDictionary*dic = @{
                         @"offset":@(page),
                         @"limit":@(10),
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestGetWithPath:MYSERVER_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            for (NSDictionary *dic in obj[@"data"]) {
                Dynamic *dynamic = [[Dynamic alloc]initWithDictionary:dic];
                [myServerArray addObject:dynamic];
            }
            if ([obj[@"data"] count] < 10) {
                [myServerTableView.mj_footer endRefreshingWithNoMoreData];
            }else
                [myServerTableView.mj_footer endRefreshing];
            [myServerTableView reloadData];
            
            
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
        [myServerTableView.mj_header endRefreshing];
    } Fail:^(id obj) {
        [myServerTableView.mj_header endRefreshing];
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

- (void)getMoreMyServer{
    page = 0;
    [myServerArray removeAllObjects];
    NSDictionary*dic = @{
                         @"offset":@(page),
                         @"limit":@(10),
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestGetWithPath:MYSERVER_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            for (NSDictionary *dic in obj[@"data"]) {
                Dynamic *dynamic = [[Dynamic alloc]initWithDictionary:dic];
                [myServerArray addObject:dynamic];
            }
            if ([obj[@"data"] count] < 10) {
                [myServerTableView.mj_footer endRefreshingWithNoMoreData];
            }else
                [myServerTableView.mj_footer endRefreshing];
            [myServerTableView reloadData];
            
            
        }else{
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
            [myServerTableView.mj_footer endRefreshing];
        }
    } Fail:^(id obj) {
        [myServerTableView.mj_footer endRefreshing];
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

-(void)closeServerAtIndexPath:(NSIndexPath *)indexPath{
    Dynamic *dynamic = myServerArray[indexPath.row];
    NSDictionary*dic = @{
                         @"dynamicId":dynamic.dynamicId,
                         @"resolveStatus":@(1),
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestPostWithPath:SERVERRESOLVE_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            [ProjectConfig mbRpogressHUDAlertWithText:@"关闭成功" WithProgress:nil];
            dynamic.supportStatus = 1;
            [myServerTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

#pragma mark---隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return myServerArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyServerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyServerTableViewCell"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 给cell传递模型
    [cell setDynamic:myServerArray[indexPath.row]];
    cell.indexPath = indexPath;
    
    return cell;
}

#pragma mark UITableView + 下拉刷新 上拉加载更多
- (void)refresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getMyServer)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    myServerTableView.mj_header = header;
}

- (void)loadMore{
    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page+=10;
        [self getMoreMyServer];
    }];
    myServerTableView.mj_footer = foot;
    
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
