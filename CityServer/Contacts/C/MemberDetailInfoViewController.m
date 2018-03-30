//
//  MemberDetailInfoViewController.m
//  CityServer
//
//  Created by jwdlh on 2018/2/2.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "MemberDetailInfoViewController.h"
#import "ChatViewController.h"
#import "CardDetailViewController.h"
#import "ServerViewController.h"
#import "Dynamic.h"
@interface MemberDetailInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *memberDetailTableView;
    NSMutableArray *imgArray;;
}
@end

@implementation MemberDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详细资料";
    imgArray = [NSMutableArray array];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    
    
    [self createUI];
    [self getDynamic];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)createUI{
    memberDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth) style:UITableViewStylePlain];
    memberDetailTableView.backgroundColor = BACColor;
    memberDetailTableView.delegate = self;
    memberDetailTableView.dataSource = self;
    memberDetailTableView.separatorColor = BACColor;
    [self.view addSubview:memberDetailTableView];
    
//    headView = [[[NSBundle mainBundle]loadNibNamed:@"MemberCenterHeadView" owner:self options:nil]lastObject];
//    headView.frame = CGRectMake(0, 0, ScreenWidth, 180);
//    memberCenterTabelView.tableHeaderView = headView;
//    headView.delegate = self;
    UIView *tableFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 103)];
    tableFootView.backgroundColor = [UIColor clearColor];
    
    UIButton *cardButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 8, ScreenWidth-30, 40)];
    [cardButton setBackgroundColor:NavColor];
    [cardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cardButton setTitle:@"名片" forState:UIControlStateNormal];
    cardButton.layer.cornerRadius = 5;
    cardButton.layer.masksToBounds = YES;
    [tableFootView addSubview:cardButton];
    [cardButton addTarget:self action:@selector(card) forControlEvents:UIControlEventTouchUpInside];
    
    if (_contacts) {
        UIButton *chatButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 63, ScreenWidth-30, 40)];
        [chatButton setBackgroundColor:[UIColor whiteColor]];
        [chatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [chatButton setTitle:@"聊天" forState:UIControlStateNormal];
        chatButton.layer.cornerRadius = 5;
        chatButton.layer.masksToBounds = YES;
        [tableFootView addSubview:chatButton];
        [chatButton addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
    }
    
    memberDetailTableView.tableFooterView = tableFootView;
}

-(void)getDynamic{
    int page = 0;
    
    NSString *userId;
    
    if (_contacts) {
        userId = _contacts.userId;
    }else if (_recommend){
        userId = _recommend.userId;
    }else if (_fansFollow){
        userId = _fansFollow.userId;
    }
    NSDictionary*dic = @{
                         @"offset":@(page),
                         @"limit":@(10),
                          @"userId":userId,
                         @"dynamicType":@(1),
                         @"token":[MemberCofig shareInstance].token
                         };
    
    
    [CWNetWorkTool requestGetWithPath:USERDYNAMIC_URL andParameters:dic andSuccess:^(id obj) {
        if ([obj[@"status"] intValue] == 200) {
            for (NSDictionary *dic in obj[@"data"]) {
                Dynamic *dynamic = [[Dynamic alloc]initWithDictionary:dic];
                if (dynamic.dynamicPicPath.count > 0) {
                    for (DynamicPicPath *pic in dynamic.dynamicPicPath) {
                        if ([pic.fileType hasPrefix:@"image"]) {
                            [imgArray addObject:pic.filePath];
                        }
                    }
                }
            }

            [memberDetailTableView reloadData];
            
        }

    } Fail:^(id obj) {
        
    }];
}

- (void)card{
    [self performSegueWithIdentifier:@"Card" sender:nil];
}

- (void)chat{
    [self performSegueWithIdentifier:@"chatVC" sender:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 8;
            break;
        case 1:
            return 0;
            break;
        default:
            return 0;
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }else if (indexPath.section == 1 && indexPath.row == 1) {
            return 80;
    }else
        return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
            {
                UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 60, 60)];
                headImg.layer.cornerRadius = 5;
                headImg.layer.masksToBounds = YES;
                [cell addSubview:headImg];
                
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 15, ScreenWidth-105, 25)];
                nameLabel.font = FONT(15);
                nameLabel.textColor = RGBA(24, 24, 24, 1);
                [cell addSubview:nameLabel];
                
                UILabel *signLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 45, ScreenWidth-105, 25)];
                signLabel.font = FONT(12);
                signLabel.textColor = RGBA(129, 129, 129, 1);
                [cell addSubview:signLabel];
                
                if (_contacts) {
                    [headImg sd_setImageWithURL:IMAGE(_contacts.avatarPath) placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
                    nameLabel.text = _contacts.userName;
                    signLabel.text = _contacts.userSignature;
                }else if (_recommend){
                    [headImg sd_setImageWithURL:IMAGE(_recommend.avatarPath) placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
                    nameLabel.text = _recommend.userName;
                    signLabel.text = _recommend.userSignature;
                }else if (_fansFollow){
                    [headImg sd_setImageWithURL:IMAGE(_fansFollow.avatarPath) placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
                    nameLabel.text = _fansFollow.userName;
                    signLabel.text = _fansFollow.userSignature;
                }
                
            }
            break;
          case 1:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        UILabel *eareLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 60, 20)];
                        eareLabel.font = FONT(15);
                        eareLabel.textColor = RGBA(24, 24, 24, 1);
                        eareLabel.text = @"地区";
                        [cell addSubview:eareLabel];
                        
                        UILabel *eareDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, ScreenWidth-95, 20)];
                        eareDetailLabel.font = FONT(15);
                        eareDetailLabel.textColor = RGBA(24, 24, 24, 1);
                        
                        [cell addSubview:eareDetailLabel];
                        
                        if (_contacts) {
                            eareDetailLabel.text = [NSString stringWithFormat:@"%@ %@ %@",_contacts.province, _contacts.city, _contacts.district];
                        }else if (_recommend){
                            eareDetailLabel.text = [NSString stringWithFormat:@"%@ %@ %@",_recommend.province, _recommend.city, _recommend.district];
                        }else if (_fansFollow){
                            eareDetailLabel.text = [NSString stringWithFormat:@"%@ %@ %@",_fansFollow.province, _fansFollow.city, _fansFollow.district];
                        }
                    }
                        break;
                    case 1:
                    {
                        UILabel *dynamicLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, 65, 20)];
                        dynamicLabel.font = FONT(15);
                        dynamicLabel.textColor = RGBA(24, 24, 24, 1);
                        dynamicLabel.text = @"个人动态";
                        [cell addSubview:dynamicLabel];
                        
                        if (imgArray.count > 0) {
                            for (int i = 0; i < (imgArray.count >3 ? 3: imgArray.count); i++) {
                                UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(90+i*70, 10, 60, 60)];
                                [img sd_setImageWithURL:IMAGE(imgArray[i]) placeholderImage:[UIImage imageNamed:@"noimage"]];
                                img.contentMode = UIViewContentModeScaleAspectFill;
                                img.layer.masksToBounds = YES;
                                [cell addSubview:img];
                            }
                        }
                        
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                        break;
                    default:
                        break;
                }
            }
            break;
        default:
            break;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 1) {
        [self performSegueWithIdentifier:@"Server" sender:nil];
    }
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
    if ([segue.identifier isEqualToString:@"chatVC"]) {
        ChatViewController *conversationVC = (ChatViewController *)[segue destinationViewController];
        conversationVC.conversationType = ConversationType_PRIVATE;
        conversationVC.targetId = _contacts.rongyunId;
        conversationVC.title = _contacts.userName;
    }else if ([segue.identifier isEqualToString:@"Card"]){
        CardDetailViewController *vc = (CardDetailViewController *)[segue destinationViewController];
        
        if (_contacts) {
            vc.userId = _contacts.userId;
        }else if (_recommend){
            vc.userId = _recommend.userId;
        }else if (_fansFollow){
            vc.userId = _fansFollow.userId;
        }
    }else if([segue.identifier isEqualToString:@"Server"]) {
        ServerViewController *vc = (ServerViewController *)[segue destinationViewController];
        vc.viewType = 4;
        if (_contacts) {
            vc.userId = _contacts.userId;
            vc.userName = _contacts.userName;
        }else if (_recommend){
            vc.userName = _recommend.userName;
            vc.userId = _recommend.userId;
        }else if (_fansFollow){
            vc.userId = _fansFollow.userId;
            vc.userName = _fansFollow.userName;
        }
    }
}


@end
