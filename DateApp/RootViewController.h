//
//  RootViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/7/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "PartingMessageViewController.h"
#import "NewMessageViewController.h"
#import "SwipeViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "DateApp-Swift.h"
#import "SecondChancePickerViewController.h"
#import "SelectionViewController.h"

@protocol ConversationDelegate;

@interface RootViewController : UIViewController<UIPageViewControllerDelegate, UIScrollViewDelegate,  PartingMessageDelegate, SegueProtocol, GoDiscoverProtocol>

-(void) goToMessaging:(id)sender;

@property (strong, nonatomic) User *user;

@property (nonatomic) CLLocationCoordinate2D curr_location;

@property (strong, nonatomic) IBOutlet UIView *indicatorView;

@property (strong, nonatomic) IBOutlet UIButton *chatBtn;

-(void)updateUnmatch;


@end
