//
//  TutorialViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/20/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@protocol SetupDelegate;

@interface TutorialViewController : UIViewController
@property (nonatomic, weak) id<SetupDelegate> delegate;
@end
