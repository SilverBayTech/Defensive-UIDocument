//
//  DDFriend.m
//  DefensiveUIDocument
//
//  Created by Kevin Hunter on 12/31/12.
//
//  Copyright 2012 Kevin Hunter
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
