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
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"::DATINGAPP_SAVED_MATCH_DATA::"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[DataAccess singletonInstance] setUserHasMatch:NO];
    [[DataAccess singletonInstance] setUserHasMessages:NO];

    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noMatchNotification" object:nil userInfo:nil];
    });
}

+ (void) updateCurrentMatch:(MatchUser*)currentMatch
{
    NSDictionary* userDictionary = [currentMatch toDictionary];
    
    [[NSUserDefaults standardUserDefaults] setObject:userDictionary forKey:@"::DATINGAPP_SAVED_MATCH_DATA::"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) saveAsCurrentMatch:(MatchUser*)currentMatch
{
    NSDictionary* userDictionary = [currentMatch toDictionary];
    
    [[NSUserDefaults standardUserDefaults] setObject:userDictionary forKey:@"::DATINGAPP_SAVED_MATCH_DATA::"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currentMatchNotification" object:nil userInfo:nil];
    });
}

+ (MatchUser*) currentUser
{
    NSDictionary* userDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"::DATINGAPP_SAVED_MATCH_DATA::"];
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
    if (self.match_time)
        [dictionary setObject:self.match_time forKey:@"timestamp"];
    if ([self.pics count])
        [dictionary setObject:self.pics forKey:@"pics"];
    if (self.distance)
        [dictionary setObject:[NSNumber numberWithDouble: self.distance] forKey:@"distance"];
    
    //messaging
    if (self.lastMessage)
    {
        [dictionary setObject:self.lastMessage.message forKey:@"content"];
        [dictionary setObject:@(self.lastMessage.timestamp) forKey:@"message_timestamp"];
        if (self.lastMessage.type == RECEIVED_MESSAGE)
        {
            [dictionary setObject:@(0) forKey:@"sender_val"];
        }
        else
        {
            [dictionary setObject:@(1) forKey:@"sender_val"];
        }

    }
    
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
    user.match_time = [userDictionary objectForKey:@"timestamp"];
    user.pics = [userDictionary objectForKey:@"pics"];
    NSNumber *distance = [userDictionary objectForKey:@"distance"];
    user.distance = [distance integerValue];
    
    //last message
    Message* message = [Message new];

    long messageTime = [[userDictionary objectForKey:@"message_timestamp"] longValue];
    message.timestamp = messageTime;
    message.message = [userDictionary objectForKey:@"content"];
    NSInteger senderVal = [[userDictionary objectForKey:@"sender_val"] integerValue];
    if (senderVal == 0)
    {
        message.type = RECEIVED_MESSAGE;
    }
    else
    {
        message.type = SENT_MESSAGE;
    }
    
    user.lastMessage = message;

    return user;
}



@end
