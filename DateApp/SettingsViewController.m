//
//  SettingsViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/12/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"
#import "DAGradientColor.h"



@interface SettingsViewController ()

@property (strong, nonatomic) IBOutlet UIView *top_line;

@property (nonatomic, retain) CERangeSlider *ageRangeSlider;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *navbar;

@property (strong, nonatomic)  User *settings;

@property (strong, nonatomic) NSString *ageRange;
@property (strong, nonatomic) NSString *distance;

@property (strong, nonatomic) UILabel *ageRangeLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIView *gradientView;


@end

@implementation SettingsViewController{
    BOOL ageRangeChanged;
    BOOL distanceChanged;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.headerLabel.textColor = [DAGradientColor gradientFromColor:self.headerLabel.frame.size.width];
    
    UIColor *color1 = [UIColor colorWithRed:0.09 green:0.92 blue:0.85 alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:0.08 green:0.77 blue:0.90 alpha:1.0];
    UIColor *color3 = [UIColor colorWithRed:0.08 green:0.67 blue:0.94 alpha:1.0];
    
    [self.gradientView layoutIfNeeded];
    
    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.frame = self.gradientView.bounds;
    grad.colors = [NSArray arrayWithObjects:(id)([color1 colorWithAlphaComponent:1].CGColor),(id)([color2 colorWithAlphaComponent:1].CGColor),(id)([color3 colorWithAlphaComponent:1].CGColor),nil];
    grad.startPoint = CGPointMake(0.0,0.5);
    grad.endPoint = CGPointMake(1.0,0.5);
    [self.gradientView.layer insertSublayer:grad atIndex:0];
    
    self.navbar.layer.masksToBounds = NO;
    self.navbar.layer.shadowOffset = CGSizeMake(-2, 2);
    self.navbar.layer.shadowRadius = 0.05;
    self.navbar.layer.shadowOpacity = 0.05;
    self.navbar.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
    [DAServer getSettings:@"" completion:^(User *settings, NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.settings = settings;
                
                self.ageRange = self.settings.ageRange;
                [self splitAgeRange];
                self.distance = [NSString stringWithFormat:@"%ld miles", (long)self.settings.settingsDistance];
                [self setdistanceValue];
                [self updateGenderSelection];
                [self updateInvisibleSwitch];
                [self updateNotificationsSwitch];
                [self.tableView reloadData];
            });
        } else {
            // update UI to indicate error or take remedial action
        }
    }];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView sizeToFit];
    
    
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    
    //ceil(self.ageRangeSlider.lowerValue), ceil(self.ageRangeSlider.upperValue)
    if (ageRangeChanged)
    {
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:1 inSection:0];
        
        SettingsTableViewCell *cell = (SettingsTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
        
        NSString *minValue = [NSString stringWithFormat:@"%d", (int) ceil(cell.doubleSlider.minimumSliderValue)];
        
        NSString *maxValue = [NSString stringWithFormat:@"%d", (int) ceil(cell.doubleSlider.maximumSliderValue)];
        
        NSString *value = [NSString stringWithFormat:@"%@-%@", minValue, maxValue];
        [self updateServer:@"settingsAge" selection:value];
    }
    
    
    if (distanceChanged)
    {
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
        
        SettingsTableViewCell *cell = (SettingsTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
        
        NSString *value = [NSString stringWithFormat:@"%d", (int)cell.distance_slider.value];
        [self updateServer:@"settingsDistance" selection:value];
    }
}


-(void)splitAgeRange
{
    NSArray *items = [self.ageRange componentsSeparatedByString:@"-"];   //take the one array for split the string
    
    NSString *lowerValue=[items objectAtIndex:0];
    NSString *upperValue=[items objectAtIndex:1];
    
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:1 inSection:0];
    
    SettingsTableViewCell *cell = (SettingsTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell != nil)
    {
     //   [cell.doubleSlider setMinimumValue:[lowerValue floatValue]];
    //    [cell.doubleSlider setMaximumValue:[upperValue floatValue]];
        
        cell.doubleSlider.minimumSliderValue = [lowerValue floatValue];
        cell.doubleSlider.maximumSliderValue = [upperValue floatValue];


     //   [cell.sliderDataLabel setText:[NSString stringWithFormat:@"%.0f mi. Away", ceil(cell.distance_slider.value)]];
        
        cell.sliderDataLabel.text = [NSString stringWithFormat:@"%@ - %@", lowerValue, upperValue];
    }
    
   // self.ageRangeSlider.lowerValue = [lowerValue integerValue];
   // self.ageRangeSlider.upperValue = [upperValue integerValue];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


/*
 [self.age_label setText:[NSString stringWithFormat:@"%.0f - %.0f", ceil(self.ageRangeSlider.lowerValue), ceil(self.ageRangeSlider.upperValue)]]; */

- (void)slideValueChanged:(id)control
{
    [self.ageRangeLabel setText:[NSString stringWithFormat:@"%.0f - %.0f", ceil(self.ageRangeSlider.lowerValue), ceil(self.ageRangeSlider.upperValue)]];
    ageRangeChanged = YES;

}

- (void)updateState
{
   // self.ageRangeSlider.trackHighlightColour = [UIColor redColor];
   // self.ageRangeSlider.curvatiousness = 0.0;
    
}


- (void)distanceValueChanged:(id)control {
    
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
    
    SettingsTableViewCell *cell = (SettingsTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"value of:: %f", ceil(cell.distance_slider.value));
    
    [cell.sliderDataLabel setText:[NSString stringWithFormat:@"%.0f mi. Away", ceil(cell.distance_slider.value)]];
    
    distanceChanged = YES;
}


-(void)setdistanceValue
{
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];

    SettingsTableViewCell *cell = (SettingsTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell != nil)
    {
        [cell.distance_slider setValue:[self.distance integerValue]];
        [cell.sliderDataLabel setText:[NSString stringWithFormat:@"%.0f mi. Away", ceil(cell.distance_slider.value)]];
    }
}

- (void) minSliderValuesChanged:(UUDoubleSliderView*)slider value:(float)value
{
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:1 inSection:0];
    
    SettingsTableViewCell *cell = (SettingsTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell != nil)
    {
        cell.sliderDataLabel.text = [NSString stringWithFormat:@"%d - %d", (int)(value + 0.5), (int) cell.doubleSlider.maximumSliderValue];
    }
    ageRangeChanged = YES;
}

- (void) maxSliderValuesChanged:(UUDoubleSliderView*)slider value:(float)value
{
    
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:1 inSection:0];
    
    SettingsTableViewCell *cell = (SettingsTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell != nil)
    {
        cell.sliderDataLabel.text = [NSString stringWithFormat:@"%d - %d", (int) cell.doubleSlider.minimumSliderValue, (int)(value + 0.5)];
    }
    

    
    ageRangeChanged = YES;
}


#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    if (section == 1 || section == 2)
    {
        return 3;
    }
    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 102.0;
        default:
            return 58.0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    /*    ConnectionsTableViewCell *cell = (ConnectionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier]; */
    

        SettingsTableViewCell *cell;
        


        
        if (indexPath.section == 0)
        {
            
            cell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DistanceReuseIdentifier"];
            
            if (indexPath.row == 0)
            {
                cell.distance_slider.minimumValue = 1.0;
                cell.distance_slider.maximumValue = 90.0;
                
                [cell.distance_slider addTarget:self
                                         action:@selector(distanceValueChanged:)
                               forControlEvents:UIControlEventValueChanged];
                cell.distance_slider.minimumTrackTintColor = [DAGradientColor gradientFromColor:cell.distance_slider.frame.size.width];
                cell.sliderLabel.text = @"Maximum Distance";
               // cell.sliderDataLabel.text = @"30 mi. Away";
                [cell.doubleSlider setHidden:YES];
                
                /*
                UIColor *color1 = [UIColor colorWithRed:0.09 green:0.92 blue:0.85 alpha:1.0];
                UIColor *color2 = [UIColor colorWithRed:0.08 green:0.77 blue:0.90 alpha:1.0];
                UIColor *color3 = [UIColor colorWithRed:0.08 green:0.67 blue:0.94 alpha:1.0];
                
                CAGradientLayer *gradient = [CAGradientLayer layer];
                gradient.frame = cell.distance_slider.bounds;
                gradient.colors = [NSArray arrayWithObjects:(id)([color1 colorWithAlphaComponent:1].CGColor),(id)([color2 colorWithAlphaComponent:1].CGColor),(id)([color3 colorWithAlphaComponent:1].CGColor),nil];
                gradient.startPoint = CGPointMake(0.0,0.5);
                gradient.endPoint = CGPointMake(1.0,0.5);
                [cell.distance_slider.layer insertSublayer:gradient atIndex:0];
                gradient.masksToBounds = YES; */
  
            }
            else if(indexPath.row == 1)
            {
              //  cell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AgeReuseIdentifier"];
                [cell.distance_slider setHidden:YES];
                
                cell.doubleSlider.delegate = self;
                cell.doubleSlider.leftSliderImage = [UIImage imageNamed:@"knob_image"];
                cell.doubleSlider.rightSliderImage = [UIImage imageNamed:@"knob_image"];
                cell.doubleSlider.sliderHeight = 2;
                cell.doubleSlider.minimumValue = 18;
                cell.doubleSlider.maximumValue = 65;
             //   cell.doubleSlider.minimumSliderValue = 18;
             //   cell.doubleSlider.maximumSliderValue = 65;
                cell.doubleSlider.sliderColor = [DAGradientColor gradientFromColor:cell.doubleSlider.frame.size.width];

                /*
                self.ageRangeSlider = [[CERangeSlider alloc] initWithFrame:CGRectMake(20, 62, self.view.frame.size.width - 45, 32)];
                self.ageRangeSlider.backgroundColor = [UIColor clearColor];
                
                [cell.ageRangeSlider addTarget:self
                                        action:@selector(slideValueChanged:)
                              forControlEvents:UIControlEventValueChanged]; */
                
                //   [self performSelector:@selector(updateState) withObject:nil afterDelay:1.0f];
                cell.sliderLabel.text = @"Age Range";
              //  cell.sliderDataLabel.text = @"18 - 34";
                
              //  [cell addSubview:self.ageRangeSlider];
            }
            

            /*
            cell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"GenderReuseIdentifier"];
            
            if (indexPath.row == 0)
            {
                cell.gender_label.text = @"Male";
            }
            else if(indexPath.row == 1)
            {
                cell.gender_label.text = @"Female";
            } */
            
            
        }
        else if (indexPath.section == 1)
        {
            
            cell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"GenderReuseIdentifier"];
            
            if (indexPath.row == 0)
            {
                cell.gender_label.text = @"Male";
            }
            else if (indexPath.row == 1)
            {
                cell.gender_label.text = @"Female";
            }
            else if (indexPath.row == 2)
            {
                cell.gender_label.text = @"Male & Female";
                [cell.genderCheck setHidden:YES];
            }
            
            /*
            cell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DistanceReuseIdentifier"];
            
            cell.distance_slider.minimumValue = 1.0;
            cell.distance_slider.maximumValue = 90.0;
            
            [cell.distance_slider addTarget:self
                                    action:@selector(distanceValueChanged:)
                          forControlEvents:UIControlEventValueChanged]; */
            
        }/*else if (indexPath.section == 2) {

            cell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DistanceReuseIdentifier"];
            
            cell.distance_slider.minimumValue = 1.0;
            cell.distance_slider.maximumValue = 90.0;
            
            [cell.distance_slider addTarget:self
                                     action:@selector(distanceValueChanged:)
                           forControlEvents:UIControlEventValueChanged];
        }else if (indexPath.section == 3 || indexPath.section == 4){
            
        cell  = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SettingReuseIdentifier"];;
            
            if (indexPath.section == 3) {
                
                cell.setting_label.text = @"Invisible";
                cell.setting_switch.transform = CGAffineTransformMakeScale(0.75, 0.75);
                
                [cell.setting_switch addTarget:self action:@selector(invisibleValueChanged) forControlEvents:UIControlEventValueChanged];


                
            }
            
        }*/else{
            


            if (indexPath.row == 0)
            {
                cell  = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SettingReuseIdentifier"];
                cell.setting_label.text = @"Push Notifications";
             //   cell.setting_switch.transform = CGAffineTransformMakeScale(0.75, 0.75);
                
                [cell.setting_switch addTarget:self action:@selector(notificationValueChanged) forControlEvents:UIControlEventValueChanged];
                
                cell.setting_switch.onTintColor = [DAGradientColor gradientFromColor:cell.setting_switch.frame.size.width];
            }
            else if(indexPath.row == 1)
            {
                cell  = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AccountReuseIdentifier"];
                [cell.account_label setText:@"Logout"];

            }
            else
            {
                cell  = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AccountReuseIdentifier"];
                [cell.account_label setText:@"Delete Account"];
            }
            
        }
            
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SettingsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 1)
    {
        [self updateGenderSelection:indexPath];
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 1)
        {
            
            [DAServer facebookLogout];
            [self performSegueWithIdentifier:@"returnToStepOne" sender:self];
            /*
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Logout?"
                                                                           message:@"Are you sure you want to logout of Ditto?"
                                                                    preferredStyle:UIAlertControllerStyleAlert]; // 1
            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Yes"
                                                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                      [DAServer facebookLogout];
                                                  [self performSegueWithIdentifier:@"returnToStepOne" sender:self];
                                                                  }];
            
            UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"No"
                                                                  style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                                      
                                                                  }];
            
            [alert addAction:secondAction];
            [alert addAction:firstAction];
             // 4

            
            [self presentViewController:alert animated:YES completion:nil]; // 6
            */
            

        }
    }
    
    NSLog(@"section %ld row %ld", indexPath.section, indexPath.row);
    
    
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 40.0;
        case 1:
        case 2:
       // case 3:
            return 35.0;
        default:
            return 0.0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20,0,100,40)];
    
    
    switch (section) {
        case 0:
        case 1:
        case 2:
            if (section == 0) {
                UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20,5,200,40)];
                lbl.text = @"DISCOVERY SETTINGS";
                footer.backgroundColor=[UIColor clearColor];
                lbl.backgroundColor = [UIColor clearColor];
                lbl.textAlignment = NSTextAlignmentLeft;
                [lbl setNumberOfLines:1];//set line if you need
                [lbl setFont:[UIFont fontWithName:@"RooneySansLF-Regular" size:12.0]];//font size and style
                [lbl setTextColor:[self headerColor]];
                [footer addSubview:lbl];
                break;
                
            }else if(section == 1){
                UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20,0,200,40)];
                lbl.text = @"SHOW ME";
                footer.backgroundColor=[UIColor clearColor];
                lbl.backgroundColor = [UIColor clearColor];
                lbl.textAlignment = NSTextAlignmentLeft;
                [lbl setNumberOfLines:1];//set line if you need
                [lbl setFont:[UIFont fontWithName:@"RooneySansLF-Regular" size:12.0]];//font size and style
                [lbl setTextColor:[self headerColor]];
                [footer addSubview:lbl];
                /*
                self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 80,0,100,40)];
                self.distanceLabel.text = self.distance;
                self.distanceLabel.backgroundColor = [UIColor clearColor];
                self.distanceLabel.textAlignment = NSTextAlignmentLeft;
                [self.distanceLabel setNumberOfLines:1];
                [self.distanceLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];//font size and style
                [self.distanceLabel setTextColor:[self othBlueColor]];
                [footer addSubview:self.distanceLabel]; */

            }else{
                UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20,0,200,40)];
                lbl.text = @"SETTINGS";
                footer.backgroundColor=[UIColor clearColor];
                lbl.backgroundColor = [UIColor clearColor];
                lbl.textAlignment = NSTextAlignmentLeft;
                [lbl setNumberOfLines:1];//set line if you need
                [lbl setFont:[UIFont fontWithName:@"RooneySansLF-Regular" size:12.0]];//font size and style
                [lbl setTextColor:[self headerColor]];
                [footer addSubview:lbl];
               // lbl.text = @"Age Range:";
                /*self.ageRangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 80,0,100,40)];
                self.ageRangeLabel.text = self.ageRange;
                self.ageRangeLabel.backgroundColor = [UIColor clearColor];
                self.ageRangeLabel.textAlignment = NSTextAlignmentLeft;
                [self.ageRangeLabel setNumberOfLines:1];
                [self.ageRangeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];//font size and style
                [self.ageRangeLabel setTextColor:[self othBlueColor]];
                [footer addSubview:self.ageRangeLabel]; */

            }
            /*
            footer.backgroundColor=[UIColor clearColor];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textAlignment = NSTextAlignmentLeft;
            [lbl setNumberOfLines:1];//set line if you need
            [lbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];//font size and style
            [lbl setTextColor:[UIColor blackColor]];
            [footer addSubview:lbl]; */
            break;
        default:
            break;
    }
    
    
    
    return footer;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 2:
            return 55.0;
        default:
            return 0.0;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20,0,self.view.frame.size.width - 40,40)];
    
    
    if(section == 2)
    {
        lbl.text = @"Ditto Version 1.0.0";
    }
    footer.backgroundColor=[UIColor clearColor];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textAlignment = NSTextAlignmentLeft;
    [lbl setNumberOfLines:1];//set line if you need
    [lbl setFont:[UIFont fontWithName:@"RooneySansLF-Regular" size:10.0]];//font size and style
    [lbl setTextColor:[self headerColor]];
    [footer addSubview:lbl];

    
    return footer;
}

-(void)updateGenderSelection
{
    NSIndexPath *indexPath1 =[NSIndexPath indexPathForRow:0 inSection:1];
    
    SettingsTableViewCell *cell1 = (SettingsTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath1];
    
    NSIndexPath *indexPath2 =[NSIndexPath indexPathForRow:1 inSection:1];
    
    SettingsTableViewCell *cell2 = (SettingsTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath2];
    
    if ([self.settings.settingsGender isEqualToString:@"male"])
    {
        [cell1.genderCheck setHidden:NO];
        [cell2.genderCheck setHidden:YES];

    }
    else
    {
        [cell1.genderCheck setHidden:YES];
        [cell2.genderCheck setHidden:NO];
    }

    
}

-(void)updateGenderSelection:(NSIndexPath*)path
{
    NSIndexPath *indexPath1 =[NSIndexPath indexPathForRow:0 inSection:1];
    
    SettingsTableViewCell *cell1 = (SettingsTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath1];
    
    NSIndexPath *indexPath2 =[NSIndexPath indexPathForRow:1 inSection:1];
    
    SettingsTableViewCell *cell2 = (SettingsTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath2];
    
    if (path.row == 0)
    {
        [cell1.genderCheck setHidden:NO];
        [cell2.genderCheck setHidden:YES];
        self.settings.settingsGender = @"male";
    }
    else if(path.row == 1)
    {
        [cell1.genderCheck setHidden:YES];
        [cell2.genderCheck setHidden:NO];
        self.settings.settingsGender = @"female";
    }
    else
    {
        
    }
    
    [self updateServer:@"settingsGender" selection:self.settings.settingsGender];

}

-(void)updateInvisibleSwitch
{
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:3];
    
    SettingsTableViewCell *cell = (SettingsTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (self.settings.settingsInvisible == 0)
    {
        [cell.setting_switch setOn:NO];
    }
    else
    {
        [cell.setting_switch setOn:YES];
    }
}

-(void)invisibleValueChanged
{
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:3];
    
    SettingsTableViewCell *cell = (SettingsTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSString *value = @"0";
    
    if (cell.setting_switch.isOn)
    {
        value = @"1";
    }
    
    [self updateServer:@"invisible" selection:value];
}


-(void)updateNotificationsSwitch
{
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:4];
    
    SettingsTableViewCell *cell = (SettingsTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (self.settings.settingsNotifications == 0)
    {
        [cell.setting_switch setOn:NO];
    }
    else
    {
        [cell.setting_switch setOn:YES];
    }
}

-(void)notificationValueChanged
{
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:4];
    
    SettingsTableViewCell *cell = (SettingsTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSString *value = @"0";
    
    if (cell.setting_switch.isOn)
    {
        value = @"1";
    }
    
    [self updateServer:@"enable_notification" selection:value];
    
}


-(UIColor*)blueColor{
    return [UIColor colorWithRed:0.18 green:0.49 blue:0.83 alpha:1.0];
}


- (IBAction)go_back:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)close_action:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(UIColor*)othBlueColor{
    return [UIColor colorWithRed:0.01 green:0.68 blue:0.80 alpha:1.0];
}

-(void)updateServer:(NSString*)type selection:(NSString*)setting
{
    
    
    //settingsGender, settingsAge, settingsDistance, invisible and enable_notification. settingsAge format is min - max like 18-100, simply send it as a string
    [DAServer updateSettings:type setting:setting completion:^(NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {
            
        } else {
            // update UI to indicate error or take remedial action
        }
    }];
    
}



-(UIColor*)headerColor
{
    return [UIColor colorWithRed:0.56 green:0.56 blue:0.58 alpha:1.0];
}

@end
