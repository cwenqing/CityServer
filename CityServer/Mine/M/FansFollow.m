//
//	FansFollow.m
//
//	Create by 文清 陈 on 1/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FansFollow.h"

NSString *const kFansFollowAvatarPath = @"avatarPath";
NSString *const kFansFollowBirthDate = @"birthDate";
NSString *const kFansFollowFansCount = @"fansCount";
NSString *const kFansFollowGender = @"gender";
NSString *const kFansFollowIndustryDesc = @"industryDesc";
NSString *const kFansFollowRongyunId = @"rongyunId";
NSString *const kFansFollowUserId = @"userId";
NSString *const kFansFollowUserName = @"userName";
NSString *const kFansFollowUserSignature = @"userSignature";
NSString *const kRootClassAttentionStatus = @"attentionStatus";
NSString *const kFansFollowCity = @"city";
NSString *const kFansFollowDistrict = @"district";
NSString *const kFansFollowProvince = @"province";

@interface FansFollow ()
@end
@implementation FansFollow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kFansFollowAvatarPath] isKindOfClass:[NSNull class]]){
		self.avatarPath = dictionary[kFansFollowAvatarPath];
	}	
	if(![dictionary[kFansFollowBirthDate] isKindOfClass:[NSNull class]]){
		self.birthDate = dictionary[kFansFollowBirthDate];
	}	
	if(![dictionary[kFansFollowFansCount] isKindOfClass:[NSNull class]]){
		self.fansCount = dictionary[kFansFollowFansCount];
	}	
	if(![dictionary[kFansFollowGender] isKindOfClass:[NSNull class]]){
		self.gender = [dictionary[kFansFollowGender] integerValue];
	}

	if(![dictionary[kFansFollowIndustryDesc] isKindOfClass:[NSNull class]]){
		self.industryDesc = dictionary[kFansFollowIndustryDesc];
	}	
	if(![dictionary[kFansFollowRongyunId] isKindOfClass:[NSNull class]]){
		self.rongyunId = dictionary[kFansFollowRongyunId];
	}	
	if(![dictionary[kFansFollowUserId] isKindOfClass:[NSNull class]]){
		self.userId = dictionary[kFansFollowUserId];
	}	
	if(![dictionary[kFansFollowUserName] isKindOfClass:[NSNull class]]){
		self.userName = dictionary[kFansFollowUserName];
	}	
	if(![dictionary[kFansFollowUserSignature] isKindOfClass:[NSNull class]]){
		self.userSignature = dictionary[kFansFollowUserSignature];
	}
    if(![dictionary[kRootClassAttentionStatus] isKindOfClass:[NSNull class]]){
        self.attentionStatus = [dictionary[kRootClassAttentionStatus] integerValue];
    }
    if(![dictionary[kFansFollowCity] isKindOfClass:[NSNull class]]){
        self.city = dictionary[kFansFollowCity];
    }
    if(![dictionary[kFansFollowDistrict] isKindOfClass:[NSNull class]]){
        self.district = dictionary[kFansFollowDistrict];
    }
    if(![dictionary[kFansFollowProvince] isKindOfClass:[NSNull class]]){
        self.province = dictionary[kFansFollowProvince];
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
		dictionary[kFansFollowAvatarPath] = self.avatarPath;
	}
	if(self.birthDate != nil){
		dictionary[kFansFollowBirthDate] = self.birthDate;
	}
	if(self.fansCount != nil){
		dictionary[kFansFollowFansCount] = self.fansCount;
	}
	dictionary[kFansFollowGender] = @(self.gender);
	if(self.industryDesc != nil){
		dictionary[kFansFollowIndustryDesc] = self.industryDesc;
	}
	if(self.rongyunId != nil){
		dictionary[kFansFollowRongyunId] = self.rongyunId;
	}
	if(self.userId != nil){
		dictionary[kFansFollowUserId] = self.userId;
	}
	if(self.userName != nil){
		dictionary[kFansFollowUserName] = self.userName;
	}
	if(self.userSignature != nil){
		dictionary[kFansFollowUserSignature] = self.userSignature;
	}
    dictionary[kRootClassAttentionStatus] = @(self.attentionStatus);
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
		[aCoder encodeObject:self.avatarPath forKey:kFansFollowAvatarPath];
	}
	if(self.birthDate != nil){
		[aCoder encodeObject:self.birthDate forKey:kFansFollowBirthDate];
	}
	if(self.fansCount != nil){
		[aCoder encodeObject:self.fansCount forKey:kFansFollowFansCount];
	}
	[aCoder encodeObject:@(self.gender) forKey:kFansFollowGender];	if(self.industryDesc != nil){
		[aCoder encodeObject:self.industryDesc forKey:kFansFollowIndustryDesc];
	}
	if(self.rongyunId != nil){
		[aCoder encodeObject:self.rongyunId forKey:kFansFollowRongyunId];
	}
	if(self.userId != nil){
		[aCoder encodeObject:self.userId forKey:kFansFollowUserId];
	}
	if(self.userName != nil){
		[aCoder encodeObject:self.userName forKey:kFansFollowUserName];
	}
	if(self.userSignature != nil){
		[aCoder encodeObject:self.userSignature forKey:kFansFollowUserSignature];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.avatarPath = [aDecoder decodeObjectForKey:kFansFollowAvatarPath];
	self.birthDate = [aDecoder decodeObjectForKey:kFansFollowBirthDate];
	self.fansCount = [aDecoder decodeObjectForKey:kFansFollowFansCount];
	self.gender = [[aDecoder decodeObjectForKey:kFansFollowGender] integerValue];
	self.industryDesc = [aDecoder decodeObjectForKey:kFansFollowIndustryDesc];
	self.rongyunId = [aDecoder decodeObjectForKey:kFansFollowRongyunId];
	self.userId = [aDecoder decodeObjectForKey:kFansFollowUserId];
	self.userName = [aDecoder decodeObjectForKey:kFansFollowUserName];
	self.userSignature = [aDecoder decodeObjectForKey:kFansFollowUserSignature];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	FansFollow *copy = [FansFollow new];

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
