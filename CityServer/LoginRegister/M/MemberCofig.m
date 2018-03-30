//
//	MemberCofig.m
//
//	Create by 文清 陈 on 22/12/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "MemberCofig.h"

NSString *const kMemberCofigLoginName = @"loginName";
NSString *const kMemberCofigToken = @"token";
NSString *const kMemberCofigUserId = @"userId";
NSString *const kMemberCofigUserName = @"userName";
NSString *const kRootClassPayStatus = @"payStatus";
NSString *const kRootClassLatitude = @"latitude";
NSString *const kRootClassLongitude = @"longitude";
NSString *const kRootClassRongyunId = @"rongyunId";
NSString *const kRootClassRongyunToken = @"rongyunToken";
NSString *const kRootClassAvatarPath = @"avatarPath";

@interface MemberCofig ()
@end
@implementation MemberCofig

static MemberCofig* _instance = nil;

+(instancetype)shareInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    }) ;
    
    return _instance ;
}


/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(void)updateWithDictionary:(NSDictionary *)dictionary
{
	if(![dictionary[kMemberCofigLoginName] isKindOfClass:[NSNull class]]){
		self.loginName = dictionary[kMemberCofigLoginName];
	}	
	if(![dictionary[kMemberCofigToken] isKindOfClass:[NSNull class]]){
		self.token = dictionary[kMemberCofigToken];
	}	
	if(![dictionary[kMemberCofigUserId] isKindOfClass:[NSNull class]]){
		self.userId = dictionary[kMemberCofigUserId];
	}	
	if(![dictionary[kMemberCofigUserName] isKindOfClass:[NSNull class]]){
		self.userName = dictionary[kMemberCofigUserName];
	}
    if(![dictionary[kRootClassPayStatus] isKindOfClass:[NSNull class]]){
        self.payStatus = [dictionary[kRootClassPayStatus] integerValue];
    }
    if(![dictionary[kRootClassLatitude] isKindOfClass:[NSNull class]]){
        self.latitude = dictionary[kRootClassLatitude];
    }
    if(![dictionary[kRootClassLongitude] isKindOfClass:[NSNull class]]){
        self.longitude = dictionary[kRootClassLongitude];
    }
    if(![dictionary[kRootClassRongyunId] isKindOfClass:[NSNull class]]){
        self.rongyunId = dictionary[kRootClassRongyunId];
    }
    if(![dictionary[kRootClassRongyunToken] isKindOfClass:[NSNull class]]){
        self.rongyunToken = dictionary[kRootClassRongyunToken];
    }
    if(![dictionary[kRootClassAvatarPath] isKindOfClass:[NSNull class]]){
        self.avatarPath = dictionary[kRootClassAvatarPath];
    }
	[ProjectConfig SetValue:dictionary forKey:@"MemberCofig"];
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.loginName != nil){
		dictionary[kMemberCofigLoginName] = self.loginName;
	}
	if(self.token != nil){
		dictionary[kMemberCofigToken] = self.token;
	}
	if(self.userId != nil){
		dictionary[kMemberCofigUserId] = self.userId;
	}
	if(self.userName != nil){
		dictionary[kMemberCofigUserName] = self.userName;
	}
    if(self.latitude != nil){
        dictionary[kRootClassLatitude] = self.latitude;
    }
    if(self.longitude != nil){
        dictionary[kRootClassLongitude] = self.longitude;
    }
    if(self.rongyunId != nil){
        dictionary[kRootClassRongyunId] = self.rongyunId;
    }
    if(self.rongyunToken != nil){
        dictionary[kRootClassRongyunToken] = self.rongyunToken;
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
	if(self.loginName != nil){
		[aCoder encodeObject:self.loginName forKey:kMemberCofigLoginName];
	}
	if(self.token != nil){
		[aCoder encodeObject:self.token forKey:kMemberCofigToken];
	}
	if(self.userId != nil){
		[aCoder encodeObject:self.userId forKey:kMemberCofigUserId];
	}
	if(self.userName != nil){
		[aCoder encodeObject:self.userName forKey:kMemberCofigUserName];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.loginName = [aDecoder decodeObjectForKey:kMemberCofigLoginName];
	self.token = [aDecoder decodeObjectForKey:kMemberCofigToken];
	self.userId = [aDecoder decodeObjectForKey:kMemberCofigUserId];
	self.userName = [aDecoder decodeObjectForKey:kMemberCofigUserName];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	MemberCofig *copy = [MemberCofig new];

	copy.loginName = [self.loginName copy];
	copy.token = [self.token copy];
	copy.userId = [self.userId copy];
	copy.userName = [self.userName copy];

	return copy;
}
@end
