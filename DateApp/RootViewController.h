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

@protocol SetupDelegate <NSObject>
-(void)runSetupAfterLogin;
@end

@interface RootViewController : UIViewController<UIPageViewControllerDelegate, UIScrollViewDelegate,  PartingMessageDelegate, SegueProtocol, SetupDelegate>

-(void) goToMessaging:(id)sender;

@property (strong, nonatomic) User *user;

@property (nonatomic) CLLocationCoordinate2D curr_location;

@property (strong, nonatomic) IBOutlet UIView *indicatorView;

@property (strong, nonatomic) IBOutlet UIButton *chatBtn;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *menuTrailing;


-(CGRect)getSelectedFrame;
-(void)updateUnmatch;
- (void)profileAction:(User*)user;
-(void)editProfile:(User*)user;
-(void)settingsAction;
-(void)goToInAppPurchaes;
-(void)updateLastMessageUI;

@end
