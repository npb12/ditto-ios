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


@interface RootViewController : UIViewController<UIPageViewControllerDelegate, UIScrollViewDelegate, MessageViewControllerDelegate>

-(void) goToMessaging:(id)sender;


@end
