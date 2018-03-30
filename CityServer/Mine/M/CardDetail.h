//
//    CardDetail.h
//
//    Create by jwdlh on 2/2/2018
//    Copyright © 2018. All rights reserved.
//

//    Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface CardDetail : NSObject

@property (nonatomic, strong) NSString * cardId;
@property (nonatomic, strong) NSString * companyDesc;
@property (nonatomic, strong) NSString * companyName;
@property (nonatomic, assign) NSInteger defaultCard;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, strong) NSString * picPath;
@property (nonatomic, strong) NSString * realName;
@property (nonatomic, strong) NSString * userAddress;
@property (nonatomic, strong) NSString * userAvatarPath;
@property (nonatomic, strong) NSString * userIndustry;
@property (nonatomic, strong) NSString * userPhone;
@property (nonatomic, strong) NSString * userProfession;
@property (nonatomic, strong) NSString * userQQ;
@property (nonatomic, strong) NSString * cardTitle;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
