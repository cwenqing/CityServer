//
//	Comment.m
//
//	Create by 文清 陈 on 10/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Comment.h"

NSString *const kCommentAvatarPath = @"avatarPath";
NSString *const kCommentCommentContent = @"commentContent";
NSString *const kCommentCommentId = @"commentId";
NSString *const kCommentCreateTime = @"createTime";
NSString *const kCommentDynamicId = @"dynamicId";
NSString *const kCommentGender = @"gender";
NSString *const kCommentUserId = @"userId";
NSString *const kCommentUserName = @"userName";

@interface Comment ()
@end
@implementation Comment




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kCommentAvatarPath] isKindOfClass:[NSNull class]]){
		self.avatarPath = dictionary[kCommentAvatarPath];
	}	
	if(![dictionary[kCommentCommentContent] isKindOfClass:[NSNull class]]){
		self.commentContent = dictionary[kCommentCommentContent];
	}	
	if(![dictionary[kCommentCommentId] isKindOfClass:[NSNull class]]){
		self.commentId = dictionary[kCommentCommentId];
	}	
	if(![dictionary[kCommentCreateTime] isKindOfClass:[NSNull class]]){
		self.createTime = [dictionary[kCommentCreateTime] integerValue];
	}

	if(![dictionary[kCommentDynamicId] isKindOfClass:[NSNull class]]){
		self.dynamicId = dictionary[kCommentDynamicId];
	}	
	if(![dictionary[kCommentGender] isKindOfClass:[NSNull class]]){
		self.gender = [dictionary[kCommentGender] integerValue];
	}

	if(![dictionary[kCommentUserId] isKindOfClass:[NSNull class]]){
		self.userId = dictionary[kCommentUserId];
	}	
	if(![dictionary[kCommentUserName] isKindOfClass:[NSNull class]]){
		self.userName = dictionary[kCommentUserName];
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
		dictionary[kCommentAvatarPath] = self.avatarPath;
	}
	if(self.commentContent != nil){
		dictionary[kCommentCommentContent] = self.commentContent;
	}
	if(self.commentId != nil){
		dictionary[kCommentCommentId] = self.commentId;
	}
	dictionary[kCommentCreateTime] = @(self.createTime);
	if(self.dynamicId != nil){
		dictionary[kCommentDynamicId] = self.dynamicId;
	}
	dictionary[kCommentGender] = @(self.gender);
	if(self.userId != nil){
		dictionary[kCommentUserId] = self.userId;
	}
	if(self.userName != nil){
		dictionary[kCommentUserName] = self.userName;
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
		[aCoder encodeObject:self.avatarPath forKey:kCommentAvatarPath];
	}
	if(self.commentContent != nil){
		[aCoder encodeObject:self.commentContent forKey:kCommentCommentContent];
	}
	if(self.commentId != nil){
		[aCoder encodeObject:self.commentId forKey:kCommentCommentId];
	}
	[aCoder encodeObject:@(self.createTime) forKey:kCommentCreateTime];	if(self.dynamicId != nil){
		[aCoder encodeObject:self.dynamicId forKey:kCommentDynamicId];
	}
	[aCoder encodeObject:@(self.gender) forKey:kCommentGender];	if(self.userId != nil){
		[aCoder encodeObject:self.userId forKey:kCommentUserId];
	}
	if(self.userName != nil){
		[aCoder encodeObject:self.userName forKey:kCommentUserName];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.avatarPath = [aDecoder decodeObjectForKey:kCommentAvatarPath];
	self.commentContent = [aDecoder decodeObjectForKey:kCommentCommentContent];
	self.commentId = [aDecoder decodeObjectForKey:kCommentCommentId];
	self.createTime = [[aDecoder decodeObjectForKey:kCommentCreateTime] integerValue];
	self.dynamicId = [aDecoder decodeObjectForKey:kCommentDynamicId];
	self.gender = [[aDecoder decodeObjectForKey:kCommentGender] integerValue];
	self.userId = [aDecoder decodeObjectForKey:kCommentUserId];
	self.userName = [aDecoder decodeObjectForKey:kCommentUserName];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	Comment *copy = [Comment new];

	copy.avatarPath = [self.avatarPath copy];
	copy.commentContent = [self.commentContent copy];
	copy.commentId = [self.commentId copy];
	copy.createTime = self.createTime;
	copy.dynamicId = [self.dynamicId copy];
	copy.gender = self.gender;
	copy.userId = [self.userId copy];
	copy.userName = [self.userName copy];

	return copy;
}
@end