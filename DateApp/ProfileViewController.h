//
//  ProfileViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/3/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface ProfileViewController : UIViewController

- (IBAction)dragGesture:(UIPanGestureRecognizer*)sender;

@property (strong, nonatomic) IBOutlet UILabel *bio_label;

@property (strong, nonatomic)  TFDailyItem *user_data;

- (IBAction)heart_button:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *name_age;
@property (strong, nonatomic) IBOutlet UILabel *occupation_label;

@property (strong, nonatomic) IBOutlet UIImageView *top_heart;

@property (strong, nonatomic) IBOutlet UIButton *top_button;

@property (strong, nonatomic)  NSString *mode;


@end
