//
//  CardMapTableViewCell.h
//  CityServer
//
//  Created by jwdlh on 2018/2/2.
//  Copyright © 2018年 陈文清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardMapTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MKMapView *cardMapView;

@end
