//
//  DatePickerView.m
//  IPadministrator
//
//  Created by transfar on 16/3/29.
//  Copyright © 2016年 transfar. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView

-(void)awakeFromNib{
    [super awakeFromNib];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    datePickerView.locale = locale;
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:60*60*8];
    datePickerView.maximumDate = nowDate;
    cencelButton.layer.cornerRadius = 3;
    cencelButton.layer.masksToBounds = YES;
    sureButton.layer.cornerRadius = 3;
    sureButton.layer.masksToBounds = YES;
}

- (IBAction)cencel:(UIButton *)sender {
    [self.delegate datePickerCencel];
}
- (IBAction)sure:(UIButton *)sender {
    NSDate *select = [datePickerView date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *date =  [dateFormatter stringFromDate:select];
    [self.delegate datePickerWithDate:date];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
