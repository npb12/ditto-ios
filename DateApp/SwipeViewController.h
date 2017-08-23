//
//  SwipeViewController.h
//  portal
//
//  Created by Neil Ballard on 12/13/15.
//  Copyright © 2015 Neil_appworld. All rights reserved.
//

#import "Includes.h"
@class DraggableViewBackground;
@class DMPagerNavigationBarItem;

@protocol GoToProfileProtocol <NSObject>

-(void)selectedProfile:(User*)user matched:(BOOL)match;

@end

@interface SwipeViewController : UIViewController


@property (nonatomic, strong) UINavigationBar *navBar;
@property(nonatomic, strong) UINavigationController *navController;
@property (strong, nonatomic) UIWindow *window;


-(void) pushDetailView:(id)sender;
-(void)likeCurrentCard:(BOOL)option;
-(void)loadCards:(NSMutableArray*)users;
-(void)showEmptyLabel;
@property NSUInteger pageIndex;

@property (nonatomic, weak) id<GoToProfileProtocol> profile_delegate;



@property (strong, nonatomic) IBOutlet DraggableViewBackground *backgroundView;


-(void)updateMatch;
-(void)updateUnmatch;



@end
