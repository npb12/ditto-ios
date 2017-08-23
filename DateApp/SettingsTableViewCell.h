//
//  SettingsTableViewCell.h
//  DateApp
//
//  Created by Neil Ballard on 1/29/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUDoubleSliderView.h"

@interface SettingsTableViewCell : UITableViewCell<UUDoubleSliderViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *setting_label;

@property (strong, nonatomic) IBOutlet UISwitch *setting_switch;

@property (strong, nonatomic) IBOutlet UILabel *gender_label;


@property (strong, nonatomic) IBOutlet UISlider *distance_slider;

@property (strong, nonatomic) IBOutlet UILabel *account_label;

@property (strong, nonatomic) IBOutlet UILabel *sliderLabel;
@property (strong, nonatomic) IBOutlet UILabel *sliderDataLabel;

@property (strong, nonatomic) IBOutlet UUDoubleSliderView *doubleSlider;

@property (strong, nonatomic) IBOutlet UIImageView *genderCheck;

@end
