//
//	Recommend.m
//
//	Create by 文清 陈 on 1/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Recommend.h"

NSString *const kRecommendAvatarPath = @"avatarPath";
NSString *const kRecommendBirthDate = @"birthDate";
NSString *const kRecommendFansCount = @"fansCount";
NSString *const kRecommendGender = @"gender";
NSString *const kRecommendIndustryDesc = @"industryDesc";
NSString *const kRecommendRongyunId = @"rongyunId";
NSString *const kRecommendUserId = @"userId";
NSString *const kRecommendUserName = @"userName";
NSString *const kRecommendUserSignature = @"userSignature";
NSString *const kRecommendCity = @"city";
NSString *const kRecommendDistrict = @"district";
NSString *const kRecommendProvince = @"province";

@interface Recommend ()
@end
@implementation Recommend




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kRecommendAvatarPath] isKindOfClass:[NSNull class]]){
		self.avatarPath = dictionary[kRecommendAvatarPath];
	}	
	if(![dictionary[kRecommendBirthDate] isKindOfClass:[NSNull class]]){
		self.birthDate = dictionary[kRecommendBirthDate];
	}	
	if(![dictionary[kRecommendFansCount] isKindOfClass:[NSNull class]]){
		self.fansCount = dictionary[kRecommendFansCount];
	}	
	if(![dictionary[kRecommendGender] isKindOfClass:[NSNull class]]){
		self.gender = [dictionary[kRecommendGender] integerValue];
	}

	if(![dictionary[kRecommendIndustryDesc] isKindOfClass:[NSNull class]]){
		self.industryDesc = dictionary[kRecommendIndustryDesc];
	}	
	if(![dictionary[kRecommendRongyunId] isKindOfClass:[NSNull class]]){
		self.rongyunId = dictionary[kRecommendRongyunId];
	}	
	if(![dictionary[kRecommendUserId] isKindOfClass:[NSNull class]]){
		self.userId = dictionary[kRecommendUserId];
	}	
	if(![dictionary[kRecommendUserName] isKindOfClass:[NSNull class]]){
		self.userName = dictionary[kRecommendUserName];
	}	
	if(![dictionary[kRecommendUserSignature] isKindOfClass:[NSNull class]]){
		self.userSignature = dictionary[kRecommendUserSignature];
	}
    if(![dictionary[kRecommendCity] isKindOfClass:[NSNull class]]){
        self.city = dictionary[kRecommendCity];
    }
    if(![dictionary[kRecommendDistrict] isKindOfClass:[NSNull class]]){
        self.district = dictionary[kRecommendDistrict];
    }
    if(![dictionary[kRecommendProvince] isKindOfClass:[NSNull class]]){
        self.province = dictionary[kRecommendProvince];
    }
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.avatarPath != nil){
		dictionary[kRecommendAvatarPath] = self.avatarPath;
	}
	if(self.birthDate != nil){
		dictionary[kRecommendBirthDate] = self.birthDate;
	}
	if(self.fansCount != nil){
		dictionary[kRecommendFansCount] = self.fansCount;
	}
	dictionary[kRecommendGender] = @(self.gender);
	if(self.industryDesc != nil){
		dictionary[kRecommendIndustryDesc] = self.industryDesc;
	}
	if(self.rongyunId != nil){
		dictionary[kRecommendRongyunId] = self.rongyunId;
	}
	if(self.userId != nil){
		dictionary[kRecommendUserId] = self.userId;
	}
	if(self.userName != nil){
		dictionary[kRecommendUserName] = self.userName;
	}
	if(self.userSignature != nil){
		dictionary[kRecommendUserSignature] = self.userSignature;
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
	if(self.avatarPath != nil){
		[aCoder encodeObject:self.avatarPath forKey:kRecommendAvatarPath];
	}
	if(self.birthDate != nil){
		[aCoder encodeObject:self.birthDate forKey:kRecommendBirthDate];
	}
	if(self.fansCount != nil){
		[aCoder encodeObject:self.fansCount forKey:kRecommendFansCount];
	}
	[aCoder encodeObject:@(self.gender) forKey:kRecommendGender];	if(self.industryDesc != nil){
		[aCoder encodeObject:self.industryDesc forKey:kRecommendIndustryDesc];
	}
	if(self.rongyunId != nil){
		[aCoder encodeObject:self.rongyunId forKey:kRecommendRongyunId];
	}
	if(self.userId != nil){
		[aCoder encodeObject:self.userId forKey:kRecommendUserId];
	}
	if(self.userName != nil){
		[aCoder encodeObject:self.userName forKey:kRecommendUserName];
	}
	if(self.userSignature != nil){
		[aCoder encodeObject:self.userSignature forKey:kRecommendUserSignature];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.avatarPath = [aDecoder decodeObjectForKey:kRecommendAvatarPath];
	self.birthDate = [aDecoder decodeObjectForKey:kRecommendBirthDate];
	self.fansCount = [aDecoder decodeObjectForKey:kRecommendFansCount];
	self.gender = [[aDecoder decodeObjectForKey:kRecommendGender] integerValue];
	self.industryDesc = [aDecoder decodeObjectForKey:kRecommendIndustryDesc];
	self.rongyunId = [aDecoder decodeObjectForKey:kRecommendRongyunId];
	self.userId = [aDecoder decodeObjectForKey:kRecommendUserId];
	self.userName = [aDecoder decodeObjectForKey:kRecommendUserName];
	self.userSignature = [aDecoder decodeObjectForKey:kRecommendUserSignature];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	Recommend *copy = [Recommend new];

	copy.avatarPath = [self.avatarPath copy];
	copy.birthDate = [self.birthDate copy];
	copy.fansCount = [self.fansCount copy];
	copy.gender = self.gender;
	copy.industryDesc = [self.industryDesc copy];
	copy.rongyunId = [self.rongyunId copy];
	copy.userId = [self.userId copy];
	copy.userName = [self.userName copy];
	copy.userSignature = [self.userSignature copy];

	return copy;
}
@end
