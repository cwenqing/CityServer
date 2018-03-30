//
//	Comment.h
//
//	Create by 文清 陈 on 10/1/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface Comment : NSObject

@property (nonatomic, strong) NSString * avatarPath;
@property (nonatomic, strong) NSString * commentContent;
@property (nonatomic, strong) NSString * commentId;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, strong) NSString * dynamicId;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * userName;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end