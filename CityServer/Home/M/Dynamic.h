//
//	Dynamic.h
//
//	Create by 文清 陈 on 2/1/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "DynamicPicPath.h"

@interface Dynamic : NSObject

@property (nonatomic, strong) NSString * avatarPath;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, strong) NSString * dynamicContent;
@property (nonatomic, strong) NSString * dynamicId;
@property (nonatomic, strong) NSArray * dynamicPicPath;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, assign) NSInteger supportStatus;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger likeCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
