//
//  DDFriendListTests.m
//  DefensiveUIDocument
//
//  Created by Kevin Hunter on 12/31/12.
//  Copyright (c) 2012 Silver Bay Tech. All rights reserved.
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

- (void) assertBlockCalledWithin:(NSTimeInterval)timeout
{
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:timeout];
    while (!_blockCalled && [loopUntil timeIntervalSinceNow] > 0)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }
    
    STAssertTrue(_blockCalled, nil);
    _blockCalled = NO;  // so ready for next time
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
    
    [self assertBlockCalledWithin:10];
    
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
    
    [self assertBlockCalledWithin:10];
    STAssertTrue(blockSuccess, nil);
    
    [document closeWithCompletionHandler:
         ^(BOOL success)
         {
             blockSuccess = success;
             [self blockCalled];
         }
     ];
    
    [self assertBlockCalledWithin:10];
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
    
    [self assertBlockCalledWithin:10];
    STAssertTrue(blockSuccess, nil);
    
    NSArray * friends = objUnderTest.friends;
    STAssertEquals([friends count], (NSUInteger)1, nil);
    DDFriend *restoredFriend = [friends objectAtIndex:0];
    STAssertEqualObjects(restoredFriend.name, @"Me", nil);
    STAssertEqualObjects(restoredFriend.birthdate, birthdate, nil);
}

@end
