//
//  NewMatchViewController.m
//  DateApp
//
//  Created by Neil Ballard on 1/1/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "NewMatchConflictViewController.h"

@interface NewMatchConflictViewController ()<MessageViewControllerDelegate>{
    MatchUser *match;
}

@property (strong, nonatomic) IBOutlet UIImageView *match_new;

@property (strong, nonatomic) IBOutlet UIImageView *match_current;

@property (strong, nonatomic) IBOutlet UILabel *mesage_label;

@property (strong, nonatomic) IBOutlet UILabel *match_new_label;
@property (strong, nonatomic) IBOutlet UILabel *match_current_label;
@property (strong, nonatomic) IBOutlet UIButton *option1_btn;
@property (strong, nonatomic) IBOutlet UIButton *option2_btn;

@property (strong, nonatomic) IBOutlet UIView *bg_view;


@end

@implementation NewMatchConflictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.42;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    self.firstTopConstraint.constant = height * 0.075;
    self.currentTopConstraint.constant = height * 0.075;
    self.nTopConstraint.constant = height * 0.075;
    self.labelTopConstraint.constant = height * 0.075;


    self.currentViewWidth.constant = width;
    self.currentViewHeight.constant = width;
    self.nViewWidth.constant = width;
    self.nViewHeight.constant = width;
    
    self.currentView.layer.cornerRadius = width / 2;
    self.nView.layer.cornerRadius = width / 2;
    
    self.currentImageWidth.constant = width - 10;
    self.currentImageHeight.constant = width - 10;
    self.nImageWidth.constant = width - 10;
    self.nImageHeight.constant = width - 10;

    
    self.match_new.layer.cornerRadius = (width / 2) - 5;
    self.match_current.layer.cornerRadius = (width / 2) - 5;

    /*
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    blurView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.bg_view addSubview:blurView];*/
    
 //   self.match_new.image = [self.matched_user.photos objectAtIndex:1];
    
    
    
    if (self.isConflict)
    {
        [self loadUserDataConflict];
    }
    else
    {
        [self loadUserData];
    }
    

    CGFloat dimen = [[UIScreen mainScreen] bounds].size.width - 80;
    CGFloat ht = (dimen - 15) / 5;
    
    self.stayBtnWidth.constant = dimen;
    self.stayBtnHeight.constant = ht;
    
    [self.option1_btn layoutIfNeeded];
    
    CAGradientLayer *gradient2 = [CAGradientLayer layer];
    gradient2.frame = self.option1_btn.bounds;
    gradient2.backgroundColor = [UIColor whiteColor].CGColor;
    gradient2.startPoint = CGPointMake(0.0,0.5);
    gradient2.endPoint = CGPointMake(1.0,0.5);
    [self.option1_btn.layer insertSublayer:gradient2 atIndex:0];
    gradient2.cornerRadius = ht / 2;
    gradient2.masksToBounds = YES;
    self.option1_btn.layer.masksToBounds = NO;
    self.option1_btn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.option1_btn.layer.shadowOpacity = 0.75;
    self.option1_btn.layer.shadowRadius = 1;
    self.option1_btn.layer.shadowOffset = CGSizeZero;
    

}


-(void)loadUserDataConflict
{
    self.match_user = [self.altMatches objectAtIndex:0];
    
    match = [MatchUser currentUser];
    
    NSString *match_name = match.name;
    
  //  self.match_current.image = [match.pics objectAtIndex:0];
    
    [self.match_current sd_setImageWithURL:[NSURL URLWithString:[match.pics objectAtIndex:0]]
                 placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                          options:SDWebImageRefreshCached];
    
    [self.match_new sd_setImageWithURL:[NSURL URLWithString:[self.match_user.pics objectAtIndex:0]]
                          placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                                   options:SDWebImageRefreshCached];
    
    
    self.match_new_label.text = self.match_user.name;
    self.match_current_label.text = match.name;
    
    self.mesage_label.text = [NSString stringWithFormat:@"Looks like you have a\ndecision. Stay with %@ or\nmatch with %@?", match_name, self.match_user.name];
    
  //  self.option1_btn.titleLabel.text = [NSString stringWithFormat:@"Match With %@", self.match_user.name];
//    self.option2_btn.titleLabel.text = @"Ignore";
    
    [self.option1_btn setTitle:[NSString stringWithFormat:@"Match With %@", self.match_user.name] forState:UIControlStateNormal];
    
    [self.option2_btn setTitle:@"Ignore" forState:UIControlStateNormal];
}

-(void)loadUserData
{
    self.match_user = [self.altMatches objectAtIndex:0];
    
    match = [MatchUser currentUser];
    
    NSString *match_name = match.name;
    
  //  User *user = [User currentUser];

    
    //  self.match_current.image = [match.pics objectAtIndex:0];
    
    [self.match_new sd_setImageWithURL:[NSURL URLWithString:[match.pics objectAtIndex:0]]
                          placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                                   options:SDWebImageRefreshCached];
    
    
    [DAServer getProfile:@"" completion:^(User *user, NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
            [self.match_current sd_setImageWithURL:[NSURL URLWithString:[user.pics objectAtIndex:0]]
                                      placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                                               options:SDWebImageRefreshCached];
            });
        } else {
            // update UI to indicate error or take remedial action
        }
    }];
    
    

    
    
    self.match_new_label.text = self.match_user.name;
    self.match_current_label.text = match.name;
    
    self.mesage_label.text = [NSString stringWithFormat:@"You matched with\n%@!", match_name];
    
    //  self.option1_btn.titleLabel.text = [NSString stringWithFormat:@"Match With %@", self.match_user.name];
    //    self.option2_btn.titleLabel.text = @"Ignore";
    
    [self.option1_btn setTitle:@"Send Message" forState:UIControlStateNormal];
    
    [self.option2_btn setTitle:@"Close" forState:UIControlStateNormal];
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
    
    
    
    if (self.isConflict)
    {
        NSString *uid = [NSString stringWithFormat:@"%ld", (long)self.match_user.user_id];
        
        [DAServer dismissAlternateMatch:uid completion:^(NSError *error) {
            // here, update the UI to say "Not busy anymore"
            if (!error) {
                
            } else {
                // update UI to indicate error or take remedial action
            }
        }];
        
        [self.altMatches removeObjectAtIndex:0];
        
        
        if ([self.altMatches count] < 1)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            //reload data for new user
            [self loadUserData];
        }
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    

}

- (IBAction)matchOption:(id)sender
{
    if (self.isConflict)
    {
        NSString *uid = [NSString stringWithFormat:@"%ld", (long)self.match_user.user_id];
        
        [DAServer dropSwapMatch:uid completion:^(NSError *error) {
            // here, update the UI to say "Not busy anymore"
            if (!error) {
                
            } else {
                // update UI to indicate error or take remedial action
            }
        }];
        
        //convert user to MatchUser
        //save result as match to nsuserdefaults
        
        [self saveUser:self.match_user];
        
        [self.altMatches removeObjectAtIndex:0];
        
        
        if ([self.altMatches count] < 1)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"altMatchesNotification" object:self.altMatches userInfo:nil];
            }];
        }
        
    }
    else
    {
        //go to messaging
        [self dismissViewControllerAnimated:NO completion:^(void)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"callSegue" object:self];
         }];
    }
}



-(void)saveUser:(User*)user
{
    MatchUser *match_user = [self convertToMatchUser:user];
    [MatchUser saveAsCurrentMatch:match_user];
}

-(MatchUser*)convertToMatchUser:(User*)user
{
    MatchUser *match_user = [MatchUser new];
    match_user.user_id = user.user_id;
    match_user.name = user.name;
    match_user.bio = user.bio;
    match_user.age = user.age;
    match_user.education = user.edu;
    match_user.work = user.job;
    
    return match_user;
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
    if ([[segue identifier] isEqualToString:@"gotoProfile"])
    {
        
        ProfileViewController *profileVC = (ProfileViewController *)segue.destinationViewController;
        if ([sender tag] == 0)
        {
            profileVC.user = [self convertToUser:match];
        }
        else
        {
            profileVC.user = [self.altMatches objectAtIndex:0];
        }
     //   profileVC.user_data = self.matched_user;
     //   profileVC.mode = @"matched";
        
        
    }
    else if ([segue.identifier isEqualToString:@"startMessageSegue"])
    {
        UINavigationController *nc = segue.destinationViewController;
        MessageViewController *vc = (MessageViewController *)nc.topViewController;
        vc.delegateModal = self;
    }
    
}

-(User*)convertToUser:(MatchUser*)matchUser
{
    User *user = [User new];
    user.user_id = matchUser.user_id;
    user.name = matchUser.name;
    user.bio = matchUser.bio;
    user.age = matchUser.age;
    user.edu = matchUser.education;
    user.job = matchUser.work;
    user.pics = matchUser.pics;
    user.distance = matchUser.distance;
    
    return user;
}

@end
