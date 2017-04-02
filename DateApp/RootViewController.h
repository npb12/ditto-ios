//
//  RootViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/7/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"
#import <JSQMessagesViewController/JSQMessages.h>
#import "MessageViewController.h"
#import "PartingMessageViewController.h"
#import "NewMessageViewController.h"
#import "SwipeViewController.h"



@interface RootViewController : UIViewController<UIPageViewControllerDelegate, UIScrollViewDelegate, MessageViewControllerDelegate, PartingMessageDelegate, SegueProtocol, LikedProfileProtocol>

-(void) goToMessaging:(id)sender;

@property (strong, nonatomic) User *user;



@end
