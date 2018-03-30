//
//  CardDetailViewController.h
//  CityServer
//
//  Created by jwdlh on 2018/2/2.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
@interface CardDetailViewController : UIViewController
@property (nonatomic, strong)Card *card;
@property (nonatomic, copy)NSString *userId;
@end
