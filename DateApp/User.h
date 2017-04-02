//
//  User.h
//  DateApp
//
//  Created by Neil Ballard on 3/11/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *edu;
@property (nullable, nonatomic, retain) NSString *job;
@property (nullable, nonatomic, retain) NSString *bio;
@property (nullable, nonatomic, retain) NSString *age;
@property (nonatomic, assign) NSInteger user_id;
@property (nullable, nonatomic, retain) NSString *imageRemoteUrl;
@property (nullable, nonatomic, retain) NSMutableArray *pics;
-(NSMutableArray*)genData;


@end
