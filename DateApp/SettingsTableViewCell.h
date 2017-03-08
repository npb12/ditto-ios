//
//  SettingsTableViewCell.h
//  DateApp
//
//  Created by Neil Ballard on 1/29/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *setting_label;

@property (strong, nonatomic) IBOutlet UISwitch *setting_switch;

@property (strong, nonatomic) IBOutlet UISwitch *gender_male_switch;

@property (strong, nonatomic) IBOutlet UISwitch *gender_female_switch;

@property (strong, nonatomic) IBOutlet UISlider *distance_slider;

@property (strong, nonatomic) IBOutlet UILabel *account_label;

@end
