//
//  User.h
//  DateApp
//
//  Created by Neil Ballard on 3/11/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *edu;
@property (nullable, nonatomic, retain) NSString *job;
@property (nullable, nonatomic, retain) NSString *bio;
@property (nullable, nonatomic, retain) NSString *age;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nonatomic, assign) NSInteger user_id;
@property (nullable, nonatomic, retain) NSString *imageRemoteUrl;
@property (nullable, nonatomic, retain) NSString *profilePic;
@property (nullable, nonatomic, retain) NSMutableArray *pics;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, strong) UIImage *profileImage;


-(NSMutableArray*)genData;

+ (void) saveAsCurrentUser:(User*)currentUser;
+ (User*) currentUser;
- (NSDictionary*) toDictionary;
+ (User*) fromDictionary:(NSDictionary*)dictionary;
+ (void) removeCurrentUser;


#pragma USER SETTINGS
@property (nullable, nonatomic, retain) NSString *ageRange;
@property (nullable, nonatomic, retain) NSString *settingsGender;
@property (nonatomic, assign) NSInteger settingsInvisible;
@property (nonatomic, assign) NSInteger settingsNotifications;
@property (nonatomic, assign) NSInteger settingsDistance;
@property (nonatomic, assign) NSInteger ageMin;
@property (nonatomic, assign) NSInteger ageMax;

@end
