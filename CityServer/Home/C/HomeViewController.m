//
//  HomeViewController.m
//  CityServer
//
//  Created by jwdlh on 2017/12/19.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import "HomeViewController.h"
#import "JRWaterFallLayout.h"
#import "DynamicCollectionViewCell.h"
#import "HomeHeadView.h"
#import "Dynamic.h"
#import "ServerViewController.h"
#import "DynaimcDetailViewController.h"
#import "ReleaseViewController.h"
@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,JRWaterFallLayoutDelegate,SGPageTitleViewDelegate,DynamicCellDelegate,HomeHeadViewDelegate,DynamicDetailDelegate>
{
    UICollectionView *dynamicCollectionView;
    NSMutableArray *dynamicArray;
    int page;
    HomeHeadView *headView;
    SGPageTitleView *pageTitleView;
    int seletedPageIndex;
    
    NSTimer *timer;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    titleImg.image = [UIImage imageNamed:@"tongchenghutong"];
    self.navigationItem.titleView = titleImg;
    
    UIBarButtonItem *carame = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fabu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]   style:UIBarButtonItemStylePlain target:self action:@selector(didClickCarame)];
    
    self.navigationItem.rightBarButtonItem =carame;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                    style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    page = 0 ;
    dynamicArray = [NSMutableArray array];
    [self createUI];
    [self refresh];
    [self loadMore];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"定位服务未开启" message:@"请在手机设置中开启定位服务以查看同城动态" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *otherButton1 = [UIAlertAction actionWithTitle:@"去开启"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                                     [[UIApplication sharedApplication]openURL:settingURL];
                                                                     
                                                                 }];
            
            [alertController addAction:cancelButton];
            [alertController addAction:otherButton1];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            
            [timer invalidate];
            
            //反地理编码
            CLLocation *loca = [[CLLocation alloc]initWithLatitude:app.latitude longitude:app.longitude];
            CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
            [geoCoder reverseGeocodeLocation:loca completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                if (placemarks.count > 0) {
                    CLPlacemark *placeMark = placemarks[0];
                    
                    /*看需求定义一个全局变量来接收赋值*/
                    NSLog(@"----%@",placeMark.administrativeArea);
                    NSLog(@"%@",placeMark.locality);
                    NSLog(@"%@",placeMark.subLocality);
                    NSDictionary*dic = @{
                                         @"city":placeMark.locality,
                                         @"district":placeMark.subLocality,
                                         @"province":placeMark.administrativeArea,
                                         @"latitude":[NSString stringWithFormat:@"%f",app.latitude],
                                         @"longitude":[NSString stringWithFormat:@"%f",app.longitude],
                                         @"token":[MemberCofig shareInstance].token
                                         };
                    [CWNetWorkTool requestPostWithPath:UPDATESITR_URL andParameters:dic andSuccess:^(id obj) {
                        if ([obj[@"status"] intValue] == 200) {
                            
                        }
                    } Fail:^(id obj) {
                        
                    }];
                    
                }
            }];
            
            
        }
    }];
    [timer fire];
   
}

- (void)onAppDidEnterBackGround:(UIApplication*)app {
    [timer setFireDate:[NSDate distantFuture]];
}
- (void)onAppWillEnterForeground:(UIApplication*)app {
    [timer setFireDate:[NSDate date]];
}

- (void)getDynamics{
    page = 0;
    
    float latitude;
    float longitude;
    
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        latitude = [MEMBER.latitude floatValue];
        longitude = [MEMBER.longitude floatValue];
    }else{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        latitude = app.latitude;
        longitude = app.longitude;
    }
    
    NSDictionary*dic = @{
                         @"offset":@(page),
                         @"limit":@(10),
                         @"latitude":[NSString stringWithFormat:@"%f",latitude],
                         @"longitude":[NSString stringWithFormat:@"%f",longitude],
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestGetWithPath:seletedPageIndex ? FRIENDDYNAMIC_URL:CITYDYNAMIC_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            [dynamicArray removeAllObjects];
            for (NSDictionary *dic in obj[@"data"]) {
                Dynamic *dynamic = [[Dynamic alloc]initWithDictionary:dic];
                [dynamicArray addObject:dynamic];
            }
            if ([obj[@"data"] count] < 10) {
                [dynamicCollectionView.mj_footer endRefreshingWithNoMoreData];
            }else
                [dynamicCollectionView.mj_footer endRefreshing];
            [dynamicCollectionView reloadData];
            
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
        [dynamicCollectionView.mj_header endRefreshing];
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
        [dynamicCollectionView.mj_header endRefreshing];
    }];

    
}

- (void)getMoreDynamics{
    float latitude;
    float longitude;
    
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        latitude = [MEMBER.latitude floatValue];
        longitude = [MEMBER.longitude floatValue];
    }else{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        latitude = app.latitude;
        longitude = app.longitude;
    }
    
    NSDictionary*dic = @{
                         @"offset":@(page),
                         @"limit":@(10),
                         @"latitude":[NSString stringWithFormat:@"%f",latitude],
                         @"longitude":[NSString stringWithFormat:@"%f",longitude],
                         @"token":[MemberCofig shareInstance].token
                         };
    [CWNetWorkTool requestGetWithPath:seletedPageIndex ? FRIENDDYNAMIC_URL:CITYDYNAMIC_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            for (NSDictionary *dic in obj[@"data"]) {
                Dynamic *dynamic = [[Dynamic alloc]initWithDictionary:dic];
                [dynamicArray addObject:dynamic];
            }
            [dynamicCollectionView reloadData];
            if ([obj[@"data"] count] < 10) {
                [dynamicCollectionView.mj_footer endRefreshingWithNoMoreData];
            }else
                [dynamicCollectionView.mj_footer endRefreshing];
        }else{
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
            [dynamicCollectionView.mj_footer endRefreshing];
        }
        
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
        [dynamicCollectionView.mj_footer endRefreshing];
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)createUI{
    headView = [[[NSBundle mainBundle]loadNibNamed:@"HomeHeadView" owner:self options:nil]lastObject];
    headView.frame = CGRectMake(0, NavationBarHeigth, ScreenWidth, 130);
    headView.delegate = self;
    [self.view addSubview:headView];
    NSArray *list = @[@"同城动态",@"好友动态"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleColor = RGBA(113, 113, 113, 1);
    configure.titleSelectedColor = RGBA(18, 21, 31, 1);
    configure.indicatorColor = RGBA(18, 21, 31, 1);
    pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 90, ScreenWidth, 40) delegate:self titleNames:list configure:configure];
    pageTitleView.backgroundColor = [UIColor whiteColor];
    pageTitleView.isShowBottomSeparator = NO;
    [headView addSubview:pageTitleView];
    
    
    // 创建瀑布流layout
    JRWaterFallLayout *layout = [[JRWaterFallLayout alloc] init];
    // 设置代理
    layout.delegate = self;

    
    // 创建瀑布流view
    dynamicCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NavationBarHeigth+130, ScreenWidth, ScreenHeigth-NavationBarHeigth-130-TabBarHeight) collectionViewLayout:layout];
    // 设置数据源
    dynamicCollectionView.dataSource = self;
    dynamicCollectionView.delegate = self;
    dynamicCollectionView.backgroundColor = BACColor;
    
    [self.view addSubview:dynamicCollectionView];
    
    // 注册cell
    [dynamicCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DynamicCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"DynamicCollectionViewCell"];

}



#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dynamicArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    DynamicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DynamicCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    // 给cell传递模型
    [cell setDynamic:dynamicArray[indexPath.row]];
    // 返回cell
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Dynamic * model = dynamicArray[indexPath.row];
    NSDictionary *dic = @{@"model":model,@"index":indexPath};
    [self performSegueWithIdentifier:@"dynamicDetail" sender:dic];
}

#pragma mark - <JRWaterFallLayoutDelegate>
/**
 *  返回每个item的高度
 */
- (CGFloat)waterFallLayout:(JRWaterFallLayout *)waterFallLayout heightForItemAtIndex:(NSUInteger)index width:(CGFloat)width
{
    Dynamic *dynamic = dynamicArray[index];
    CGRect rect = [dynamic.dynamicContent boundingRectWithSize:CGSizeMake((ScreenWidth-12)/2-20, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(12)} context:nil];
    float heigth;
    if (rect.size.height > 60) {
        heigth = 80;
    }else
        heigth = rect.size.height;
    
    
    return 100+heigth+(ScreenWidth-12)/2;
}

- (CGFloat)columnMarginOfWaterFallLayout:(JRWaterFallLayout *)waterFallLayout
{
    return 4;
}

- (NSUInteger)columnCountOfWaterFallLayout:(JRWaterFallLayout *)waterFallLayout
{
    return 2;
}

- (CGFloat)rowMarginOfWaterFallLayout:(JRWaterFallLayout *)waterFallLayout
{
    return 4;
}

- (UIEdgeInsets)edgeInsetsOfWaterFallLayout:(JRWaterFallLayout *)waterFallLayout
{
    return UIEdgeInsetsMake(4, 4, 4, 4);
}

-(void)serverButtonClicked:(int)index{
    [self performSegueWithIdentifier:@"serverVC" sender:@(index)];
}

-(void)supportOrNotWithIndexPath:(NSIndexPath *)indexPath{
    Dynamic * dynamic = dynamicArray[indexPath.row];
    NSDictionary*dic = @{
                         @"dynamicId":dynamic.dynamicId,
                         @"token":[MemberCofig shareInstance].token
                         };
    BOOL isSup;
    if (dynamic.supportStatus == 1) {
        isSup = YES;
    }else
        isSup = NO;
    
    DynamicCollectionViewCell *cell = (DynamicCollectionViewCell *)[dynamicCollectionView cellForItemAtIndexPath:indexPath];
    
    [CWNetWorkTool requestPostWithPath: isSup ? DYNAMICUNSUPPORT : DYNAMICSUPPORT andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            if (isSup) {
                [ProjectConfig mbRpogressHUDAlertWithText:@"取消点赞" WithProgress:nil];
                
                dynamic.likeCount--;
                dynamic.supportStatus = 2;
                cell.supportButton.selected = NO;
                [cell.supportButton setTitle:[NSString stringWithFormat:@"%ld",dynamic.likeCount] forState:UIControlStateNormal];
            }else{
                [ProjectConfig mbRpogressHUDAlertWithText:@"点赞成功" WithProgress:nil];
                dynamic.likeCount++;
                dynamic.supportStatus = 1;
                cell.supportButton.selected = YES;
                [cell.supportButton setTitle:[NSString stringWithFormat:@"%ld",dynamic.likeCount] forState:UIControlStateNormal];
            }
            
            
        }else
            [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
    } Fail:^(id obj) {
        [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
    }];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex{
    seletedPageIndex = (int)selectedIndex;
    if (dynamicCollectionView.mj_header.state != MJRefreshStateRefreshing) {
        [self refresh];
    }
    
}

-(void)bringBackWithIndexPath:(NSIndexPath *)indexPath andDynamic:(Dynamic *)dynamic{
    [dynamicArray replaceObjectAtIndex:indexPath.row withObject:dynamic];
    [dynamicCollectionView reloadData];
}

#pragma mark UITableView + 下拉刷新 上拉加载更多
- (void)refresh
{
    [dynamicCollectionView.mj_header endRefreshing];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getDynamics)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    dynamicCollectionView.mj_header = header;
}

- (void)loadMore{
    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page+=10;
        [self getMoreDynamics];
    }];
    dynamicCollectionView.mj_footer = foot;
}

- (void)didClickCarame{
    [self performSegueWithIdentifier:@"releaseVC" sender:nil];
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
    if ([segue.identifier isEqualToString:@"serverVC"]) {
        ServerViewController *vc = (ServerViewController *)[segue destinationViewController];
        vc.viewType = [sender intValue];
    }else if ([segue.identifier isEqualToString:@"dynamicDetail"]) {
        DynaimcDetailViewController *vc = (DynaimcDetailViewController *)[segue destinationViewController];
        vc.delegate = self;
        NSDictionary *dic = (NSDictionary *)sender;
        vc.dynamic = dic[@"model"];
        vc.indexPath = dic[@"index"];
    }
    else if ([segue.identifier isEqualToString:@"releaseVC"]) {
        ReleaseViewController *vc = (ReleaseViewController *)[segue destinationViewController];
        vc.viewType = 0;
        vc.seletedPageIndex = seletedPageIndex;
    }
}


@end
