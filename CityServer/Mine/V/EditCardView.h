//
//  EditCardView.h
//  CityServer
//
//  Created by qing on 2018/3/14.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditCardView : UIView
@property (weak, nonatomic) IBOutlet UIView *view0;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;

@property (weak, nonatomic) IBOutlet UITextField *cardTitleTF;
@property (weak, nonatomic) IBOutlet UITextField *realNameTF;
@property (weak, nonatomic) IBOutlet UITextField *companyNameTF;
@property (weak, nonatomic) IBOutlet UITextField *userIndustryTF;
@property (weak, nonatomic) IBOutlet UITextField *userProfessionTF;
@property (weak, nonatomic) IBOutlet UITextField *userQQTF;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *userAddressTF;
@property (weak, nonatomic) IBOutlet UITextView *companyDescTF;


@end
