//
//  NewMatchViewController.h
//  DateApp
//
//  Created by Neil Ballard on 1/5/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface NewMatchViewController : UIViewController


- (IBAction)keepSearching:(id)sender;
- (IBAction)goMessage:(id)sender;

@property (strong, nonatomic) User *match_user;

@property (strong, nonatomic) NSMutableArray *altMatches;

@end
