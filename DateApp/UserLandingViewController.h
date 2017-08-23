//
//  UserLandingViewController.h
//  DateApp
//
//  Created by Neil Ballard on 7/3/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

//#import <UIKit/UIKit.h>
//#import "User.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DAGradientColor.h"
//#import "ProfileViewController.h"
#import "Includes.h"



@interface UserLandingViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *profilePic;

@property (strong, nonatomic) User *user;


@end
