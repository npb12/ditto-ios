//
//  TFDailyItem.h
//  LocationBasedApplication
//
//  Created by Neil Ballard on 9/24/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface TFDailyItem : NSObject

@property (nullable, nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSString *imageRemoteUrl;
@property (nullable, nonatomic, retain) NSString *subtitle;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *age;
@property (nullable, nonatomic, retain) NSString *education;
@property (nullable, nonatomic, retain) NSString *occupation;
@property (nullable, nonatomic, retain) NSString *bio;

@property (nonatomic) BOOL liked;
@property (nullable, nonatomic, retain) NSString *websiteUrl;
@property (nullable, nonatomic, retain) NSMutableArray *photos;


+ (NSMutableArray*) allDailyItemsWithContext;


@end
