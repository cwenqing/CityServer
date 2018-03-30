//
//  MyCardsViewController.m
//  CityServer
//
//  Created by jwdlh on 2018/2/2.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "MyCardsViewController.h"
#import "CardTableViewCell.h"
#import "Card.h"
#import "CardDetailViewController.h"
#import "EditCardViewController.h"
@interface MyCardsViewController ()<UITableViewDelegate, UITableViewDataSource,CardTableViewCellDelegate,MGSwipeTableCellDelegate>
{
    UITableView *mycardsTableView;
    NSMutableArray *mycardsArray;
}
@end

@implementation MyCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的名片";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    mycardsArray = [NSMutableArray array];
    [self createUI];
    
}

- (void)createUI{
    mycardsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth) style:UITableViewStylePlain];
    mycardsTableView.backgroundColor = BACColor;
    mycardsTableView.delegate = self;
    mycardsTableView.dataSource = self;
    mycardsTableView.separatorColor = [UIColor clearColor];
    [mycardsTableView registerNib:[UINib nibWithNibName:@"CardTableViewCell" bundle:nil] forCellReuseIdentifier:@"CardTableViewCell"];
    
    [self.view addSubview:mycardsTableView];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 12)];
    mycardsTableView.tableHeaderView = headView;
    
    UIView *tableFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
    tableFootView.backgroundColor = [UIColor clearColor];
    
    UIButton *cardButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, ScreenWidth-30, 40)];
    [cardButton setBackgroundColor:NavColor];
    [cardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cardButton setTitle:@"添加新名片" forState:UIControlStateNormal];
    [cardButton addTarget:self action:@selector(addCard) forControlEvents:UIControlEventTouchUpInside];
    cardButton.layer.cornerRadius = 5;
    cardButton.layer.masksToBounds = YES;
    [tableFootView addSubview:cardButton];
    
    mycardsTableView.tableFooterView = tableFootView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}

-(void)addCard{
    [self performSegueWithIdentifier:@"EditCard" sender:nil];
}

- (void)getCards{
    [mycardsArray removeAllObjects];
    NSDictionary*dic = @{
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestGetWithPath:MYCARDLIST_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            for (NSDictionary *dic in obj[@"data"]) {
                Card *card = [[Card alloc]initWithDictionary:dic];
                [mycardsArray addObject:card];
            }
            [mycardsTableView reloadData];         
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
        
        [mycardsTableView.mj_header endRefreshing];
    } Fail:^(id obj) {
        [mycardsTableView.mj_header endRefreshing];
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mycardsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardTableViewCell"];
    cell.rightSwipeSettings.transition = MGSwipeTransitionBorder;
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Card *card = mycardsArray[indexPath.row];
    if (card.defaultCard == 1) {
        cell.cardNameLabel.text = [NSString stringWithFormat:@"%@(默认名片)",card.cardTitle];
        cell.rightButtons = @[];
    }else{
        cell.cardNameLabel.text = card.cardTitle;
        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@" 删除 " backgroundColor:GMColor(@"#ff3a31")],[MGSwipeButton buttonWithTitle:@"设为默认" backgroundColor:GMColor(@"#c8c7cd")]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"CardDetail" sender:mycardsArray[indexPath.row]];
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion{
    switch (index) {
        case 0:
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                alertController.title = @"确定删除名片";
                UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                UIAlertAction *otherButton1 = [UIAlertAction actionWithTitle:@"确定"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                                         NSIndexPath *indexPath = [mycardsTableView indexPathForCell:(CardTableViewCell *)cell];
                                                                         Card *card = mycardsArray[indexPath.row];
                                                                         
                                                                         
                                                                         NSDictionary*dic = @{
                                                                                              @"token":[MemberCofig shareInstance].token,
                                                                                              @"cardId":card.cardId
                                                                                              };
                                                                         [CWNetWorkTool requestPostWithPath:DELETECARD_URL andParameters:dic andSuccess:^(id obj) {
                                                                             if ([obj[@"status"] intValue] == 200) {
                                                                                 [ProjectConfig mbRpogressHUDAlertWithText:@"删除成功" WithProgress:nil];
                                                                                 [self refresh];
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
            break;
        case 1:
            {
                NSIndexPath *indexPath = [mycardsTableView indexPathForCell:(CardTableViewCell *)cell];
                Card *card = mycardsArray[indexPath.row];

                NSDictionary*dic = @{
                                     @"token":[MemberCofig shareInstance].token,
                                     @"cardId":card.cardId
                                     };
                [CWNetWorkTool requestPostWithPath:MAINCARD_URL andParameters:dic andSuccess:^(id obj) {
                    if ([obj[@"status"] intValue] == 200) {
                        [ProjectConfig mbRpogressHUDAlertWithText:@"设置成功" WithProgress:nil];
                        [self refresh];
                    }else
                        [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
                    
                } Fail:^(id obj) {
                    [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
                }];
            }
            break;
        default:
            break;
    }
    
    
    return YES;
    
}

-(void)shareCardWithIndexPath:(NSIndexPath *)indexPath{
    Card *card = mycardsArray[indexPath.row];
    [ProjectConfig UMSocialWithImage:[UIImage imageNamed:@"矢量智能对象"] AndTitle:@"快来同城互通分享名片，快速了解周边行业达人，交换最有价值的商业信息！" AndContent:@"同城互通是一家从事以互联网信息业务为主的科技软件公司。从创立开始，本着“客户至上，质量为本”的原则， “以人才和技术为基础、创造最佳产品和服务”的经营理念。致力于为客户塑造个人形象，为客户提供服务。" AndWebpageUrl:[NSString stringWithFormat:@"%@&ts=%@",card.shareUrl,[self currentTimeStr]] AndCurrentViewController:self];
    
}

//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

-(void)editCardWithIndexPath:(NSIndexPath *)indexPath{
    Card *card = mycardsArray[indexPath.row];
    [self performSegueWithIdentifier:@"EditCard" sender:card];
}

#pragma mark UITableView + 下拉刷新 上拉加载更多
- (void)refresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCards)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    mycardsTableView.mj_header = header;
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
    if ([segue.identifier isEqualToString:@"CardDetail"]) {
        CardDetailViewController *vc = (CardDetailViewController *)[segue destinationViewController];
        vc.card = (Card *)sender;
    }else if ([segue.identifier isEqualToString:@"EditCard"]) {
        EditCardViewController *vc = (EditCardViewController *)[segue destinationViewController];
        vc.card = (Card *)sender;
    }
}


@end
