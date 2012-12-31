//
//  DDFriendList.m
//  DefensiveUIDocument
//
//  Created by Kevin Hunter on 12/31/12.
//  Copyright (c) 2012 Silver Bay Tech. All rights reserved.
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
