//
//  DASocket.m
//  DateApp
//
//  Created by Neil Ballard on 4/2/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "DASocket.h"

@implementation DASocket

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        [self initSocketIO];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static DASocket *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    });
    sharedInstance = [[DASocket alloc] init];
    return sharedInstance;
}

-(void)initSocketIO
{
    NSURL* url = [[NSURL alloc] initWithString:@"http://portaldevservices.com:8080"];
    //NSURL* url = [[NSURL alloc] initWithString:@"http://54.174.235.42:8080"];
    self.socket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"forcePolling": @YES}];
    
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
        
        NSInteger uid = [[[DataAccess singletonInstance] getUserID] integerValue];
        NSArray *arr = @[@(uid)];
        [self.socket emit:@"user_id" with:arr];
    }];
    
    [self.socket on:@"message" callback:^(NSArray* data, SocketAckEmitter* ack) {
       // double cur = [[data objectAtIndex:0] floatValue];
      //  NSArray *messageComponents = [data[0] componentsSeparatedByString:@"|"];
        
        NSString *full_message = data[0];
        
        [self parseMessageRecieved:full_message];

        /*
        [[self.socket emitWithAck:@"canUpdate" with:@[@(cur)]] timingOutAfter:0 callback:^(NSArray* data) {
            [self.socket emit:@"update" with:@[@{@"amount": @(cur + 2.50)}]];
        }];
        
        
        [ack with:@[@"Got your currentAmount, ", @"dude"]]; */
    }];
    
    [self.socket connect];
}

-(void)disconnectSocket
{
    [self.socket disconnect];

}


-(void)sendMessage:(NSString*)message
{
    NSArray *arr = @[message];
    [self.socket emit:@"message" with:arr];
}


-(void)parseMessageRecieved:(NSString*)formattedMessage
{
    
    NSArray *items = [formattedMessage componentsSeparatedByString:@"|"];
    
    NSString *message, *timestamp;
    
    if ([items count] > 2)
    {
        NSMutableString * result = [[NSMutableString alloc] init];
        NSArray *messageArray = [items subarrayWithRange:NSMakeRange(0,[items count] - 1)];
        for (NSString * obj in messageArray)
        {
            [result appendString:[obj description]];
        }
        
        message = result;
        
        timestamp = [items lastObject];
    }
    else
    {
        message=[items objectAtIndex:0];
        timestamp=[items objectAtIndex:1];
    }
    
    Messages *message_received = [Messages new];
    
    message_received.timestamp = [timestamp longLongValue];
    message_received.message = message;
    message_received.type = RECEIVED_MESSAGE;
    
    NSDictionary* userInfo = @{@"new_message": message_received};
    
    NSLog(@"user info %@", userInfo);

    [[NSNotificationCenter defaultCenter] postNotificationName:@"newMessageReceived" object:nil userInfo:userInfo];

}



@end
