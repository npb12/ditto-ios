//
//  DADateFormatter.h
//  DateApp
//
//  Created by Neil Ballard on 4/18/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DADateFormatter : NSObject

+ (NSString *)timeAgoStringFromDate:(NSDate*)match_time;

+ (NSString *)timeAgoFromDate:(NSDate*)date;

@end
