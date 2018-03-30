//
//	Contacts.h
//
//	Create by 文清 陈 on 11/1/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface Contacts : NSObject

@property (nonatomic, strong) NSString * avatarPath;
@property (nonatomic, strong) NSString * birthDate;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * district;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, strong) NSString * initial;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * qrcodePath;
@property (nonatomic, strong) NSString * rongyunId;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * userSignature;
@property (nonatomic, strong) NSString * pinYin;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
