//
//  NewMatchViewController.h
//  DateApp
//
//  Created by Neil Ballard on 1/1/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "Includes.h"


@interface NewMatchConflictViewController : UIViewController

@property (strong, nonatomic) TFDailyItem *matched_user;

- (IBAction)stayOption:(id)sender;

- (IBAction)matchOption:(id)sender;
- (IBAction)profileCurrent:(id)sender;

- (IBAction)profileNew:(id)sender;

@end
