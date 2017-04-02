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
+(void)currentMatch:(NSDictionary*)dict;
+(void)alternateMatches:(NSDictionary*)dict;


@end
