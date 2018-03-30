//
//  DynaimcDetailViewController.h
//  CityServer
//
//  Created by jwdlh on 2018/1/10.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dynamic.h"

@protocol DynamicDetailDelegate <NSObject>

- (void)bringBackWithIndexPath:(NSIndexPath *)indexPath andDynamic:(Dynamic *)dynamic;

@end

@interface DynaimcDetailViewController : UIViewController
@property (nonatomic, strong)Dynamic *dynamic;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, assign)id<DynamicDetailDelegate> delegate;
@end
