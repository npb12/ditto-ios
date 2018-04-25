//
//  User.m
//  DateApp
//
//  Created by Neil Ballard on 3/11/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "User.h"

@implementation User

+ (void) saveAsCurrentUser:(User*)currentUser
{
    NSDictionary* userDictionary = [currentUser toDictionary];
    
    [[NSUserDefaults standardUserDefaults] setObject:userDictionary forKey:@"::DATINGAPP_SAVED_USER_DATA::"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) removeCurrentUser
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"::DATINGAPP_SAVED_USER_DATA::"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (User*) currentUser
{
    NSDictionary* userDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"::DATINGAPP_SAVED_USER_DATA::"];
    if (userDictionary)
    {
        User* user = [User fromDictionary:userDictionary];
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
    if (self.edu)
        [dictionary setObject:self.edu forKey:@"education"];
    if (self.job)
        [dictionary setObject:self.job forKey:@"work"];
    if (self.bio)
        [dictionary setObject:self.bio forKey:@"bio"];
    if (self.profilePic)
        [dictionary setObject:self.profilePic forKey:@"profilePicture"];
    if ([self.pics count])
        [dictionary setObject:self.pics forKey:@"pics"];
    
    
    return @{ @"user" : dictionary };
}

+ (User*) fromDictionary:(NSDictionary*)dictionary
{
    if (!dictionary)
    {
        return nil;
    }
    
    NSDictionary* userDictionary = [dictionary objectForKey:@"user"];
    if (!userDictionary)
        userDictionary = dictionary;
    
    User* user = [User new];
    
    
    user.user_id = [[userDictionary objectForKey:@"id"] integerValue];
    user.name = [userDictionary objectForKey:@"name"];
    user.age = [userDictionary objectForKey:@"age"];
    user.edu = [userDictionary objectForKey:@"education"];
    user.job = [userDictionary objectForKey:@"work"];
    user.bio = [userDictionary objectForKey:@"bio"];
    user.profilePic = [userDictionary objectForKey:@"profilePicture"];
    user.pics = [userDictionary objectForKey:@"pics"];

    
    return user;
}

@end
