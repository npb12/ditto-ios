//
//  DAParser.m
//  DateApp
//
//  Created by Neil Ballard on 3/31/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "DAParser.h"

@implementation DAParser


+(NSMutableArray*)nearbyUsers:(NSDictionary*)dict
{
    NSMutableArray *nearby_users = [NSMutableArray new];
    
    for(id key in dict)
    {
        User *user = [User new];
        
        user.user_id = [[key objectForKey:@"id"] integerValue];
        
       // user.name = [key objectForKey:@"fb_firstname"];
        user.name = [key objectForKey:@"name"];
        user.age = [NSString stringWithFormat: @"%ld", [[key objectForKey:@"age"] integerValue]];
        user.edu = [key objectForKey:@"education"];
        user.job = [key objectForKey:@"work"];
        user.bio = [key objectForKey:@"bio"];


        [nearby_users addObject:user];
    }
    
    return nearby_users;
}

+(void)alternateMatches:(NSDictionary*)dict
{
    NSMutableArray *matches = [NSMutableArray new];
    
    
    NSLog(@"%@", dict);
    
    /*
    for(id key in dict)
    {
        User *user = [User new];
        
        user.user_id = [[key objectForKey:@"id"] integerValue];
        
        // user.name = [key objectForKey:@"fb_firstname"];
        user.name = [key objectForKey:@"name"];
        user.age = [NSString stringWithFormat: @"%ld", [[key objectForKey:@"age"] integerValue]];
        user.edu = [key objectForKey:@"education"];
        user.job = [key objectForKey:@"work"];
        user.bio = [key objectForKey:@"bio"];
        
        
        [matches addObject:user];
    }
    
    if ([matches count] > 0)
    {
        //send nsnotification to rootvc
        //pass x users
        //loop to put up x # of popups up
        //method to clear all popups (drop all - doing this will dismiss all your matches)
    } */

}

+(void)currentMatch:(NSDictionary*)dict
{
    MatchUser *user = [MatchUser new];
    
    user.user_id = [[dict objectForKey:@"id"] integerValue];
    
    user.name = [dict objectForKey:@"fb_firstname"];
    user.age = [NSString stringWithFormat: @"%ld", [[dict objectForKey:@"age"] integerValue]];
    user.education = [dict objectForKey:@"education"];
    user.work = [dict objectForKey:@"work"];
    user.bio = [dict objectForKey:@"bio"];
    
    [MatchUser saveAsCurrentMatch:user];
    
}

@end
