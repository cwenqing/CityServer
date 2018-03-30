//
//	Card.m
//
//	Create by jwdlh on 2/2/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Card.h"

NSString *const kCardCardId = @"cardId";
NSString *const kCardCardTitle = @"cardTitle";
NSString *const kCardCompanyName = @"companyName";
NSString *const kCardDefaultCard = @"defaultCard";
NSString *const kCardShareUrl = @"shareUrl";
NSString *const kCardUserAvatarPath = @"userAvatarPath";
NSString *const kCardUserProfession = @"userProfession";

@interface Card ()
@end
@implementation Card




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
    if(![dictionary[kCardCardId] isKindOfClass:[NSNull class]]){
        self.cardId = dictionary[kCardCardId];
    }
    if(![dictionary[kCardCardTitle] isKindOfClass:[NSNull class]]){
        self.cardTitle = dictionary[kCardCardTitle];
    }
    if(![dictionary[kCardCompanyName] isKindOfClass:[NSNull class]]){
        self.companyName = dictionary[kCardCompanyName];
    }
    if(![dictionary[kCardDefaultCard] isKindOfClass:[NSNull class]]){
        self.defaultCard = [dictionary[kCardDefaultCard] integerValue];
    }
    
    if(![dictionary[kCardShareUrl] isKindOfClass:[NSNull class]]){
        self.shareUrl = dictionary[kCardShareUrl];
    }
    if(![dictionary[kCardUserAvatarPath] isKindOfClass:[NSNull class]]){
        self.userAvatarPath = dictionary[kCardUserAvatarPath];
    }
    if(![dictionary[kCardUserProfession] isKindOfClass:[NSNull class]]){
        self.userProfession = dictionary[kCardUserProfession];
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
		dictionary[kCardCardId] = self.cardId;
	}
	if(self.companyName != nil){
		dictionary[kCardCompanyName] = self.companyName;
	}
	dictionary[kCardDefaultCard] = @(self.defaultCard);
	if(self.shareUrl != nil){
		dictionary[kCardShareUrl] = self.shareUrl;
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
		[aCoder encodeObject:self.cardId forKey:kCardCardId];
	}
	if(self.companyName != nil){
		[aCoder encodeObject:self.companyName forKey:kCardCompanyName];
	}
	[aCoder encodeObject:@(self.defaultCard) forKey:kCardDefaultCard];	if(self.shareUrl != nil){
		[aCoder encodeObject:self.shareUrl forKey:kCardShareUrl];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.cardId = [aDecoder decodeObjectForKey:kCardCardId];
	self.companyName = [aDecoder decodeObjectForKey:kCardCompanyName];
	self.defaultCard = [[aDecoder decodeObjectForKey:kCardDefaultCard] integerValue];
	self.shareUrl = [aDecoder decodeObjectForKey:kCardShareUrl];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	Card *copy = [Card new];

	copy.cardId = [self.cardId copy];
	copy.companyName = [self.companyName copy];
	copy.defaultCard = self.defaultCard;
	copy.shareUrl = [self.shareUrl copy];

	return copy;
}
@end
