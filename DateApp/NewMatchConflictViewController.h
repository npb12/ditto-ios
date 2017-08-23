//
//  NewMatchViewController.h
//  DateApp
//
//  Created by Neil Ballard on 1/1/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "Includes.h"
#import "MessageViewController.h"

@interface NewMatchConflictViewController : UIViewController


@property (nonatomic, assign) BOOL isConflict;


- (IBAction)stayOption:(id)sender;

- (IBAction)matchOption:(id)sender;
- (IBAction)profileCurrent:(id)sender;

- (IBAction)profileNew:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *matchButton;

@property (strong, nonatomic) User *match_user;


@property (strong, nonatomic) NSMutableArray *altMatches;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentViewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nViewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nViewLeading;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentImageHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentImageWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nImageWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nImageHeight;

@property (strong, nonatomic) IBOutlet UIView *nView;
@property (strong, nonatomic) IBOutlet UIView *currentView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *stayBtnWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *stayBtnHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *firstTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelTopConstraint;

@end
