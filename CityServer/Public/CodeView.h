//
//  CodeView.h
//  CityServer
//
//  Created by jwdlh on 2017/12/18.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeView : UIView
@property (nonatomic, retain) NSArray *changeArray;
@property (nonatomic, retain) NSMutableString *changeString;
@property (nonatomic, retain) UILabel *codeLabel;

-(void)changeCode;

@end
