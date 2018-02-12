//
//  SettingsViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/12/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//


#import "Includes.h"
#import "CERangeSlider.h"
#import "UUDoubleSliderView.h"


@interface SettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UUDoubleSliderViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *profile_image;

@property (strong, nonatomic) IBOutlet UIView *range_view;

@property (strong, nonatomic) IBOutlet UIView *age_view;
@property (strong, nonatomic) IBOutlet UISlider *distance_slider;
- (IBAction)ageValueChanged:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *distance_label;

@property (strong, nonatomic) IBOutlet UILabel *age_label;
@property (strong, nonatomic)  User *settings;


@end
