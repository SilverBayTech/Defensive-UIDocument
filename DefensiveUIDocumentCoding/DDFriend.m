//
//  DDFriend.m
//  DefensiveUIDocument
//
//  Created by Kevin Hunter on 12/31/12.
//  Copyright (c) 2012 Silver Bay Tech. All rights reserved.
//

#import "DDFriend.h"

@implementation DDFriend
@synthesize name = _name;
@synthesize birthdate = _birthdate;

#define kFriendKeyName      @"name"
#define kFriendKeyBirthdate @"birthdate"

- (id) initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self)
    {
        _name = [decoder decodeObjectForKey:kFriendKeyName];
        _birthdate = [decoder decodeObjectForKey:kFriendKeyBirthdate];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:kFriendKeyName];
    [encoder encodeObject:self.birthdate forKey:kFriendKeyBirthdate];
}

@end
