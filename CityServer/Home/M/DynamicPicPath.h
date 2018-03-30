//
//	DynamicPicPath.h
//
//	Create by 文清 陈 on 2/1/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface DynamicPicPath : NSObject

@property (nonatomic, strong) NSString * filePath;
@property (nonatomic, strong) NSString * fileType;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end