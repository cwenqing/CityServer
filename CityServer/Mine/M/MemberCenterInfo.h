//
//	MemberCenterInfo.h
//
//	Create by 文清 陈 on 15/1/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface MemberCenterInfo : NSObject

@property (nonatomic, strong) NSString * avatarPath;
@property (nonatomic, strong) NSString * birthDate;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * district;
@property (nonatomic, strong) NSString * fansCount;
@property (nonatomic, strong) NSString * followersCount;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * realName;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * userSignature;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end