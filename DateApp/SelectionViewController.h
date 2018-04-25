//
//  GenderSelectionViewController.h
//  DateApp
//
//  Created by Neil Ballard on 2/13/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAServer.h"
#import "DataAccess.h"
#import "RootViewController.h"

@protocol SetupDelegate;

@interface SelectionViewController : UIViewController
@property (nonatomic, weak) id<SetupDelegate> delegate;
@end
