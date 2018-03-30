//
//  CollectionViewCell.h
//  CityServer
//
//  Created by jwdlh on 2017/12/25.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dynamic.h"
#import <CoreLocation/CoreLocation.h>
@protocol DynamicCellDelegate <NSObject>

- (void)supportOrNotWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface DynamicCollectionViewCell : UICollectionViewCell<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *supportButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)Dynamic *dynamic;
@property (nonatomic, assign)id<DynamicCellDelegate> delegate;
@end
