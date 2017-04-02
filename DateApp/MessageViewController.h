//
//  MessageViewController.h
//  DateApp
//
//  Created by Neil Ballard on 1/8/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "JSQMessagesViewController/JSQMessagesViewController.h"


#import "MessageModelData.h"
#import "NSUserDefaults+DemoSettings.h"

@import JSQMessagesViewController;

@import CocoaAsyncSocket;


@class MessageViewController;


@protocol MessageViewControllerDelegate <NSObject>

- (void)didDismissMessageViewController:(MessageViewController *)vc;

@end


@interface MessageViewController : JSQMessagesViewController <UIActionSheetDelegate, JSQMessagesComposerTextViewPasteDelegate, NSStreamDelegate>

@property (weak, nonatomic) id<MessageViewControllerDelegate> delegateModal;

@property (strong, nonatomic) MessageModelData *demoData;

- (void)receiveMessagePressed:(UIBarButtonItem *)sender;

- (void)closePressed:(UIBarButtonItem *)sender;

@end
NSInputStream *inputStream;
NSOutputStream *outputStream;
NSMutableArray * messages;
