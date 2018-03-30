//
//	MemberCofig.h
//
//	Create by 文清 陈 on 22/12/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface MemberCofig : NSObject

@property (nonatomic, strong) NSString * loginName;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * realName;
@property (nonatomic, assign) NSInteger  payStatus;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, strong) NSString * rongyunId;
@property (nonatomic, strong) NSString * rongyunToken;
@property (nonatomic, strong) NSString * avatarPath;
+(instancetype)shareInstance;

-(void)updateWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
