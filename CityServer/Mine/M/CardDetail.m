//
//    CardDetail.m
//
//    Create by jwdlh on 2/2/2018
//    Copyright © 2018. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CardDetail.h"

NSString *const kCardDetailCardId = @"cardId";
NSString *const kCardDetailCompanyDesc = @"companyDesc";
NSString *const kCardDetailCompanyName = @"companyName";
NSString *const kCardDetailDefaultCard = @"defaultCard";
NSString *const kCardDetailLatitude = @"latitude";
NSString *const kCardDetailLongitude = @"longitude";
NSString *const kCardDetailPicPath = @"picPath";
NSString *const kCardDetailRealName = @"realName";
NSString *const kCardDetailUserAddress = @"userAddress";
NSString *const kCardDetailUserAvatarPath = @"userAvatarPath";
NSString *const kCardDetailUserIndustry = @"userIndustry";
NSString *const kCardDetailUserPhone = @"userPhone";
NSString *const kCardDetailUserProfession = @"userProfession";
NSString *const kCardDetailUserQQ = @"userQQ";
NSString *const kCardDetailCardTitle = @"cardTitle";


@interface CardDetail ()
@end
@implementation CardDetail




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kCardDetailCardTitle] isKindOfClass:[NSNull class]]){
        self.cardTitle = dictionary[kCardDetailCardTitle];
    }
    if(![dictionary[kCardDetailCardId] isKindOfClass:[NSNull class]]){
        self.cardId = dictionary[kCardDetailCardId];
    }
    if(![dictionary[kCardDetailCompanyDesc] isKindOfClass:[NSNull class]]){
        self.companyDesc = dictionary[kCardDetailCompanyDesc];
    }
    if(![dictionary[kCardDetailCompanyName] isKindOfClass:[NSNull class]]){
        self.companyName = dictionary[kCardDetailCompanyName];
    }
    if(![dictionary[kCardDetailDefaultCard] isKindOfClass:[NSNull class]]){
        self.defaultCard = [dictionary[kCardDetailDefaultCard] integerValue];
    }
    
    if(![dictionary[kCardDetailLatitude] isKindOfClass:[NSNull class]]){
        self.latitude = dictionary[kCardDetailLatitude];
    }
    if(![dictionary[kCardDetailLongitude] isKindOfClass:[NSNull class]]){
        self.longitude = dictionary[kCardDetailLongitude];
    }
    if(![dictionary[kCardDetailPicPath] isKindOfClass:[NSNull class]]){
        self.picPath = dictionary[kCardDetailPicPath];
    }
    if(![dictionary[kCardDetailRealName] isKindOfClass:[NSNull class]]){
        self.realName = dictionary[kCardDetailRealName];
    }
    if(![dictionary[kCardDetailUserAddress] isKindOfClass:[NSNull class]]){
        self.userAddress = dictionary[kCardDetailUserAddress];
    }
    if(![dictionary[kCardDetailUserAvatarPath] isKindOfClass:[NSNull class]]){
        self.userAvatarPath = dictionary[kCardDetailUserAvatarPath];
    }
    if(![dictionary[kCardDetailUserIndustry] isKindOfClass:[NSNull class]]){
        self.userIndustry = dictionary[kCardDetailUserIndustry];
    }
    if(![dictionary[kCardDetailUserPhone] isKindOfClass:[NSNull class]]){
        self.userPhone = dictionary[kCardDetailUserPhone];
    }
    if(![dictionary[kCardDetailUserProfession] isKindOfClass:[NSNull class]]){
        self.userProfession = dictionary[kCardDetailUserProfession];
    }
    if(![dictionary[kCardDetailUserQQ] isKindOfClass:[NSNull class]]){
        self.userQQ = dictionary[kCardDetailUserQQ];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.cardId != nil){
        dictionary[kCardDetailCardId] = self.cardId;
    }
    if(self.companyDesc != nil){
        dictionary[kCardDetailCompanyDesc] = self.companyDesc;
    }
    if(self.companyName != nil){
        dictionary[kCardDetailCompanyName] = self.companyName;
    }
    dictionary[kCardDetailDefaultCard] = @(self.defaultCard);
    if(self.latitude != nil){
        dictionary[kCardDetailLatitude] = self.latitude;
    }
    if(self.longitude != nil){
        dictionary[kCardDetailLongitude] = self.longitude;
    }
    if(self.picPath != nil){
        dictionary[kCardDetailPicPath] = self.picPath;
    }
    if(self.realName != nil){
        dictionary[kCardDetailRealName] = self.realName;
    }
    if(self.userAddress != nil){
        dictionary[kCardDetailUserAddress] = self.userAddress;
    }
    if(self.userAvatarPath != nil){
        dictionary[kCardDetailUserAvatarPath] = self.userAvatarPath;
    }
    if(self.userIndustry != nil){
        dictionary[kCardDetailUserIndustry] = self.userIndustry;
    }
    if(self.userPhone != nil){
        dictionary[kCardDetailUserPhone] = self.userPhone;
    }
    if(self.userProfession != nil){
        dictionary[kCardDetailUserProfession] = self.userProfession;
    }
    if(self.userQQ != nil){
        dictionary[kCardDetailUserQQ] = self.userQQ;
    }
    return dictionary;
    
}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if(self.cardId != nil){
        [aCoder encodeObject:self.cardId forKey:kCardDetailCardId];
    }
    if(self.companyDesc != nil){
        [aCoder encodeObject:self.companyDesc forKey:kCardDetailCompanyDesc];
    }
    if(self.companyName != nil){
        [aCoder encodeObject:self.companyName forKey:kCardDetailCompanyName];
    }
    [aCoder encodeObject:@(self.defaultCard) forKey:kCardDetailDefaultCard];    if(self.latitude != nil){
        [aCoder encodeObject:self.latitude forKey:kCardDetailLatitude];
    }
    if(self.longitude != nil){
        [aCoder encodeObject:self.longitude forKey:kCardDetailLongitude];
    }
    if(self.picPath != nil){
        [aCoder encodeObject:self.picPath forKey:kCardDetailPicPath];
    }
    if(self.realName != nil){
        [aCoder encodeObject:self.realName forKey:kCardDetailRealName];
    }
    if(self.userAddress != nil){
        [aCoder encodeObject:self.userAddress forKey:kCardDetailUserAddress];
    }
    if(self.userAvatarPath != nil){
        [aCoder encodeObject:self.userAvatarPath forKey:kCardDetailUserAvatarPath];
    }
    if(self.userIndustry != nil){
        [aCoder encodeObject:self.userIndustry forKey:kCardDetailUserIndustry];
    }
    if(self.userPhone != nil){
        [aCoder encodeObject:self.userPhone forKey:kCardDetailUserPhone];
    }
    if(self.userProfession != nil){
        [aCoder encodeObject:self.userProfession forKey:kCardDetailUserProfession];
    }
    if(self.userQQ != nil){
        [aCoder encodeObject:self.userQQ forKey:kCardDetailUserQQ];
    }
    
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.cardId = [aDecoder decodeObjectForKey:kCardDetailCardId];
    self.companyDesc = [aDecoder decodeObjectForKey:kCardDetailCompanyDesc];
    self.companyName = [aDecoder decodeObjectForKey:kCardDetailCompanyName];
    self.defaultCard = [[aDecoder decodeObjectForKey:kCardDetailDefaultCard] integerValue];
    self.latitude = [aDecoder decodeObjectForKey:kCardDetailLatitude];
    self.longitude = [aDecoder decodeObjectForKey:kCardDetailLongitude];
    self.picPath = [aDecoder decodeObjectForKey:kCardDetailPicPath];
    self.realName = [aDecoder decodeObjectForKey:kCardDetailRealName];
    self.userAddress = [aDecoder decodeObjectForKey:kCardDetailUserAddress];
    self.userAvatarPath = [aDecoder decodeObjectForKey:kCardDetailUserAvatarPath];
    self.userIndustry = [aDecoder decodeObjectForKey:kCardDetailUserIndustry];
    self.userPhone = [aDecoder decodeObjectForKey:kCardDetailUserPhone];
    self.userProfession = [aDecoder decodeObjectForKey:kCardDetailUserProfession];
    self.userQQ = [aDecoder decodeObjectForKey:kCardDetailUserQQ];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    CardDetail *copy = [CardDetail new];
    
    copy.cardId = [self.cardId copy];
    copy.companyDesc = [self.companyDesc copy];
    copy.companyName = [self.companyName copy];
    copy.defaultCard = self.defaultCard;
    copy.latitude = [self.latitude copy];
    copy.longitude = [self.longitude copy];
    copy.picPath = [self.picPath copy];
    copy.realName = [self.realName copy];
    copy.userAddress = [self.userAddress copy];
    copy.userAvatarPath = [self.userAvatarPath copy];
    copy.userIndustry = [self.userIndustry copy];
    copy.userPhone = [self.userPhone copy];
    copy.userProfession = [self.userProfession copy];
    copy.userQQ = [self.userQQ copy];
    
    return copy;
}
@end
