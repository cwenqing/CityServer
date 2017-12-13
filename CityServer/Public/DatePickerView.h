//
//  DatePickerView.h
//  IPadministrator
//
//  Created by transfar on 16/3/29.
//  Copyright © 2016年 transfar. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DatePickerDelegate <NSObject>

-(void)datePickerWithDate:(NSString*)date;

-(void)datePickerCencel;

@end
@interface DatePickerView : UIView
{
    __weak IBOutlet UIButton *cencelButton;
    __weak IBOutlet UIButton *sureButton;
    __weak IBOutlet UIDatePicker *datePickerView;
}
@property (nonatomic, assign)id<DatePickerDelegate> delegate;
@end
