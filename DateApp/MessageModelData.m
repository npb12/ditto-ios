//
//  MessageModelData.m
//  DateApp
//
//  Created by Neil Ballard on 1/16/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "MessageModelData.h"

#import "NSUserDefaults+DemoSettings.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MessageModelData



- (id)initWithMessages:(NSArray*)messages type:(NSInteger)type
{
    
    if ((self = [super init]))
    {
        
        UIImage *my_image = [UIImage imageNamed:@"my_image"];
        UIImage *match_image;
        
        MatchUser *matchuser = [MatchUser currentUser];

        UIImageView *imgview = [UIImageView new];
        
        [imgview sd_setImageWithURL:[NSURL URLWithString:[matchuser.pics objectAtIndex:0]]
                    placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                             options:SDWebImageRefreshCached];
        
        match_image = imgview.image;
        
        
        JSQMessagesAvatarImage *userImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:my_image
                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        
        
        JSQMessagesAvatarImage *matchImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:match_image
                                                                                        diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        self.avatars = @{
                         kJSQDemoAvatarIdCook : userImage,
                         kJSQDemoAvatarIdWoz : matchImage };
        
        
        /*    self.users = @{
         kJSQDemoAvatarIdCook : kJSQDemoAvatarDisplayNameCook,
         kJSQDemoAvatarIdWoz : kJSQDemoAvatarDisplayNameWoz};
         */
        
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
        
        self.messages = [NSMutableArray new];

        if (type == FULL_CONVERSATION)
        {
            [self loadMessages:messages];
        }
        else
        {
            [self loadLastMessage:messages];

        }
    }
 
    return self;
}

-(void)loadMessages:(NSArray*)messagesArray
{
    for (Messages *message in messagesArray)
    {
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:message.timestamp ];
        
        NSString *name;
        NSString *sender_id;
        
        if (message.type == SENT_MESSAGE)
        {
            sender_id = [[DataAccess singletonInstance] getUserID];
            name = [[DataAccess singletonInstance] getName];
        }
        else
        {
            MatchUser *currentMatch = [MatchUser currentUser];
            sender_id = [NSString stringWithFormat:@"%ld", (long)currentMatch.user_id];
            name = currentMatch.name;
        }
        
        JSQMessage *obj = [[JSQMessage alloc] initWithSenderId:sender_id
                                             senderDisplayName:name
                                                          date:date
                                                          text:NSLocalizedString(message.message, nil)];
        
        [self.messages addObject:obj];
    }
}

-(void)loadLastMessage:(NSArray*)messagesArray
{
    Messages *message = [messagesArray lastObject];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:message.timestamp ];
    
    NSString *name;
    NSString *sender_id;
    
    if (message.type == SENT_MESSAGE)
    {
        sender_id = [[DataAccess singletonInstance] getUserID];
        name = [[DataAccess singletonInstance] getName];
    }
    else
    {
        MatchUser *currentMatch = [MatchUser currentUser];
        sender_id = [NSString stringWithFormat:@"%ld", (long)currentMatch.user_id];
        name = currentMatch.name;
    }
    
    JSQMessage *obj = [[JSQMessage alloc] initWithSenderId:sender_id
                                         senderDisplayName:name
                                                      date:date
                                                      text:NSLocalizedString(message.message, nil)];
    
    [self.messages addObject:obj];
}


+(JSQMessage*)MessageReceived:(Messages*)message
{

    MatchUser *matchuser = [MatchUser currentUser];
    
    NSString *uid = [NSString stringWithFormat:@"%ld",(long)matchuser.user_id];
    
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:message.timestamp ];
    
    JSQMessage *obj = [[JSQMessage alloc] initWithSenderId:uid
                                         senderDisplayName:matchuser.name
                                                      date:date
                                                      text:NSLocalizedString(message.message, nil)];
    
    return obj;
    
}



@end
