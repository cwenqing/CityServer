//
//  MessageViewController.m
//  CityServer
//
//  Created by jwdlh on 2018/1/12.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import "MessageViewController.h"
#import "ChatViewController.h"
@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    self.title = @"消息";
    [self setExtraCellLineHidden:self.conversationListTableView];
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    
}
    
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    int totalUnreadCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
        [item pp_addBadgeWithNumber:totalUnreadCount];
    });
}

#pragma mark---隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
    
//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ChatVC" sender:model];
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
    if ([segue.identifier isEqualToString:@"ChatVC"]) {
        ChatViewController *conversationVC = (ChatViewController *)[segue destinationViewController];
        RCConversationModel *model = (RCConversationModel *)sender;
        conversationVC.conversationType = model.conversationType;
        conversationVC.targetId = model.targetId;
        conversationVC.title = model.conversationTitle;
    }
}


@end
