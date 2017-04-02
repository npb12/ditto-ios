//
//  MatchUser.m
//  DateApp
//
//  Created by Neil Ballard on 3/31/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "MatchUser.h"

@implementation MatchUser

+ (void) removeCurrentMatch
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"::DATINGAPP_SAVED_USER_DATA::"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) saveAsCurrentMatch:(MatchUser*)currentMatch
{
    NSDictionary* userDictionary = [currentMatch toDictionary];
    
    [[NSUserDefaults standardUserDefaults] setObject:userDictionary forKey:@"::DATINGAPP_SAVED_USER_DATA::"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (MatchUser*) currentUser
{
    NSDictionary* userDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"::DATINGAPP_SAVED_USER_DATA::"];
    if (userDictionary)
    {
        MatchUser* user = [MatchUser fromDictionary:userDictionary];
        if (user.user_id)
        {
            return user;
        }
    }
    
    return nil;
}

- (NSDictionary*) toDictionary
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    if (self.user_id)
    {
        NSString *userid = [NSString stringWithFormat:@"%ld", (long)self.user_id];
        [dictionary setObject:userid forKey:@"id"];
    }
    if (self.name)
        [dictionary setObject:self.name forKey:@"name"];
    if (self.age)
        [dictionary setObject:self.age forKey:@"age"];
    if (self.education)
        [dictionary setObject:self.education forKey:@"education"];
    if (self.work)
        [dictionary setObject:self.work forKey:@"work"];
    if (self.bio)
        [dictionary setObject:self.bio forKey:@"bio"];
    
    
    return @{ @"match" : dictionary };
}

+ (MatchUser*) fromDictionary:(NSDictionary*)dictionary
{
    if (!dictionary)
    {
        return nil;
    }
    
    NSDictionary* userDictionary = [dictionary objectForKey:@"match"];
    if (!userDictionary)
        userDictionary = dictionary;
    
    MatchUser* user = [MatchUser new];
    
    
    user.user_id = [[userDictionary objectForKey:@"id"] integerValue];
    user.name = [userDictionary objectForKey:@"name"];
    user.age = [userDictionary objectForKey:@"age"];
    user.education = [userDictionary objectForKey:@"education"];
    user.work = [userDictionary objectForKey:@"work"];
    user.bio = [userDictionary objectForKey:@"bio"];


    return user;
}

@end
