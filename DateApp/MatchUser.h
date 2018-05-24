//
//  MatchUser.h
//  DateApp
//
//  Created by Neil Ballard on 3/31/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataAccess.h"
#import "MatchMessages.h"


@interface MatchUser : NSObject

+ (MatchUser*) fromDictionary:(NSDictionary*)dictionary;
+ (MatchUser*) currentUser;
- (NSDictionary*) toDictionary;
+ (void) saveAsCurrentMatch:(MatchUser*)currentMatch;
+ (void) removeCurrentMatch;

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *education;
@property (nullable, nonatomic, retain) NSString *work;
@property (nullable, nonatomic, retain) NSString *bio;
@property (nullable, nonatomic, retain) NSString *age;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSDate *match_time;
@property (nullable, nonatomic, retain) NSMutableArray *pics;
@property (nonatomic, strong) UIImage *profileImage;

@end
