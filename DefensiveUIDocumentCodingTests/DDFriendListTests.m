//
//  DDFriendListTests.m
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

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import "DDFriendList.h"
#import "DDFriend.h"

@interface DDFriendListTests : SenTestCase
@end

#define kUnitTestFileName   @"DDFriendListTest.dat"

@implementation DDFriendListTests
{
    NSFileManager   * _fileManager;
    NSString        * _unitTestFilePath;
    NSURL           * _unitTestFileUrl;
    BOOL              _blockCalled;
}

- (void)setUp
{
    [super setUp];
    
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirs objectAtIndex:0];
    
    _unitTestFilePath = [docsDir stringByAppendingPathComponent:kUnitTestFileName];
    _unitTestFileUrl = [NSURL fileURLWithPath:_unitTestFilePath];
    
    _fileManager = [NSFileManager defaultManager];
    [_fileManager removeItemAtURL:_unitTestFileUrl error:NULL];
    
    _blockCalled = NO;
}

- (void) blockCalled
{
    _blockCalled = YES;
}

- (BOOL) blockCalledWithin:(NSTimeInterval)timeout
{
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:timeout];
    while (!_blockCalled && [loopUntil timeIntervalSinceNow] > 0)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }
    
    BOOL retval = _blockCalled;
    _blockCalled = NO;  // so ready for next time
    return retval;
}

- (void)testSavingCreatesFile
{
    // given that we have an instance of our document
    DDFriendList * objUnderTest = [[DDFriendList alloc] initWithFileURL:_unitTestFileUrl];
    
    // when we call saveToURL:forSaveOperation:completionHandler:
    __block BOOL blockSuccess = NO;
    
    [objUnderTest saveToURL:_unitTestFileUrl
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:
            ^(BOOL success)
            {
                blockSuccess = success;
                [self blockCalled];
            }
     ];
    
    STAssertTrue([self blockCalledWithin:10], nil);
    
    // then the operation should succeed and a file should be created
    STAssertTrue(blockSuccess, nil);
    STAssertTrue([_fileManager fileExistsAtPath:_unitTestFilePath], nil);
}

- (void) testLoadingRetrievesData
{
    // given that we have saved the data from an instance of our class
    NSDate *birthdate = [NSDate date];
    DDFriend *friend = [[DDFriend alloc] init];
    friend.name = @"Me";
    friend.birthdate = birthdate;
    
    DDFriendList * document = [[DDFriendList alloc] initWithFileURL:_unitTestFileUrl];
    [document.friends addObject:friend];
    
    __block BOOL blockSuccess = NO;
    
    [document saveToURL:_unitTestFileUrl
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:
             ^(BOOL success)
             {
                 blockSuccess = success;
                 [self blockCalled];
             }
     ];
    
    STAssertTrue([self blockCalledWithin:10], nil);
    STAssertTrue(blockSuccess, nil);
    
    [document closeWithCompletionHandler:
         ^(BOOL success)
         {
             blockSuccess = success;
             [self blockCalled];
         }
     ];
    
    STAssertTrue([self blockCalledWithin:10], nil);
    STAssertTrue(blockSuccess, nil);
    
    // when we load a new document from that file
    DDFriendList * objUnderTest = [[DDFriendList alloc] initWithFileURL:_unitTestFileUrl];
    [objUnderTest openWithCompletionHandler:
         ^(BOOL success)
         {
             blockSuccess = success;
             [self blockCalled];
         }
     ];
    
    // the data should load successfully and be what we saved
    
    STAssertTrue([self blockCalledWithin:10], nil);
    STAssertTrue(blockSuccess, nil);
    
    NSArray * friends = objUnderTest.friends;
    STAssertEquals([friends count], (NSUInteger)1, nil);
    DDFriend *restoredFriend = [friends objectAtIndex:0];
    STAssertEqualObjects(restoredFriend.name, @"Me", nil);
    STAssertEqualObjects(restoredFriend.birthdate, birthdate, nil);
}

@end
