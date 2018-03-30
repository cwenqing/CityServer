//
//	Dynamic.m
//
//	Create by 文清 陈 on 2/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Dynamic.h"

NSString *const kDynamicAvatarPath = @"avatarPath";
NSString *const kDynamicCreateTime = @"createTime";
NSString *const kDynamicDynamicContent = @"dynamicContent";
NSString *const kDynamicDynamicId = @"dynamicId";
NSString *const kDynamicDynamicPicPath = @"dynamicPicPath";
NSString *const kDynamicLatitude = @"latitude";
NSString *const kDynamicLongitude = @"longitude";
NSString *const kDynamicSupportStatus = @"supportStatus";
NSString *const kDynamicUserId = @"userId";
NSString *const kDynamicUserName = @"userName";
NSString *const kDynamicCommentCount = @"commentCount";
NSString *const kDynamicLikeCount = @"likeCount";

@interface Dynamic ()
@end
@implementation Dynamic




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kDynamicAvatarPath] isKindOfClass:[NSNull class]]){
		self.avatarPath = dictionary[kDynamicAvatarPath];
	}	
	if(![dictionary[kDynamicCreateTime] isKindOfClass:[NSNull class]]){
		self.createTime = [dictionary[kDynamicCreateTime] integerValue];
	}

	if(![dictionary[kDynamicDynamicContent] isKindOfClass:[NSNull class]]){
		self.dynamicContent = dictionary[kDynamicDynamicContent];
	}	
	if(![dictionary[kDynamicDynamicId] isKindOfClass:[NSNull class]]){
		self.dynamicId = dictionary[kDynamicDynamicId];
	}	
	if(dictionary[kDynamicDynamicPicPath] != nil && [dictionary[kDynamicDynamicPicPath] isKindOfClass:[NSArray class]]){
		NSArray * dynamicPicPathDictionaries = dictionary[kDynamicDynamicPicPath];
		NSMutableArray * dynamicPicPathItems = [NSMutableArray array];
		for(NSDictionary * dynamicPicPathDictionary in dynamicPicPathDictionaries){
			DynamicPicPath * dynamicPicPathItem = [[DynamicPicPath alloc] initWithDictionary:dynamicPicPathDictionary];
			[dynamicPicPathItems addObject:dynamicPicPathItem];
		}
		self.dynamicPicPath = dynamicPicPathItems;
	}
	if(![dictionary[kDynamicLatitude] isKindOfClass:[NSNull class]]){
		self.latitude = dictionary[kDynamicLatitude];
	}	
	if(![dictionary[kDynamicLongitude] isKindOfClass:[NSNull class]]){
		self.longitude = dictionary[kDynamicLongitude];
	}	
	if(![dictionary[kDynamicSupportStatus] isKindOfClass:[NSNull class]]){
		self.supportStatus = [dictionary[kDynamicSupportStatus] integerValue];
	}

	if(![dictionary[kDynamicUserId] isKindOfClass:[NSNull class]]){
		self.userId = dictionary[kDynamicUserId];
	}	
	if(![dictionary[kDynamicUserName] isKindOfClass:[NSNull class]]){
		self.userName = dictionary[kDynamicUserName];
	}
    if(![dictionary[kDynamicCommentCount] isKindOfClass:[NSNull class]]){
        self.commentCount = [dictionary[kDynamicCommentCount] integerValue];
    }
    if(![dictionary[kDynamicLikeCount] isKindOfClass:[NSNull class]]){
        self.likeCount = [dictionary[kDynamicLikeCount] integerValue];
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
		dictionary[kDynamicAvatarPath] = self.avatarPath;
	}
	dictionary[kDynamicCreateTime] = @(self.createTime);
	if(self.dynamicContent != nil){
		dictionary[kDynamicDynamicContent] = self.dynamicContent;
	}
	if(self.dynamicId != nil){
		dictionary[kDynamicDynamicId] = self.dynamicId;
	}
	if(self.dynamicPicPath != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(DynamicPicPath * dynamicPicPathElement in self.dynamicPicPath){
			[dictionaryElements addObject:[dynamicPicPathElement toDictionary]];
		}
		dictionary[kDynamicDynamicPicPath] = dictionaryElements;
	}
	if(self.latitude != nil){
		dictionary[kDynamicLatitude] = self.latitude;
	}
	if(self.longitude != nil){
		dictionary[kDynamicLongitude] = self.longitude;
	}
	dictionary[kDynamicSupportStatus] = @(self.supportStatus);
	if(self.userId != nil){
		dictionary[kDynamicUserId] = self.userId;
	}
	if(self.userName != nil){
		dictionary[kDynamicUserName] = self.userName;
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
		[aCoder encodeObject:self.avatarPath forKey:kDynamicAvatarPath];
	}
	[aCoder encodeObject:@(self.createTime) forKey:kDynamicCreateTime];	if(self.dynamicContent != nil){
		[aCoder encodeObject:self.dynamicContent forKey:kDynamicDynamicContent];
	}
	if(self.dynamicId != nil){
		[aCoder encodeObject:self.dynamicId forKey:kDynamicDynamicId];
	}
	if(self.dynamicPicPath != nil){
		[aCoder encodeObject:self.dynamicPicPath forKey:kDynamicDynamicPicPath];
	}
	if(self.latitude != nil){
		[aCoder encodeObject:self.latitude forKey:kDynamicLatitude];
	}
	if(self.longitude != nil){
		[aCoder encodeObject:self.longitude forKey:kDynamicLongitude];
	}
	[aCoder encodeObject:@(self.supportStatus) forKey:kDynamicSupportStatus];	if(self.userId != nil){
		[aCoder encodeObject:self.userId forKey:kDynamicUserId];
	}
	if(self.userName != nil){
		[aCoder encodeObject:self.userName forKey:kDynamicUserName];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.avatarPath = [aDecoder decodeObjectForKey:kDynamicAvatarPath];
	self.createTime = [[aDecoder decodeObjectForKey:kDynamicCreateTime] integerValue];
	self.dynamicContent = [aDecoder decodeObjectForKey:kDynamicDynamicContent];
	self.dynamicId = [aDecoder decodeObjectForKey:kDynamicDynamicId];
	self.dynamicPicPath = [aDecoder decodeObjectForKey:kDynamicDynamicPicPath];
	self.latitude = [aDecoder decodeObjectForKey:kDynamicLatitude];
	self.longitude = [aDecoder decodeObjectForKey:kDynamicLongitude];
	self.supportStatus = [[aDecoder decodeObjectForKey:kDynamicSupportStatus] integerValue];
	self.userId = [aDecoder decodeObjectForKey:kDynamicUserId];
	self.userName = [aDecoder decodeObjectForKey:kDynamicUserName];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	Dynamic *copy = [Dynamic new];

	copy.avatarPath = [self.avatarPath copy];
	copy.createTime = self.createTime;
	copy.dynamicContent = [self.dynamicContent copy];
	copy.dynamicId = [self.dynamicId copy];
	copy.dynamicPicPath = [self.dynamicPicPath copy];
	copy.latitude = [self.latitude copy];
	copy.longitude = [self.longitude copy];
	copy.supportStatus = self.supportStatus;
	copy.userId = [self.userId copy];
	copy.userName = [self.userName copy];

	return copy;
}
@end
