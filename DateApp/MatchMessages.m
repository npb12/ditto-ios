//
//  MatchMessages.m
//  DateApp
//
//  Created by Neil Ballard on 5/18/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

#import "MatchMessages.h"

@implementation MatchMessages

+ (void) removeLastMessage
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"::DATINGAPP_SAVED_MESSAGE_DATA::"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[DataAccess singletonInstance] setUserHasMessages:NO];
}


+ (void) saveAsLastMessage:(MatchMessages*)lastMessage
{
    NSDictionary* userDictionary = [lastMessage toDictionary];
    
    [[NSUserDefaults standardUserDefaults] setObject:userDictionary forKey:@"::DATINGAPP_SAVED_MESSAGE_DATA::"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (MatchMessages*) lastMessage
{
    NSDictionary* messageDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"::DATINGAPP_SAVED_MESSAGE_DATA::"];
    if (messageDictionary)
    {
        MatchMessages* message = [MatchMessages fromDictionary:messageDictionary];
        if (message.lastMessage)
        {
            return message;
        }
    }
    
    return nil;
}

- (NSDictionary*) toDictionary
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];

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
        
        [dictionary setObject:[NSNumber numberWithBool:self.lastMessage.unread] forKey:@"unread"];

    }
    
    return @{ @"message" : dictionary };
}

+ (MatchMessages*) fromDictionary:(NSDictionary*)dictionary
{
    if (!dictionary)
    {
        return nil;
    }
    
    NSDictionary* userDictionary = [dictionary objectForKey:@"message"];
    if (!userDictionary)
        userDictionary = dictionary;
    
    //last message
    Message* message = [Message new];
    
    long messageTime = [[userDictionary objectForKey:@"message_timestamp"] longValue];
    message.timestamp = messageTime;
    message.message = [userDictionary objectForKey:@"content"];
    NSInteger senderVal = [[userDictionary objectForKey:@"sender_val"] integerValue];
    message.unread = [[userDictionary objectForKey:@"unread"] boolValue];
    if (senderVal == 0)
    {
        message.type = RECEIVED_MESSAGE;
    }
    else
    {
        message.type = SENT_MESSAGE;
    }
    
    if (message)
    {
        MatchMessages* matchMessage = [MatchMessages new];
        matchMessage.lastMessage = message;
        return matchMessage;
    }
    
    
    return nil;
}

@end
