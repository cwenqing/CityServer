//
//  IdentityChooseViewController.m
//  CityServer
//
//  Created by jwdlh on 2017/12/19.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import "IdentityChooseViewController.h"
#import "ChoosePayTypeViewController.h"
@interface IdentityChooseViewController ()
{
    __weak IBOutlet UIButton *enterpriseUsersButton;
    
    __weak IBOutlet UIButton *yearPayButton;
    
//    __weak IBOutlet UIButton *monthPayButton;
    
    __weak IBOutlet UIView *ordinaryUserView;
    __weak IBOutlet UIButton *ordinaryUserButton;
    
    __weak IBOutlet UILabel *yearPriceLabel;
    
//    __weak IBOutlet UILabel *monthPriceLabel;
    
    __weak IBOutlet UIView *srueView;
    __weak IBOutlet UILabel *totalPriceLabel;
    
    __weak IBOutlet UIButton *srueButton;
    
}
@end

@implementation IdentityChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_viewType) {
        self.title = @"充值中心";
        
    }else{
        self.title = @"注册身份选择";
        self.navigationController.navigationBar.barTintColor = RGBA(247, 246, 246, 1);
        [UIApplication sharedApplication].statusBarStyle = UIBarStyleDefault;
        self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    }
    
    
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    
    
    
    [self initUI];
//    [self getMmberType];

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)getMmberType{
    [CWNetWorkTool requestGetWithPath:MEMBERTYPE_RUL andParameters:nil andSuccess:^(id obj) {
        if ([obj[@"data"][@"memberType"] isEqualToString:@"2"]) {
            ordinaryUserView.hidden = NO;
        }else{
            ordinaryUserView.hidden = YES;
        }
    } Fail:^(id obj) {
        
    }];
}

- (void)initUI{
    ordinaryUserView.hidden = YES;
    
    yearPayButton.layer.cornerRadius = 5;
    yearPayButton.layer.borderWidth = 1;
    yearPayButton.layer.masksToBounds = YES;
    enterpriseUsersButton.selected = YES;
    yearPayButton.selected = YES;
    if (yearPayButton.selected) {
        [yearPayButton setBackgroundColor:RGBA(56, 107, 248, .2)];
        yearPayButton.layer.borderColor = NavColor.CGColor;
        yearPayButton.layer.masksToBounds = YES;
    }
    
    NSMutableAttributedString *yearStr = [[NSMutableAttributedString alloc] initWithString:@"￥120"];
    [yearStr addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:20]
                      range:NSMakeRange(1, 3)];
    yearPriceLabel.attributedText = yearStr;

    
    NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] initWithString:@" 总价￥120"];
    [totalStr addAttribute:NSForegroundColorAttributeName
                     value:RGBA(47, 47, 48, 1)
                     range:NSMakeRange(1, 2)];
    [totalStr addAttribute:NSFontAttributeName
                     value:[UIFont systemFontOfSize:20]
                     range:NSMakeRange(4, 3)];
    [totalStr addAttribute:NSFontAttributeName
                     value:[UIFont systemFontOfSize:12]
                     range:NSMakeRange(3, 1)];
    totalPriceLabel.attributedText = totalStr;
    
    ordinaryUserView.hidden = YES;
}


- (IBAction)enterpriseUsersButtonClicked:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        ordinaryUserButton.selected = NO;
        yearPayButton.selected = YES;
        [yearPayButton setBackgroundColor:RGBA(56, 107, 248, .2)];
        yearPayButton.layer.borderColor = NavColor.CGColor;
        
        NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] initWithString:@"总价￥120"];
        [totalStr addAttribute:NSForegroundColorAttributeName
                         value:RGBA(47, 47, 48, 1)
                         range:NSMakeRange(0, 2)];
        [totalStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:20]
                         range:NSMakeRange(3, 3)];
        [totalStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:12]
                         range:NSMakeRange(2, 1)];
        totalPriceLabel.attributedText = totalStr;
        
        totalPriceLabel.hidden = NO;
        srueButton.frame = CGRectMake(ScreenWidth-162, 0, 162, 40);
        [srueButton setTitle:@"确认支付" forState:UIControlStateNormal];
    }
}

- (IBAction)yearPayButtonClicked:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        [sender setBackgroundColor:RGBA(56, 107, 248, .2)];
        sender.layer.borderColor = NavColor.CGColor;
        
        enterpriseUsersButton.selected = YES;
        ordinaryUserButton.selected = NO;
//        monthPayButton.selected = NO;
//        [monthPayButton setBackgroundColor:[UIColor clearColor]];
//        monthPayButton.layer.borderColor = RGBA(240, 240, 240, 1).CGColor;
        
        NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] initWithString:@"总价￥120"];
        [totalStr addAttribute:NSForegroundColorAttributeName
                         value:RGBA(47, 47, 48, 1)
                         range:NSMakeRange(0, 2)];
        [totalStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:20]
                         range:NSMakeRange(3, 3)];
        [totalStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:12]
                         range:NSMakeRange(2, 1)];
        totalPriceLabel.attributedText = totalStr;
        
        totalPriceLabel.hidden = NO;
        srueButton.frame = CGRectMake(ScreenWidth-162, 0, 162, 40);
        [srueButton setTitle:@"确认支付" forState:UIControlStateNormal];
    }
}

- (IBAction)monthPayButtonClicked:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        [sender setBackgroundColor:RGBA(56, 107, 248, .2)];
        sender.layer.borderColor = NavColor.CGColor;
        
        enterpriseUsersButton.selected = YES;
        ordinaryUserButton.selected = NO;
        yearPayButton.selected = NO;
        [yearPayButton setBackgroundColor:[UIColor clearColor]];
        yearPayButton.layer.borderColor = RGBA(240, 240, 240, 1).CGColor;
        
        NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] initWithString:@"总价￥10"];
        [totalStr addAttribute:NSForegroundColorAttributeName
                         value:RGBA(47, 47, 48, 1)
                         range:NSMakeRange(0, 2)];
        [totalStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:20]
                         range:NSMakeRange(3, 2)];
        [totalStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:12]
                         range:NSMakeRange(2, 1)];
        totalPriceLabel.attributedText = totalStr;
        
        totalPriceLabel.hidden = NO;
        srueButton.frame = CGRectMake(ScreenWidth-162, 0, 162, 40);
        [srueButton setTitle:@"确认支付" forState:UIControlStateNormal];
    }
}

- (IBAction)ordinaryUserButtonClicked:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        enterpriseUsersButton.selected = NO;
        
        yearPayButton.selected = NO;
        [yearPayButton setBackgroundColor:[UIColor clearColor]];
        yearPayButton.layer.borderColor = RGBA(240, 240, 240, 1).CGColor;
//        monthPayButton.selected = NO;
//        [monthPayButton setBackgroundColor:[UIColor clearColor]];
//        monthPayButton.layer.borderColor = RGBA(240, 240, 240, 1).CGColor;
        
        totalPriceLabel.hidden = YES;
        
        srueButton.frame = CGRectMake(0, 0, ScreenWidth, 40);
        [srueButton setTitle:@"确定" forState:UIControlStateNormal];
    }
}

- (IBAction)srueButtonClicked:(UIButton *)sender {
    [self performSegueWithIdentifier:@"ChoosePayType" sender:nil];
   
}



- (IBAction)backButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if ([segue.identifier isEqualToString:@"ChoosePayType"]) {
        ChoosePayTypeViewController *vc = (ChoosePayTypeViewController *)[segue destinationViewController];
        vc.userId = _userId;
        vc.userPhoneNum = _userPhoneNum;
        vc.userPassword = _userPassword;
    }
}


@end
