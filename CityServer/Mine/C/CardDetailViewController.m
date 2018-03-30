//
//  CardDetailViewController.m
//  CityServer
//
//  Created by jwdlh on 2018/2/2.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "CardDetailViewController.h"
#import "CardMemberInfoTableViewCell.h"
#import "CardInfoTableViewCell.h"
#import "CardCompanyInfoTableViewCell.h"
#import "CardMapTableViewCell.h"
#import "MyPoint.h"
#import "CardDetail.h"
#import "DynamicPicPath.h"
@interface CardDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *cardDetailTableView;
    CardDetail *cardDetail;
    NSMutableArray *picArray;
    int rowCount;
    
    UIImageView *navBarHairlineImageView;
}
@end

@implementation CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    titleImg.image = [UIImage imageNamed:@"tongchenghutong"];
    self.navigationItem.titleView = titleImg;
    self.view.backgroundColor = NavColor;
    
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    picArray = [NSMutableArray array];
    rowCount = 0;
    [self createUI];
    [self getCardDetail];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    navBarHairlineImageView.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
    navBarHairlineImageView.hidden = NO;
}





- (void)createUI{
    cardDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth-NavationBarHeigth) style:UITableViewStylePlain];
    cardDetailTableView.backgroundColor = BACColor;
    cardDetailTableView.delegate = self;
    cardDetailTableView.dataSource = self;
    cardDetailTableView.separatorColor = [UIColor clearColor];
    cardDetailTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nocard"
                                                            titleStr:@""
                                                           detailStr:@""];
    //2.关闭自动显隐（此步可封装进自定义类中，相关调用就可省去这步）
    cardDetailTableView.ly_emptyView.autoShowEmptyView = NO;
    [cardDetailTableView registerNib:[UINib nibWithNibName:@"CardMemberInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"CardMemberInfoTableViewCell"];
    [cardDetailTableView registerNib:[UINib nibWithNibName:@"CardInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"CardInfoTableViewCell"];
    [cardDetailTableView registerNib:[UINib nibWithNibName:@"CardCompanyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"CardCompanyInfoTableViewCell"];
    [cardDetailTableView registerNib:[UINib nibWithNibName:@"CardMapTableViewCell" bundle:nil] forCellReuseIdentifier:@"CardMapTableViewCell"];
    
    [self.view addSubview:cardDetailTableView];
    
//    UIView *tableFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
//    tableFootView.backgroundColor = [UIColor clearColor];
//    
//    UIButton *cardButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, ScreenWidth-30, 40)];
//    [cardButton setBackgroundColor:NavColor];
//    [cardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [cardButton setTitle:@"加关注" forState:UIControlStateNormal];
//    cardButton.layer.cornerRadius = 5;
//    cardButton.layer.masksToBounds = YES;
//    [tableFootView addSubview:cardButton];
//    
//    cardDetailTableView.tableFooterView = tableFootView;
}

- (void)getCardDetail{
    if (_card) {
        NSDictionary*dic = @{
                             @"cardId":_card.cardId,
                             @"token":[MemberCofig shareInstance].token
                             };
        [CWNetWorkTool requestGetWithPath:CARDDETAIL_URL andParameters:dic andSuccess:^(id obj) {
            if ([obj[@"status"] intValue] == 200) {
                cardDetail = [[CardDetail alloc]initWithDictionary:obj[@"data"]];
                NSData *stringData = [cardDetail.picPath dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *ary = [NSJSONSerialization JSONObjectWithData:stringData options:0 error:nil];
                for (NSDictionary *dic in ary) {
                    DynamicPicPath *filePath = [[DynamicPicPath alloc]initWithDictionary:dic];
                    [picArray addObject:filePath];
                }
                rowCount = 4+ (int)picArray.count;
                [cardDetailTableView reloadData];
            }else{
                rowCount = 0;
                [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
            }
        } Fail:^(id obj) {
            [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
        }];
    }else{
        NSDictionary*dic = @{
                             @"userId":_userId,
                             @"token":[MemberCofig shareInstance].token
                             };
        [CWNetWorkTool requestGetWithPath:CONTACTSCARD_URL andParameters:dic andSuccess:^(id obj) {
            if ([obj[@"status"] intValue] == 200) {
                cardDetail = [[CardDetail alloc]initWithDictionary:obj[@"data"]];
                NSData *stringData = [cardDetail.picPath dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *ary = [NSJSONSerialization JSONObjectWithData:stringData options:0 error:nil];
                for (NSDictionary *dic in ary) {
                    DynamicPicPath *filePath = [[DynamicPicPath alloc]initWithDictionary:dic];
                    [picArray addObject:filePath];
                }
                rowCount = 4+ (int)picArray.count;
                cardDetailTableView.backgroundColor = BACColor;
                [cardDetailTableView reloadData];
            }else{
                rowCount = 0;
//                [ProjectConfig mbRpogressHUDAlertWithText:obj[@"message"] WithProgress:nil];
                cardDetailTableView.backgroundColor = [UIColor whiteColor];
                [cardDetailTableView reloadData];
                [cardDetailTableView ly_showEmptyView];
            }
            
        } Fail:^(id obj) {
            [ProjectConfig mbRpogressHUDAlertWithText:@"网络错误" WithProgress:nil];
        }];
    }
    
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return rowCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 170;
    }else if (indexPath.row == 1) {
        return 200;
    }else if (indexPath.row == 2) {
        
        return 80;
    }else if (indexPath.row == 3+picArray.count) {
        
        return 50+ScreenWidth;
    }else{
        return ScreenWidth-30;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CardMemberInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardMemberInfoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cardDetail = cardDetail;
        return cell;
    }else if (indexPath.row == 1) {
        CardInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardInfoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cardDetail = cardDetail;
        return cell;
    }else if (indexPath.row == 2) {
        CardCompanyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardCompanyInfoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.companyDescLabel.text = cardDetail.companyDesc;
        return cell;
    }else if (indexPath.row == 3+picArray.count) {
        CardMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardMapTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //创建CLLocation 设置经纬度
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:[cardDetail.latitude floatValue] longitude:[cardDetail.longitude floatValue]];
        CLLocationCoordinate2D coord = [loc coordinate];
        //创建标题
        NSString *titile = [NSString stringWithFormat:@"%f,%f",coord.latitude,coord.longitude];
        MyPoint *myPoint = [[MyPoint alloc] initWithCoordinate:coord andTitle:titile];
        //添加标注
        [cell.cardMapView addAnnotation:myPoint];
        
        //放大到标注的位置
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
        [cell.cardMapView setRegion:region animated:YES];
        
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-30, ScreenWidth-30)];
        DynamicPicPath *pic = picArray[indexPath.row - 3];
        [imageView sd_setImageWithURL:IMAGE(pic.filePath)];
        [cell addSubview:imageView];
        return cell;
    }
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
