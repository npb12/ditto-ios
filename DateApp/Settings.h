//
//  Settings.h
//  DateApp
//
//  Created by Neil Ballard on 4/3/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

+ (void) saveAsCurrentSettings:(Settings*)currentSettings;
+ (Settings*) currentSettings;
- (NSDictionary*) toDictionary;
+ (Settings*) fromDictionary:(NSDictionary*)dictionary;

@property (nullable, nonatomic, retain) NSString *ageRange;
@property (nullable, nonatomic, retain) NSString *settingsGender;
@property (nonatomic, assign) NSInteger settingsInvisible;
@property (nonatomic, assign) NSInteger settingsNotifications;
@property (nonatomic, assign) NSInteger settingsDistance;


@end
