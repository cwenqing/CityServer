//
//	MemberCenterInfo.m
//
//	Create by 文清 陈 on 15/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "MemberCenterInfo.h"

NSString *const kMemberCenterInfoAvatarPath = @"avatarPath";
NSString *const kMemberCenterInfoBirthDate = @"birthDate";
NSString *const kMemberCenterInfoCity = @"city";
NSString *const kMemberCenterInfoDistrict = @"district";
NSString *const kMemberCenterInfoFansCount = @"fansCount";
NSString *const kMemberCenterInfoFollowersCount = @"followersCount";
NSString *const kMemberCenterInfoGender = @"gender";
NSString *const kMemberCenterInfoProvince = @"province";
NSString *const kMemberCenterInfoRealName = @"realName";
NSString *const kMemberCenterInfoUserName = @"userName";
NSString *const kMemberCenterInfoUserSignature = @"userSignature";

@interface MemberCenterInfo ()
@end
@implementation MemberCenterInfo




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kMemberCenterInfoAvatarPath] isKindOfClass:[NSNull class]]){
		self.avatarPath = dictionary[kMemberCenterInfoAvatarPath];
	}	
	if(![dictionary[kMemberCenterInfoBirthDate] isKindOfClass:[NSNull class]]){
		self.birthDate = dictionary[kMemberCenterInfoBirthDate];
	}	
	if(![dictionary[kMemberCenterInfoCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kMemberCenterInfoCity];
	}	
	if(![dictionary[kMemberCenterInfoDistrict] isKindOfClass:[NSNull class]]){
		self.district = dictionary[kMemberCenterInfoDistrict];
	}	
	if(![dictionary[kMemberCenterInfoFansCount] isKindOfClass:[NSNull class]]){
		self.fansCount = dictionary[kMemberCenterInfoFansCount];
	}	
	if(![dictionary[kMemberCenterInfoFollowersCount] isKindOfClass:[NSNull class]]){
		self.followersCount = dictionary[kMemberCenterInfoFollowersCount];
	}	
	if(![dictionary[kMemberCenterInfoGender] isKindOfClass:[NSNull class]]){
		self.gender = [dictionary[kMemberCenterInfoGender] integerValue];
	}

	if(![dictionary[kMemberCenterInfoProvince] isKindOfClass:[NSNull class]]){
		self.province = dictionary[kMemberCenterInfoProvince];
	}	
	if(![dictionary[kMemberCenterInfoRealName] isKindOfClass:[NSNull class]]){
		self.realName = dictionary[kMemberCenterInfoRealName];
	}	
	if(![dictionary[kMemberCenterInfoUserName] isKindOfClass:[NSNull class]]){
		self.userName = dictionary[kMemberCenterInfoUserName];
	}	
	if(![dictionary[kMemberCenterInfoUserSignature] isKindOfClass:[NSNull class]]){
		self.userSignature = dictionary[kMemberCenterInfoUserSignature];
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
		dictionary[kMemberCenterInfoAvatarPath] = self.avatarPath;
	}
	if(self.birthDate != nil){
		dictionary[kMemberCenterInfoBirthDate] = self.birthDate;
	}
	if(self.city != nil){
		dictionary[kMemberCenterInfoCity] = self.city;
	}
	if(self.district != nil){
		dictionary[kMemberCenterInfoDistrict] = self.district;
	}
	if(self.fansCount != nil){
		dictionary[kMemberCenterInfoFansCount] = self.fansCount;
	}
	if(self.followersCount != nil){
		dictionary[kMemberCenterInfoFollowersCount] = self.followersCount;
	}
	dictionary[kMemberCenterInfoGender] = @(self.gender);
	if(self.province != nil){
		dictionary[kMemberCenterInfoProvince] = self.province;
	}
	if(self.realName != nil){
		dictionary[kMemberCenterInfoRealName] = self.realName;
	}
	if(self.userName != nil){
		dictionary[kMemberCenterInfoUserName] = self.userName;
	}
	if(self.userSignature != nil){
		dictionary[kMemberCenterInfoUserSignature] = self.userSignature;
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
		[aCoder encodeObject:self.avatarPath forKey:kMemberCenterInfoAvatarPath];
	}
	if(self.birthDate != nil){
		[aCoder encodeObject:self.birthDate forKey:kMemberCenterInfoBirthDate];
	}
	if(self.city != nil){
		[aCoder encodeObject:self.city forKey:kMemberCenterInfoCity];
	}
	if(self.district != nil){
		[aCoder encodeObject:self.district forKey:kMemberCenterInfoDistrict];
	}
	if(self.fansCount != nil){
		[aCoder encodeObject:self.fansCount forKey:kMemberCenterInfoFansCount];
	}
	if(self.followersCount != nil){
		[aCoder encodeObject:self.followersCount forKey:kMemberCenterInfoFollowersCount];
	}
	[aCoder encodeObject:@(self.gender) forKey:kMemberCenterInfoGender];	if(self.province != nil){
		[aCoder encodeObject:self.province forKey:kMemberCenterInfoProvince];
	}
	if(self.realName != nil){
		[aCoder encodeObject:self.realName forKey:kMemberCenterInfoRealName];
	}
	if(self.userName != nil){
		[aCoder encodeObject:self.userName forKey:kMemberCenterInfoUserName];
	}
	if(self.userSignature != nil){
		[aCoder encodeObject:self.userSignature forKey:kMemberCenterInfoUserSignature];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.avatarPath = [aDecoder decodeObjectForKey:kMemberCenterInfoAvatarPath];
	self.birthDate = [aDecoder decodeObjectForKey:kMemberCenterInfoBirthDate];
	self.city = [aDecoder decodeObjectForKey:kMemberCenterInfoCity];
	self.district = [aDecoder decodeObjectForKey:kMemberCenterInfoDistrict];
	self.fansCount = [aDecoder decodeObjectForKey:kMemberCenterInfoFansCount];
	self.followersCount = [aDecoder decodeObjectForKey:kMemberCenterInfoFollowersCount];
	self.gender = [[aDecoder decodeObjectForKey:kMemberCenterInfoGender] integerValue];
	self.province = [aDecoder decodeObjectForKey:kMemberCenterInfoProvince];
	self.realName = [aDecoder decodeObjectForKey:kMemberCenterInfoRealName];
	self.userName = [aDecoder decodeObjectForKey:kMemberCenterInfoUserName];
	self.userSignature = [aDecoder decodeObjectForKey:kMemberCenterInfoUserSignature];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	MemberCenterInfo *copy = [MemberCenterInfo new];

	copy.avatarPath = [self.avatarPath copy];
	copy.birthDate = [self.birthDate copy];
	copy.city = [self.city copy];
	copy.district = [self.district copy];
	copy.fansCount = [self.fansCount copy];
	copy.followersCount = [self.followersCount copy];
	copy.gender = self.gender;
	copy.province = [self.province copy];
	copy.realName = [self.realName copy];
	copy.userName = [self.userName copy];
	copy.userSignature = [self.userSignature copy];

	return copy;
}
@end