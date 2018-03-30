//
//  DynaimcDetailViewController.m
//  CityServer
//
//  Created by jwdlh on 2018/1/10.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "DynaimcDetailViewController.h"
#import "SDTimeLineCell.h"
#import "CommentTableViewCell.h"
#import "Comment.h"
#import "SearchDynamicViewController.h"
@interface DynaimcDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,SDTimeLineCellDelegate>
{
    UITableView *dynamicDetailTableView;
    UIView *commentView;
    UITextField *commentTF;
    NSMutableArray *commenttArray;
    int page;
}
@end

@implementation DynaimcDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"动态详情";
    commenttArray = [NSMutableArray array];
    [self registerForKeyboardNotifications];
    [self createUI];
    [self refresh];
    [self loadMore];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.delegate bringBackWithIndexPath:_indexPath andDynamic:_dynamic];
}

- (void)getComment{
    page = 0;
    [commenttArray removeAllObjects];
    NSDictionary*dic = @{
                         @"dynamicId":_dynamic.dynamicId,
                         @"offset":@(page),
                         @"limit":@(10),
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestGetWithPath:COMMENTLIST_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            for (NSDictionary *dic in obj[@"data"]) {
                Comment *comment = [[Comment alloc]initWithDictionary:dic];
                [commenttArray addObject:comment];
            }
            if ([obj[@"data"] count] < 10) {
                [dynamicDetailTableView.mj_footer endRefreshingWithNoMoreData];
            }else
                [dynamicDetailTableView.mj_footer endRefreshing];
            [dynamicDetailTableView reloadData];
            
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
        [dynamicDetailTableView.mj_header endRefreshing];
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
        [dynamicDetailTableView.mj_header endRefreshing];
    }];
}

- (void)getMoreComment{
    NSDictionary*dic = @{
                         @"dynamicId":_dynamic.dynamicId,
                         @"offset":@(page),
                         @"limit":@(10),
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestGetWithPath:COMMENTLIST_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            for (NSDictionary *dic in obj[@"data"]) {
                Comment *comment = [[Comment alloc]initWithDictionary:dic];
                [commenttArray addObject:comment];
            }
            if ([obj[@"data"] count] < 10) {
                [dynamicDetailTableView.mj_footer endRefreshingWithNoMoreData];
            }else
                [dynamicDetailTableView.mj_footer endRefreshing];
            [dynamicDetailTableView reloadData];
            
        }else{
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
            [dynamicDetailTableView.mj_footer endRefreshing];
        }
        [dynamicDetailTableView.mj_header endRefreshing];
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
        [dynamicDetailTableView.mj_footer endRefreshing];
    }];
}

- (void)createUI{
    dynamicDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth-40) style:UITableViewStylePlain];
    dynamicDetailTableView.backgroundColor = BACColor;
    dynamicDetailTableView.delegate = self;
    dynamicDetailTableView.dataSource = self;
    dynamicDetailTableView.separatorColor = [UIColor clearColor];
    
    [dynamicDetailTableView registerClass:[SDTimeLineCell class] forCellReuseIdentifier:@"SDTimeLineCell"];
    [dynamicDetailTableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"CommentTableViewCell"];
    [self.view addSubview:dynamicDetailTableView];
    
    commentView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeigth-40, ScreenWidth, 40)];
    commentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:commentView];
    
    commentTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 2, ScreenWidth-20, 35)];
    commentTF.font = FONT(15);
    commentTF.delegate = self;
    commentTF.placeholder = @"发布评论";
    commentTF.returnKeyType = UIReturnKeyDone;
    [commentView addSubview:commentTF];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return commenttArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40;
    }else
        return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UILabel *commentCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, ScreenWidth-14, 39)];
        commentCountLabel.textColor = RGBA(48, 48, 48, 1);
        commentCountLabel.font = FONT(13);
        commentCountLabel.text = [NSString stringWithFormat:@"最新评论(%ld)",_dynamic.commentCount];
        [headView addSubview:commentCountLabel];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
        line.backgroundColor = RGBA(245, 245, 245, 1);
        [headView addSubview:line];

        return headView;
    }else
        return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SDTimeLineCell"];
        cell.indexPath = indexPath;
        ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        cell.model = _dynamic;
        cell.delegate = self;
        return cell;
    }else{
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
        ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        cell.model = commenttArray[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
//    Dynamic * model = serverArray[indexPath.row];
//    [self performSegueWithIdentifier:@"dynamicDetail" sender:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    if (indexPath.section == 0) {
        return [dynamicDetailTableView cellHeightForIndexPath:indexPath model:_dynamic keyPath:@"model" cellClass:[SDTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
    }else{
        id model = commenttArray[indexPath.row];
        return [dynamicDetailTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CommentTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }
  
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (![textField.text isEqualToString:@""]) {
        NSDictionary*dic = @{
                             @"content":textField.text,
                             @"dynamicId":_dynamic.dynamicId,
                             @"token":[MemberCofig shareInstance].token
                             };
        [CWNetWorkTool requestPostWithPath:COMMENT_URL andParameters:dic andSuccess:^(id obj) {
            if ([obj[@"status"] intValue] == 200) {
                [ProjectConfig mbRpogressHUDAlertWithText:@"评论成功" WithProgress:nil];
                textField.text = @"";
                [self.view endEditing:YES];
                _dynamic.commentCount ++;
                [self refresh];
            }else
                [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
        } Fail:^(id obj) {
            [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
        }];
    }
    return YES;
}

- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    commentView.frame = CGRectMake(0, ScreenHeigth-40 - kbSize.height, ScreenWidth, 40);
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    commentView.frame = CGRectMake(0, ScreenHeigth-40, ScreenWidth, 40);
}

-(void)supportOrNotWithIndexPath:(NSIndexPath *)indexPath{
//    Dynamic * dynamic = dynamicArray[indexPath.row];
    NSDictionary*dic = @{
                         @"dynamicId":_dynamic.dynamicId,
                         @"token":[MemberCofig shareInstance].token
                         };
    BOOL isSup;
    if (_dynamic.supportStatus == 1) {
        isSup = YES;
    }else
        isSup = NO;
    
//    SDTimeLineCell *cell = (SDTimeLineCell *)[dynamicDetailTableView cellForItemAtIndexPath:indexPath];
    
    [CWNetWorkTool requestPostWithPath: isSup ? DYNAMICUNSUPPORT : DYNAMICSUPPORT andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            if (isSup) {
                [ProjectConfig mbRpogressHUDAlertWithText:@"取消点赞" WithProgress:nil];
                
                _dynamic.likeCount--;
                _dynamic.supportStatus = 2;
//                cell.supportButton.selected = NO;
//                [cell.supportButton setTitle:[NSString stringWithFormat:@"%ld",dynamic.likeCount] forState:UIControlStateNormal];
            }else{
                [ProjectConfig mbRpogressHUDAlertWithText:@"点赞成功" WithProgress:nil];
                _dynamic.likeCount++;
                _dynamic.supportStatus = 1;
//                cell.supportButton.selected = YES;
//                [cell.supportButton setTitle:[NSString stringWithFormat:@"%ld",dynamic.likeCount] forState:UIControlStateNormal];
            }
            
            [dynamicDetailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

#pragma mark UITableView + 下拉刷新 上拉加载更多
- (void)refresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getComment)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    dynamicDetailTableView.mj_header = header;
}

- (void)loadMore{
    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page+=10;
        [self getMoreComment];
    }];
    dynamicDetailTableView.mj_footer = foot;
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
