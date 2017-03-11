//
//  SwipeViewController.h
//  portal
//
//  Created by Neil Ballard on 12/13/15.
//  Copyright © 2015 Neil_appworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableViewBackground.h"

@class DMPagerNavigationBarItem;


@interface SwipeViewController : UIViewController

@property (nonatomic, strong) UINavigationBar *navBar;
@property(nonatomic, strong) UINavigationController *navController;
@property (strong, nonatomic) UIWindow *window;


-(void) pushDetailView:(id)sender;
-(void)likeCurrentCard;
@property NSUInteger pageIndex;


@property (strong, nonatomic) IBOutlet DraggableViewBackground *backgroundView;




@end
