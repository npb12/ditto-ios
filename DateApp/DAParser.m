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
    
    NSLog(@"nearby users:: %@", dict);
    
    
    for(id key in dict)
    {
        User *user = [User new];
        
        user.user_id = [[key objectForKey:@"id"] integerValue];
        
       // user.name = [key objectForKey:@"fb_firstname"];
        user.name = [key objectForKey:@"first_name"];
        user.age = [NSString stringWithFormat: @"%ld", [[key objectForKey:@"age"] integerValue]];

        NSString *edu = [key objectForKey:@"education"];
        
        if (edu == nil || [DAParser nsnullCheck:edu])
        {
            edu = @"";
        }
        user.edu = edu;
        
        NSString *job = [key objectForKey:@"occupation"];
        
        if (job == nil || [DAParser nsnullCheck:job])
        {
            job = @"";
        }
        user.job = job;
        
        NSString *bio = [key objectForKey:@"bio"];
        
        if (bio == nil || [DAParser nsnullCheck:bio])
        {
            bio = @"";
        }
        user.bio = bio;
        
        user.distance = [[key objectForKey:@"distance"] integerValue];
        
        
        user.pics = [NSMutableArray new];
        
        NSString *pic1 = [key objectForKey:@"pic1"];
        [user.pics addObject:pic1];
        
        NSString *pic2 = [key objectForKey:@"pic2"];
        
        if (![pic2 isEqualToString:@""])
        {
            [user.pics addObject:pic2];
            
            NSString *pic3 = [key objectForKey:@"pic3"];
            if (![pic3 isEqualToString:@""])
            {
                [user.pics addObject:pic3];
                
                NSString *pic4 = [key objectForKey:@"pic4"];
                if (![pic4 isEqualToString:@""])
                {
                    [user.pics addObject:pic4];
                    
                    NSString *pic5 = [key objectForKey:@"pic5"];
                    if (![pic5 isEqualToString:@""])
                    {
                        [user.pics addObject:pic5];
                    }
                }
            }
            
        }

        [nearby_users addObject:user];
    }
    
    return nearby_users;
}

+(void)alternateMatches:(NSDictionary*)dict
{
    NSMutableArray *matches = [NSMutableArray new];
    
    
    NSLog(@"alternate matches::: %@", dict);
    
    
    for(id key in dict)
    {
        User *user = [User new];
        
        user.user_id = [[key objectForKey:@"id"] integerValue];
        
        // user.name = [key objectForKey:@"fb_firstname"];
        user.name = [key objectForKey:@"first_name"];
        user.age = [NSString stringWithFormat: @"%d", [[key objectForKey:@"age"] integerValue]];
        NSString *edu = [key objectForKey:@"education"];
        
        
        
        if (edu == nil || [DAParser nsnullCheck:edu])
        {
            edu = @"";
        }
        user.edu = edu;
        
        NSString *job = [key objectForKey:@"work"];
        
        if (job == nil || [DAParser nsnullCheck:job])
        {
            job = @"";
        }
        user.job = job;
        
        NSString *bio = [key objectForKey:@"bio"];
        
        if (bio == nil || [DAParser nsnullCheck:bio])
        {
            bio = @"";
        }
        user.bio = bio;
        
        user.distance = [[key objectForKey:@"distance"] integerValue];
        
        user.pics = [NSMutableArray new];
        
        NSString *pic1 = [key objectForKey:@"pic1"];
        [user.pics addObject:pic1];
        
        NSString *pic2 = [key objectForKey:@"pic2"];
        
        if (![pic2 isEqualToString:@""])
        {
            [user.pics addObject:pic2];
            
            NSString *pic3 = [key objectForKey:@"pic3"];
            if (![pic3 isEqualToString:@""])
            {
                [user.pics addObject:pic3];
                
                NSString *pic4 = [key objectForKey:@"pic4"];
                if (![pic4 isEqualToString:@""])
                {
                    [user.pics addObject:pic4];
                    
                    NSString *pic5 = [key objectForKey:@"pic5"];
                    if (![pic5 isEqualToString:@""])
                    {
                        [user.pics addObject:pic5];
                    }
                }
            }
            
        }
        
        
        [matches addObject:user];
    }
    
     
    if ([matches count] > 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([matches count] > 0)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"altMatchesNotification" object:matches userInfo:nil];
            }
        });

    }

}

+(void)currentMatch:(NSDictionary*)dict notif:(BOOL)notification
{
    
    
    MatchUser *user = [MatchUser new];

    user.user_id = [[dict objectForKey:@"id"] integerValue];
    
    user.name = [dict objectForKey:@"first_name"];
    user.age = [NSString stringWithFormat: @"%ld", [[dict objectForKey:@"age"] integerValue]];
    
    NSString *edu = [dict objectForKey:@"education"];
    
    user.distance = [[dict objectForKey:@"distance"] integerValue];

    
    if (edu == nil || [DAParser nsnullCheck:edu])
    {
        edu = @"";
    }
    user.education = edu;
    
    NSString *job = [dict objectForKey:@"work"];
    
    if (job == nil || [DAParser nsnullCheck:job])
    {
        job = @"";
    }
    user.work = job;
    
    NSString *bio = [dict objectForKey:@"bio"];
    
    if (bio == nil || [DAParser nsnullCheck:bio])
    {
        bio = @"";
    }
    user.bio = bio;
    
    
    NSString *dateStr = [dict objectForKey:@"date_matched"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
    
    user.match_time = [dateFormat dateFromString:dateStr];
    
    user.pics = [NSMutableArray new];
    
    NSString *pic1 = [dict objectForKey:@"pic1"];
    
    if (![pic1 isEqualToString:@""])
    {
        [user.pics addObject:pic1];
    
        NSString *pic2 = [dict objectForKey:@"pic2"];
    
        if (![pic2 isEqualToString:@""])
        {
            [user.pics addObject:pic2];
            
            NSString *pic3 = [dict objectForKey:@"pic3"];
            if (![pic3 isEqualToString:@""])
            {
                [user.pics addObject:pic3];
                
                NSString *pic4 = [dict objectForKey:@"pic4"];
                if (![pic4 isEqualToString:@""])
                {
                    [user.pics addObject:pic4];
                    
                    NSString *pic5 = [dict objectForKey:@"pic5"];
                    if (![pic5 isEqualToString:@""])
                    {
                        [user.pics addObject:pic5];
                    }
                }
            }
            
        }
        
    }
    

    [[DataAccess singletonInstance] setUserHasMatch:YES];
    
    
    [MatchUser saveAsCurrentMatch:user];
    
    if (notification)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (user)
            {
                NSDictionary *dictionary = [NSDictionary dictionaryWithObject:user forKey:@"Match"];

                [[NSNotificationCenter defaultCenter] postNotificationName:@"altMatchesNotification" object:nil userInfo:dictionary];
            }
        });
    }
    
    
}

+(User*)myprofile:(NSDictionary*)dict
{
    User *user = [User new];
    
  //  NSLog(@"%@", dict);
    
    user.user_id = [[dict objectForKey:@"id"] integerValue];
    
    user.name = [dict objectForKey:@"first_name"];
    
    user.age = [NSString stringWithFormat: @"%ld", [[dict objectForKey:@"age"] integerValue]];

    NSString *edu = [dict objectForKey:@"education"];
    
    if (edu == nil || [DAParser nsnullCheck:edu])
    {
        edu = @"";
    }
    user.edu = edu;
    
    NSString *job = [dict objectForKey:@"occupation"];
    
    if (job == nil || [DAParser nsnullCheck:job])
    {
        job = @"";
    }
    user.job = job;
    
    NSString *bio = [dict objectForKey:@"bio"];
    
    if (bio == nil || [DAParser nsnullCheck:bio])
    {
        bio = @"";
    }
    user.bio = bio;
    
    user.pics = [NSMutableArray new];
    
    NSString *pic1 = [dict objectForKey:@"pic1"];
    
    if (![pic1 isEqualToString:@""] && pic1)
    {
        [user.pics addObject:pic1];
        user.profilePic = pic1;
    }

    
    NSString *pic2 = [dict objectForKey:@"pic2"];
    
    if (![pic2 isEqualToString:@""] && pic2)
    {
        [user.pics addObject:pic2];
        
        NSString *pic3 = [dict objectForKey:@"pic3"];
        if (![pic3 isEqualToString:@""] && pic3)
        {
            [user.pics addObject:pic3];
   
            NSString *pic4 = [dict objectForKey:@"pic4"];
            if (![pic4 isEqualToString:@""] && pic4)
            {
                [user.pics addObject:pic4];
                
                NSString *pic5 = [dict objectForKey:@"pic5"];
                if (![pic5 isEqualToString:@""] && pic5)
                {
                    [user.pics addObject:pic5];
                }
            }
        }
        
    }
    
    [DAParser mysettings:dict usr:user];
    
    [User saveAsCurrentUser:user];
    
    return user;
    
}


+(void)mysettings:(NSDictionary*)dict usr:(User*)settings
{
    settings.ageMin = [[dict objectForKey:@"pref_min_age"] integerValue];
    settings.ageMax = [[dict objectForKey:@"pref_max_age"] integerValue];
    settings.settingsGender = [dict objectForKey:@"pref_gender"];
  //  settings.settingsInvisible = [[dict objectForKey:@"invisible"] integerValue];
    settings.settingsDistance = [[dict objectForKey:@"pref_distance"] integerValue];
    settings.settingsNotifications = [[dict objectForKey:@"receive_notifications"] integerValue];
}


+(NSArray*)messages:(NSDictionary*)messages_dict
{
    
    NSMutableArray *conversation = [NSMutableArray new];
    NSString *uid = [[DataAccess singletonInstance] getUserID];

    for(id key in messages_dict)
    {
        Message *message = [Message new];
        NSString *formattedTime = [key objectForKey:@"date_stamp"];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss.SSS"];
        NSDate *myDate = [df dateFromString: formattedTime];
        message.timestamp = [myDate timeIntervalSince1970];
       // message.timestamp = [[key objectForKey:@"date_stamp"] floatValue];
        message.message = [key objectForKey:@"message"];
        NSInteger intVal = [[key objectForKey:@"from_user"] integerValue];
        NSString *fromUser = [NSString stringWithFormat:@"%ld", (long)intVal];
        if ([uid isEqualToString:fromUser])
        {
            message.type = SENT_MESSAGE;
        }
        else
        {
            message.type = RECEIVED_MESSAGE;

        }
        
        [conversation addObject:message];
    }
    
    if ([conversation count] > 0)
    {
        [DAParser setLastMessage:[conversation lastObject]];
    }
    
    return conversation;
}

+(void)setLastMessage:(Message*)message
{
    MatchUser *matchUser = [MatchUser currentUser];
    matchUser.lastMessage = message;
    [MatchUser updateCurrentMatch:matchUser];
}

+(bool)messageNew:(NSDictionary*)recieved_dict sent:(NSDictionary*)sent_dict
{
    
    NSMutableArray *conversation = [NSMutableArray new];
    long curr = 0;
    long last = [[DataAccess singletonInstance] getLastMessage];
    
    for(id key in sent_dict)
    {
        Message *message = [Message new];
        message.timestamp = [[key objectForKey:@"time_stamp"] floatValue];
        message.message = [key objectForKey:@"content"];
        message.type = SENT_MESSAGE;
        [conversation addObject:message];
    }
    
    for(id key in recieved_dict)
    {
        Message *message = [Message new];
        message.timestamp = [[key objectForKey:@"time_stamp"] floatValue];
        message.message = [key objectForKey:@"content"];
        message.type = RECEIVED_MESSAGE;
        [conversation addObject:message];
        
        if (message.timestamp > curr)
        {
            curr = message.timestamp;
        }
    }
    
    
    return curr > last;
    
}


+(BOOL)nsnullCheck:(NSString*)string
{
    return string == (NSString*)[NSNull null];
}


@end
