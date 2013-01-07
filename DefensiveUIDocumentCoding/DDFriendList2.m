//
//  DDFriendList2.m
//  DefensiveUIDocumentCoding
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

#import "DDFriendList2.h"

@implementation DDFriendList2
@synthesize friends = _friends;
@synthesize loadResult = _loadResult;

- (id) initWithFileURL:(NSURL *)url
{
    self = [super initWithFileURL:url];
    if (self)
    {
        _friends = [NSMutableArray array];
    }
    return self;
}

#define kFriendListKeyVersion   @"version"
#define kFriendListKeyArray     @"array"

#define kFriendListCurrentVersion   1

- (id) contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeInt:kFriendListCurrentVersion forKey:kFriendListKeyVersion];
    [archiver encodeObject:_friends forKey:kFriendListKeyArray];
    
    [archiver finishEncoding];
    return data;
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    NSData *data = (NSData *)contents;
    
    if ([data length] == 0)
    {
        _loadResult = DDFLLR_ZERO_LENGTH_FILE;
        return NO;
    }
    
    @try 
    {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        int version = [unarchiver decodeIntForKey:kFriendListKeyVersion];
        switch(version)
        {
            case kFriendListCurrentVersion:
                _friends = [unarchiver decodeObjectForKey:kFriendListKeyArray];
                break;
                
            default:
                _loadResult = DDFLLR_UNEXPECTED_VERSION;
                return NO;
        }
    }
    @catch (NSException *exception) 
    {
        NSLog(@"%@ exception: %@", NSStringFromSelector(_cmd), exception);
        _loadResult = DDFLLR_CORRUPT_FILE;
        return NO;
    }
    
    _loadResult = DDFLLR_SUCCESS;
    return YES;
}

- (void) openWithCompletionHandler:(void (^)(BOOL))completionHandler
{
    _loadResult = DDFLLR_NO_SUCH_FILE;
    [super openWithCompletionHandler:completionHandler];
}
@end
