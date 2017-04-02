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

-(void)selectedProfile:(User*)user;

@end

@interface SwipeViewController : UIViewController<MatchSegueProtocol>


-(void)goToMatchedSegue:(id)sender obj:(TFDailyItem*)object;

@property (nonatomic, strong) UINavigationBar *navBar;
@property(nonatomic, strong) UINavigationController *navController;
@property (strong, nonatomic) UIWindow *window;


-(void) pushDetailView:(id)sender;
-(void)likeCurrentCard;
-(void)loadCards:(NSMutableArray*)users;
@property NSUInteger pageIndex;

@property (nonatomic, weak) id<GoToProfileProtocol> profile_delegate;



@property (strong, nonatomic) IBOutlet DraggableViewBackground *backgroundView;




@end
