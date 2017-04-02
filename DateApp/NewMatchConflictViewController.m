//
//  NewMatchViewController.m
//  DateApp
//
//  Created by Neil Ballard on 1/1/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "NewMatchConflictViewController.h"

@interface NewMatchConflictViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *match_new;

@property (strong, nonatomic) IBOutlet UIImageView *match_current;

@property (strong, nonatomic) IBOutlet UILabel *mesage_label;

@property (strong, nonatomic) IBOutlet UILabel *match_new_label;
@property (strong, nonatomic) IBOutlet UILabel *match_current_label;
@property (strong, nonatomic) IBOutlet UIButton *stay_btn;
@property (strong, nonatomic) IBOutlet UIButton *match_btn;

@property (strong, nonatomic) IBOutlet UIView *bg_view;


@end

@implementation NewMatchConflictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    blurView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.bg_view addSubview:blurView];
    
    self.match_new.image = [self.matched_user.photos objectAtIndex:1];
    self.match_current.image = [UIImage imageNamed:@"girl3"];
    
    NSString *current_match_name = self.matched_user.name;
    
    self.match_new_label.text = current_match_name;
    
    self.mesage_label.text = [NSString stringWithFormat:@"Looks like you have a decision to make! Stay with %@ and ignore this match or let %@ go and match with %@?", current_match_name, current_match_name, @"Sofia"];
    
    self.stay_btn.titleLabel.text = [NSString stringWithFormat:@"Stay With %@", current_match_name];
    self.match_btn.titleLabel.text = [NSString stringWithFormat:@"Match With %@", @"Sofia"];
    
    self.stay_btn.layer.shadowColor = [self greyblueColor].CGColor;
    self.stay_btn.layer.shadowOffset = CGSizeZero;
    self.stay_btn.layer.shadowOpacity = 1.0;
    self.stay_btn.layer.shadowRadius = 1.0;
    
    CAGradientLayer *stay_gradient = [CAGradientLayer layer];
    [self.stay_btn.layer insertSublayer:stay_gradient atIndex:0];
    stay_gradient.frame = self.stay_btn.bounds;
    stay_gradient.colors = [NSArray arrayWithObjects:(id)([UIColor colorWithRed:0.43 green:0.40 blue:0.77 alpha:1.0].CGColor),(id)([UIColor colorWithRed:0.29 green:0.34 blue:0.86 alpha:1.0].CGColor),nil];
    stay_gradient.startPoint = CGPointMake(0.25,0.0);
    stay_gradient.endPoint = CGPointMake(0.25,1.0);
    self.stay_btn.layer.masksToBounds = YES;
    
    self.match_btn.layer.shadowColor = [self greyblueColor].CGColor;
    self.match_btn.layer.shadowOffset = CGSizeZero;
    self.match_btn.layer.shadowOpacity = 1.0;
    self.match_btn.layer.shadowRadius = 1.0;

    CAGradientLayer *gradient = [CAGradientLayer layer];
    [self.match_btn.layer insertSublayer:gradient atIndex:0];
    gradient.frame = self.match_btn.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)([UIColor colorWithRed:0.29 green:0.34 blue:0.86 alpha:1.0].CGColor),(id)([UIColor colorWithRed:0.01 green:0.68 blue:0.80 alpha:1.0].CGColor),nil];
    gradient.startPoint = CGPointMake(0.25,0.0);
    gradient.endPoint = CGPointMake(0.25,1.0);
    self.match_btn.layer.masksToBounds = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIColor*)greyblueColor{
    
    return [UIColor colorWithRed:0.47 green:0.53 blue:0.60 alpha:1.0];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)stayOption:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)matchOption:(id)sender {
}

- (IBAction)profileCurrent:(id)sender {
    [sender setTag:0];
    [self performSegueWithIdentifier:@"gotoProfile" sender:sender];
}

- (IBAction)profileNew:(id)sender {
    [sender setTag:1];
    [self performSegueWithIdentifier:@"gotoProfile" sender:sender];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"gotoProfile"]) {
        
        ProfileViewController *profileVC = (ProfileViewController *)segue.destinationViewController;
     //   profileVC.user_data = self.matched_user;
     //   profileVC.mode = @"matched";
        
        
    }
}

@end
