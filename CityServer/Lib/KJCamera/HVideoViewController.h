//
//  HVideoViewController.h
//  Join
//
//  Created by 黄克瑾 on 2017/1/11.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPhotoModel.h"

@class HVideoViewController,HXPhotoModel;

@protocol HXCustomCameraViewControllerDelegate <NSObject>
@optional
- (void)customCameraViewController:(HVideoViewController *)viewController didDone:(HXPhotoModel *)model;
- (void)customCameraViewControllerDidCancel:(HVideoViewController *)viewController;
@end

typedef void(^TakeOperationSureBlock)(id item);

@interface HVideoViewController : UIViewController

@property (copy, nonatomic) TakeOperationSureBlock takeBlock;

@property (assign, nonatomic) NSInteger HSeconds;

@property (weak, nonatomic) id<HXCustomCameraViewControllerDelegate> delegate;
@end
