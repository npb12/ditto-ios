//
//  MessageModelData.h
//  DateApp
//
//  Created by Neil Ballard on 1/16/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "JSQMessagesViewController/JSQMessages.h"
#import "Messages.h"
#import "MatchUser.h"

/**
 *  This is for demo/testing purposes only.
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */

static NSString * const kJSQDemoAvatarDisplayNameSquires = @"Jesse Squires";
static NSString * const kJSQDemoAvatarDisplayNameCook = @"Tim Cook";
static NSString * const kJSQDemoAvatarDisplayNameJobs = @"Jobs";
static NSString * const kJSQDemoAvatarDisplayNameWoz = @"Steve Wozniak";

static NSString * const kJSQDemoAvatarIdSquires = @"053496-4509-289";
static NSString * const kJSQDemoAvatarIdCook = @"468-768355-23123";
static NSString * const kJSQDemoAvatarIdJobs = @"707-8956784-57";
static NSString * const kJSQDemoAvatarIdWoz = @"309-41802-93823";



@interface MessageModelData : NSObject

typedef NS_ENUM(NSUInteger, load_type) {
    LAST_MESSAGE                = 0,
    FULL_CONVERSATION           = 1,
};

@property (nonatomic, assign) NSInteger type;


@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (strong, nonatomic) NSDictionary *users;

@property (strong, nonatomic) Messages *message;

- (id)initWithMessages:(NSArray*)messages type:(NSInteger)type;

- (id)initWithMessage:(Messages*)message;

+(JSQMessage*)MessageReceived:(Messages*)message;
@end
