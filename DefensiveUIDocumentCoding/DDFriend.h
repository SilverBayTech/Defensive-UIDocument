//
//  DDFriend.h
//  DefensiveUIDocument
//
//  Created by Kevin Hunter on 12/31/12.
//  Copyright (c) 2012 Silver Bay Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDFriend : NSObject<NSCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *birthdate;
@end
