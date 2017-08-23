//
//  DAParser.h
//  DateApp
//
//  Created by Neil Ballard on 3/31/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface DAParser : NSObject

+(NSMutableArray*)nearbyUsers:(NSDictionary*)dict;
+(void)currentMatch:(NSDictionary*)dict notif:(BOOL)notification;
+(void)alternateMatches:(NSDictionary*)dict;
+(User*)myprofile:(NSDictionary*)dict;
+(User*)mysettings:(NSDictionary*)dict;
+(NSArray*)messages:(NSDictionary*)recieved_dict sent:(NSDictionary*)sent_dict;
+(bool)messageNew:(NSDictionary*)recieved_dict sent:(NSDictionary*)sent_dict;
@end
