//
//  DDFriendList.m
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

#import "DDFriendList.h"

@implementation DDFriendList
@synthesize friends = _friends;

- (id) initWithFileURL:(NSURL *)url
{
    self = [super initWithFileURL:url];
    if (self)
    {
        _friends = [NSMutableArray array];
    }
    return self;
}

#define kFriendListKeyArray @"array"

- (id) contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:_friends forKey:kFriendListKeyArray];
    
    [archiver finishEncoding];
    return data;
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    NSData *data = (NSData *)contents;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    _friends = [unarchiver decodeObjectForKey:kFriendListKeyArray];
    
    return YES;
}
@end
