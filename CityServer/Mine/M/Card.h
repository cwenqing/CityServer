//
//	Card.h
//
//	Create by jwdlh on 2/2/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface Card : NSObject

@property (nonatomic, strong) NSString * cardId;
@property (nonatomic, strong) NSString * cardTitle;
@property (nonatomic, strong) NSString * companyName;
@property (nonatomic, assign) NSInteger defaultCard;
@property (nonatomic, strong) NSString * shareUrl;
@property (nonatomic, strong) NSString * userAvatarPath;
@property (nonatomic, strong) NSString * userProfession;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
