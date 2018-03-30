//
//  ContactsViewController.m
//  CityServer
//
//  Created by jwdlh on 2017/12/22.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import "ContactsViewController.h"
#import "Contacts.h"
#import "pinyin.h"
#import "FansFollowTableViewCell.h"
#import "MemberDetailInfoViewController.h"
@interface ContactsViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    UISearchBar *contactsSearchBar;
    UITableView *contactsTableView;
    NSMutableArray *contactsArray;
    NSMutableArray *sortedArrForArrays;
    NSMutableArray *sectionHeadsKeys;
    
    UISearchController *searchController;
    NSMutableArray *results;
}
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通讯录";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = NavColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [UIApplication sharedApplication].statusBarStyle = UIBarStyleBlackOpaque;
    
    contactsArray = [NSMutableArray array];
    sortedArrForArrays = [NSMutableArray array];
    sectionHeadsKeys = [NSMutableArray array];
    results = [NSMutableArray array];
     [self createUI];
    [self getContacts];
}

- (void)createUI{
    if (contactsTableView) {
        [contactsTableView removeFromSuperview];
    }
    
    contactsTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    contactsTableView.backgroundColor = BACColor;
    contactsTableView.delegate = self;
    contactsTableView.dataSource = self;
    
    //修改索引颜色
    contactsTableView.sectionIndexBackgroundColor = [UIColor clearColor];//修改右边索引的背景色
    contactsTableView.sectionIndexColor = NavColor;//修改右边索引字体的颜色
    contactsTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];//修改右边索引点击时候的背景色
    
    [self.view addSubview:contactsTableView];
    [self setExtraCellLineHidden:contactsTableView];
    [contactsTableView registerNib:[UINib nibWithNibName:@"FansFollowTableViewCell" bundle:nil] forCellReuseIdentifier:@"FansFollowTableViewCell"];
    
    searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    // 设置结果更新代理
    searchController.searchResultsUpdater = self;
    // 因为在当前控制器展示结果, 所以不需要这个透明视图
    searchController.dimsBackgroundDuringPresentation = NO;
    // 是否自动隐藏导航
        searchController.hidesNavigationBarDuringPresentation = YES;
    // 将searchBar赋值给tableView的tableHeaderView
    
    self.definesPresentationContext = YES;

    contactsTableView.tableHeaderView = searchController.searchBar;
    searchController.searchBar.delegate = self;
}

- (void)getContacts{
    NSDictionary*dic = @{
                         @"offset":@(0),
                         @"limit":@(1000),
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestGetWithPath:CONTACTS_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            for (NSDictionary *dic in obj[@"data"]) {
                Contacts *contacts = [[Contacts alloc]initWithDictionary:dic];
                [contactsArray addObject:contacts];
                RCUserInfo *_currentUserInfo =
                [[RCUserInfo alloc] initWithUserId:contacts.rongyunId name:contacts.userName portrait:contacts.avatarPath];
                [[RCIM sharedRCIM] refreshUserInfoCache:_currentUserInfo withUserId:contacts.rongyunId];
            }
            sortedArrForArrays = [self getChineseStringArr:contactsArray];
            [contactsTableView reloadData];
        }else
        [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
        
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        Contacts *contacts=arrToSort[i];
        
        if(contacts.userName==nil){
            contacts.userName=@"";
        }
        
        if(![contacts.userName isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < contacts.userName.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([contacts.userName characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            contacts.pinYin = pinYinResult;
        } else {
            contacts.pinYin = @"";
        }
        [chineseStringsArray addObject:contacts];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        Contacts *contacts = (Contacts *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:contacts.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        NSLog(@"%@",sr);        //sr containing here the first character of each string
        if(![sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [NSMutableArray array];
            checkValueAtIndex = NO;
        }
        if([sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
        [sectionHeadsKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:@"!"]) {
                [sectionHeadsKeys replaceObjectAtIndex:idx withObject:@"#"];
            }
        }];
    }
    return arrayForArrays;
}




#pragma mark---隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (searchController.active) {
        
        return results.count ;
    }
    NSMutableArray * ary = [sortedArrForArrays objectAtIndex:section];
    return ary.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (searchController.active) {
        
        return 1;
    }
    return [sortedArrForArrays count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (searchController.active) {
        
        return nil;
    }
    return [sectionHeadsKeys objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (searchController.active) {
        
        return nil;
    }
    return sectionHeadsKeys;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FansFollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FansFollowTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.attentionButton.hidden = YES;
    
    if (searchController.active ) {
        
        Contacts *contacts = (Contacts *) [results objectAtIndex:indexPath.row];
        [cell setContacts:contacts];
    } else {
        
        NSArray *arr = [sortedArrForArrays objectAtIndex:indexPath.section];
        Contacts *contacts = (Contacts *) [arr objectAtIndex:indexPath.row];
        [cell setContacts:contacts];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self searchBarCancelButtonClicked:searchController.searchBar];
    if (searchController.active ) {
        
        Contacts *contacts = (Contacts *) [results objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"MemberDetailInfo" sender:contacts];
    } else {
        
        NSArray *arr = [sortedArrForArrays objectAtIndex:indexPath.section];
        Contacts *contacts = (Contacts *) [arr objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"MemberDetailInfo" sender:contacts];
    }
    
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *inputStr = searchController.searchBar.text ;
    if (results!=nil) {
        [results removeAllObjects];
    }
//    for (NSString *str in self.datas) {
//
//        if ([str.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
//
//            [self.results addObject:str];
//        }
//    }
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userName CONTAINS '%@'", inputStr]];
    results = [[contactsArray filteredArrayUsingPredicate:pred2] mutableCopy];
    
    [contactsTableView reloadData];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    searchController.active = NO;
    contactsTableView.contentInset = UIEdgeInsetsMake(LL_iPhoneX ? 0 : 20, 0, TabBarHeight, 0);
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
    if ([segue.identifier isEqualToString:@"MemberDetailInfo"]) {
        MemberDetailInfoViewController *VC = (MemberDetailInfoViewController *)[segue destinationViewController];
        Contacts *contacts = (Contacts *)sender;
        VC.contacts = contacts;
    }
}


@end
