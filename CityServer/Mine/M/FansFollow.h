//
//	FansFollow.h
//
//	Create by 文清 陈 on 1/1/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface FansFollow : NSObject

@property (nonatomic, strong) NSString * avatarPath;
@property (nonatomic, strong) NSString * birthDate;
@property (nonatomic, strong) NSString * fansCount;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, strong) NSString * industryDesc;
@property (nonatomic, strong) NSString * rongyunId;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * userSignature;
@property (nonatomic, assign) NSInteger attentionStatus;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * district;
@property (nonatomic, strong) NSString * province;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
