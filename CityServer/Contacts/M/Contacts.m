//
//	Contacts.m
//
//	Create by 文清 陈 on 11/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Contacts.h"

NSString *const kContactsAvatarPath = @"avatarPath";
NSString *const kContactsBirthDate = @"birthDate";
NSString *const kContactsCity = @"city";
NSString *const kContactsDistrict = @"district";
NSString *const kContactsGender = @"gender";
NSString *const kContactsInitial = @"initial";
NSString *const kContactsProvince = @"province";
NSString *const kContactsQrcodePath = @"qrcodePath";
NSString *const kContactsRongyunId = @"rongyunId";
NSString *const kContactsUserId = @"userId";
NSString *const kContactsUserName = @"userName";
NSString *const kContactsUserSignature = @"userSignature";

@interface Contacts ()
@end
@implementation Contacts




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kContactsAvatarPath] isKindOfClass:[NSNull class]]){
		self.avatarPath = dictionary[kContactsAvatarPath];
	}	
	if(![dictionary[kContactsBirthDate] isKindOfClass:[NSNull class]]){
		self.birthDate = dictionary[kContactsBirthDate];
	}	
	if(![dictionary[kContactsCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kContactsCity];
	}	
	if(![dictionary[kContactsDistrict] isKindOfClass:[NSNull class]]){
		self.district = dictionary[kContactsDistrict];
	}	
	if(![dictionary[kContactsGender] isKindOfClass:[NSNull class]]){
		self.gender = [dictionary[kContactsGender] integerValue];
	}

	if(![dictionary[kContactsInitial] isKindOfClass:[NSNull class]]){
		self.initial = dictionary[kContactsInitial];
	}	
	if(![dictionary[kContactsProvince] isKindOfClass:[NSNull class]]){
		self.province = dictionary[kContactsProvince];
	}	
	if(![dictionary[kContactsQrcodePath] isKindOfClass:[NSNull class]]){
		self.qrcodePath = dictionary[kContactsQrcodePath];
	}	
	if(![dictionary[kContactsRongyunId] isKindOfClass:[NSNull class]]){
		self.rongyunId = dictionary[kContactsRongyunId];
	}	
	if(![dictionary[kContactsUserId] isKindOfClass:[NSNull class]]){
		self.userId = dictionary[kContactsUserId];
	}	
	if(![dictionary[kContactsUserName] isKindOfClass:[NSNull class]]){
		self.userName = dictionary[kContactsUserName];
	}	
	if(![dictionary[kContactsUserSignature] isKindOfClass:[NSNull class]]){
		self.userSignature = dictionary[kContactsUserSignature];
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
		dictionary[kContactsAvatarPath] = self.avatarPath;
	}
	if(self.birthDate != nil){
		dictionary[kContactsBirthDate] = self.birthDate;
	}
	if(self.city != nil){
		dictionary[kContactsCity] = self.city;
	}
	if(self.district != nil){
		dictionary[kContactsDistrict] = self.district;
	}
	dictionary[kContactsGender] = @(self.gender);
	if(self.initial != nil){
		dictionary[kContactsInitial] = self.initial;
	}
	if(self.province != nil){
		dictionary[kContactsProvince] = self.province;
	}
	if(self.qrcodePath != nil){
		dictionary[kContactsQrcodePath] = self.qrcodePath;
	}
	if(self.rongyunId != nil){
		dictionary[kContactsRongyunId] = self.rongyunId;
	}
	if(self.userId != nil){
		dictionary[kContactsUserId] = self.userId;
	}
	if(self.userName != nil){
		dictionary[kContactsUserName] = self.userName;
	}
	if(self.userSignature != nil){
		dictionary[kContactsUserSignature] = self.userSignature;
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
		[aCoder encodeObject:self.avatarPath forKey:kContactsAvatarPath];
	}
	if(self.birthDate != nil){
		[aCoder encodeObject:self.birthDate forKey:kContactsBirthDate];
	}
	if(self.city != nil){
		[aCoder encodeObject:self.city forKey:kContactsCity];
	}
	if(self.district != nil){
		[aCoder encodeObject:self.district forKey:kContactsDistrict];
	}
	[aCoder encodeObject:@(self.gender) forKey:kContactsGender];	if(self.initial != nil){
		[aCoder encodeObject:self.initial forKey:kContactsInitial];
	}
	if(self.province != nil){
		[aCoder encodeObject:self.province forKey:kContactsProvince];
	}
	if(self.qrcodePath != nil){
		[aCoder encodeObject:self.qrcodePath forKey:kContactsQrcodePath];
	}
	if(self.rongyunId != nil){
		[aCoder encodeObject:self.rongyunId forKey:kContactsRongyunId];
	}
	if(self.userId != nil){
		[aCoder encodeObject:self.userId forKey:kContactsUserId];
	}
	if(self.userName != nil){
		[aCoder encodeObject:self.userName forKey:kContactsUserName];
	}
	if(self.userSignature != nil){
		[aCoder encodeObject:self.userSignature forKey:kContactsUserSignature];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.avatarPath = [aDecoder decodeObjectForKey:kContactsAvatarPath];
	self.birthDate = [aDecoder decodeObjectForKey:kContactsBirthDate];
	self.city = [aDecoder decodeObjectForKey:kContactsCity];
	self.district = [aDecoder decodeObjectForKey:kContactsDistrict];
	self.gender = [[aDecoder decodeObjectForKey:kContactsGender] integerValue];
	self.initial = [aDecoder decodeObjectForKey:kContactsInitial];
	self.province = [aDecoder decodeObjectForKey:kContactsProvince];
	self.qrcodePath = [aDecoder decodeObjectForKey:kContactsQrcodePath];
	self.rongyunId = [aDecoder decodeObjectForKey:kContactsRongyunId];
	self.userId = [aDecoder decodeObjectForKey:kContactsUserId];
	self.userName = [aDecoder decodeObjectForKey:kContactsUserName];
	self.userSignature = [aDecoder decodeObjectForKey:kContactsUserSignature];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	Contacts *copy = [Contacts new];

	copy.avatarPath = [self.avatarPath copy];
	copy.birthDate = [self.birthDate copy];
	copy.city = [self.city copy];
	copy.district = [self.district copy];
	copy.gender = self.gender;
	copy.initial = [self.initial copy];
	copy.province = [self.province copy];
	copy.qrcodePath = [self.qrcodePath copy];
	copy.rongyunId = [self.rongyunId copy];
	copy.userId = [self.userId copy];
	copy.userName = [self.userName copy];
	copy.userSignature = [self.userSignature copy];

	return copy;
}
@end