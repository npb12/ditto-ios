//
//  SettingsViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/12/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"



@interface SettingsViewController ()

@property (strong, nonatomic) IBOutlet UIView *top_line;

@property (nonatomic, retain) CERangeSlider *ageRangeSlider;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *navbar;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    

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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)slideValueChanged:(id)control
{

    /*
        [self.age_label setText:[NSString stringWithFormat:@"%.0f - %.0f", ceil(self.ageRangeSlider.lowerValue), ceil(self.ageRangeSlider.upperValue)]]; */
}


- (IBAction)ageValueChanged:(id)sender {

    [self.distance_label setText:[NSString stringWithFormat:@"%.0f miles", ceil(self.distance_slider.value)]];
}




#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    if (section == 5) {
        return 2;
    }
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    /*    ConnectionsTableViewCell *cell = (ConnectionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier]; */
    

        SettingsTableViewCell *cell;
        


        
        if (indexPath.section == 0) {
            
            cell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"GenderReuseIdentifier"];
            
            cell.setting_label.text = @"Notifications";
            cell.gender_male_switch.transform = CGAffineTransformMakeScale(0.75, 0.75);
            cell.gender_female_switch.transform = CGAffineTransformMakeScale(0.75, 0.75);
            
            
        }else if (indexPath.section == 1) {
            cell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DistanceReuseIdentifier"];
            
        }else if (indexPath.section == 2) {
            cell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AgeReuseIdentifier"];
            self.ageRangeSlider = [[CERangeSlider alloc] initWithFrame:CGRectMake(20, cell.frame.size.height /4, self.view.frame.size.width - 45, 32)];
            self.ageRangeSlider.backgroundColor = [UIColor clearColor];
            
            [self.ageRangeSlider addTarget:self
                                    action:@selector(slideValueChanged:)
                          forControlEvents:UIControlEventValueChanged];
            
            [cell addSubview:self.ageRangeSlider];
            
        }else if (indexPath.section == 3 || indexPath.section == 4){
            
        cell  = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SettingReuseIdentifier"];;
            
            if (indexPath.section == 3) {
                
                cell.setting_label.text = @"Invisible";
                cell.setting_switch.transform = CGAffineTransformMakeScale(0.75, 0.75);

                
            }else if (indexPath.section == 4) {
                
                cell.setting_label.text = @"Notifications";
                cell.setting_switch.transform = CGAffineTransformMakeScale(0.75, 0.75);
                
            }
            
        }else{
            
            cell  = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AccountReuseIdentifier"];;

            if (indexPath.row == 0) {
                [cell.account_label setText:@"Logout"];
            }else{
                [cell.account_label setText:@"Remove Account"];
            }
            
        }
            
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    

        

    
    
    
}
/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 //  CGFloat height = self.tableBack.frame.size.height;
 
 CGFloat height = 0;
 if([[DeviceManager sharedInstance] getIsIPhone5Screen])
 {
 height =  90;
 }
 else if ([[DeviceManager sharedInstance] getIsIPhone6Screen])
 {
 height = 100;
 }
 else if ([[DeviceManager sharedInstance] getIsIPhone6PlusScreen])
 {
 height = 110;
 }
 else if ([[DeviceManager sharedInstance] getIsIPhone4Screen] || [[DeviceManager sharedInstance] getIsIPad]) {
 height = 85;
 }
 return height; //(height / 5);//[self getCellHeight];
 } */


/*
 -(CGFloat)getCellHeight {
 CGFloat cellHeight = 0.0;
 if([[DeviceManager sharedInstance] getIsIPhone5Screen])
 {
 cellHeight =  ceilf(163/2);
 }
 else if ([[DeviceManager sharedInstance] getIsIPhone6Screen])
 {
 cellHeight = ceilf(180/2);
 }
 else if ([[DeviceManager sharedInstance] getIsIPhone6PlusScreen])
 {
 cellHeight = ceil(300/3);
 }
 else if ([[DeviceManager sharedInstance] getIsIPhone4Screen] || [[DeviceManager sharedInstance] getIsIPad]) {
 cellHeight = ceilf(140/2);
 }
 
 return cellHeight;
 }
 
 -(CGFloat)getAccessoryViewWidth {
 CGFloat modifier = 0.0;
 if([[DeviceManager sharedInstance] getIsIPhone5Screen])
 {
 modifier =  42;
 }
 else if ([[DeviceManager sharedInstance] getIsIPhone6Screen])
 {
 modifier = 42;
 }
 else if ([[DeviceManager sharedInstance] getIsIPhone6PlusScreen])
 {
 modifier = 48;
 }
 else if ([[DeviceManager sharedInstance] getIsIPhone4Screen] || [[DeviceManager sharedInstance] getIsIPad]) {
 modifier = 42;
 }
 
 return modifier;
 }
 
 -(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
 if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
 [cell setSeparatorInset:UIEdgeInsetsZero];
 }
 if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
 [cell setLayoutMargins:UIEdgeInsetsZero];
 }
 }*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
 //   SettingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 75.0;
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
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(25,0,100,40)];
    
    
    switch (section) {
        case 0:
        case 1:
        case 2:
            if (section == 0) {
                UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(25,40,100,40)];
                lbl.text = @"Show Me:";
                footer.backgroundColor=[UIColor clearColor];
                lbl.backgroundColor = [UIColor clearColor];
                lbl.textAlignment = NSTextAlignmentLeft;
                [lbl setNumberOfLines:1];//set line if you need
                [lbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];//font size and style
                [lbl setTextColor:[UIColor blackColor]];
                [footer addSubview:lbl];
                break;
                
            }else if(section == 1){
                lbl.text = @"Distance:";
                UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100,0,100,40)];
                lbl2.text = @"25 miles";
                lbl2.backgroundColor = [UIColor clearColor];
                lbl2.textAlignment = NSTextAlignmentLeft;
                [lbl2 setNumberOfLines:1];
                [lbl2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];//font size and style
                [lbl2 setTextColor:[self othBlueColor]];
                [footer addSubview:lbl2];

            }else{
                lbl.text = @"Age Range:";
                UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100,0,100,40)];
                lbl2.text = @"18 - 27";
                lbl2.backgroundColor = [UIColor clearColor];
                lbl2.textAlignment = NSTextAlignmentLeft;
                [lbl2 setNumberOfLines:1];
                [lbl2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];//font size and style
                [lbl2 setTextColor:[self othBlueColor]];
                [footer addSubview:lbl2];

            }
            footer.backgroundColor=[UIColor clearColor];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textAlignment = NSTextAlignmentLeft;
            [lbl setNumberOfLines:1];//set line if you need
            [lbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];//font size and style
            [lbl setTextColor:[UIColor blackColor]];
            [footer addSubview:lbl];
            break;
        default:
            break;
    }
    
    
    
    return footer;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
     //   case 2:
        case 3:
        case 4:
            return 55.0;
        default:
            return 0.0;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(25,0,self.view.frame.size.width - 40,40)];
    
    
    switch (section) {
        case 0:
        case 1:
        case 3:
        case 4:
       // case 2:
            if (section == 0) {
                lbl.text = @"The gender of cards you want to see.";
                
            }else if(section == 1){
                lbl.text = @"How far are you willing to travel to meet your match?";
                
            }
            else if(section == 3){
                lbl.text = @"Be hidden from everyone other than your current match.";
                
            }
            else if(section == 4){
                lbl.text = @"Recieve push notifications for match updates and messages.";
            }
            footer.backgroundColor=[UIColor clearColor];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textAlignment = NSTextAlignmentLeft;
            [lbl setNumberOfLines:10];//set line if you need
            [lbl setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0]];//font size and style
            [lbl setTextColor:[UIColor blackColor]];
            [footer addSubview:lbl];
            break;
        default:
            break;
    }
    
    
    
    return footer;
}

-(UIColor*)blueColor{
    return [UIColor colorWithRed:0.18 green:0.49 blue:0.83 alpha:1.0];
}


- (IBAction)go_back:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(UIColor*)othBlueColor{
    return [UIColor colorWithRed:0.01 green:0.68 blue:0.80 alpha:1.0];
}

@end
