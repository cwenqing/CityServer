//
//	DynamicPicPath.m
//
//	Create by 文清 陈 on 2/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "DynamicPicPath.h"

NSString *const kDynamicPicPathFilePath = @"filePath";
NSString *const kDynamicPicPathFileType = @"fileType";

@interface DynamicPicPath ()
@end
@implementation DynamicPicPath




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kDynamicPicPathFilePath] isKindOfClass:[NSNull class]]){
		self.filePath = dictionary[kDynamicPicPathFilePath];
	}	
	if(![dictionary[kDynamicPicPathFileType] isKindOfClass:[NSNull class]]){
		self.fileType = dictionary[kDynamicPicPathFileType];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.filePath != nil){
		dictionary[kDynamicPicPathFilePath] = self.filePath;
	}
	if(self.fileType != nil){
		dictionary[kDynamicPicPathFileType] = self.fileType;
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
	if(self.filePath != nil){
		[aCoder encodeObject:self.filePath forKey:kDynamicPicPathFilePath];
	}
	if(self.fileType != nil){
		[aCoder encodeObject:self.fileType forKey:kDynamicPicPathFileType];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.filePath = [aDecoder decodeObjectForKey:kDynamicPicPathFilePath];
	self.fileType = [aDecoder decodeObjectForKey:kDynamicPicPathFileType];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	DynamicPicPath *copy = [DynamicPicPath new];

	copy.filePath = [self.filePath copy];
	copy.fileType = [self.fileType copy];

	return copy;
}
@end