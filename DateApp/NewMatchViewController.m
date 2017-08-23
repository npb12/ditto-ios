//
//  NewMatchViewController.m
//  DateApp
//
//  Created by Neil Ballard on 1/5/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "NewMatchViewController.h"

@interface NewMatchViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *match_image;
- (IBAction)viewProfile:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *message_label;
@property (strong, nonatomic) IBOutlet UIView *bg_view;
@property (strong, nonatomic) IBOutlet UIButton *search_btn;
@property (strong, nonatomic) IBOutlet UIButton *message_btn;
@property (strong, nonatomic) IBOutlet UILabel *match_label;

@end

@implementation NewMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    blurView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.bg_view addSubview:blurView];
    /*
    self.match_image.image = [self.matched_user.photos objectAtIndex:1];
    
    NSString *current_match_name = self.matched_user.name;
    
    self.match_label.text = current_match_name;
    
    self.message_label.text = [NSString stringWithFormat:@"Looks like you have a decision to make! Stay with %@ and ignore this match or let %@ go and match with %@?", current_match_name, current_match_name, @"Sofia"];
    */
    
    self.search_btn.layer.shadowColor = [self greyblueColor].CGColor;
    self.search_btn.layer.shadowOffset = CGSizeZero;
    self.search_btn.layer.shadowOpacity = 1.0;
    self.search_btn.layer.shadowRadius = 1.0;
    
    self.message_btn.layer.shadowColor = [self greyblueColor].CGColor;
    self.message_btn.layer.shadowOffset = CGSizeZero;
    self.message_btn.layer.shadowOpacity = 1.0;
    self.message_btn.layer.shadowRadius = 1.0;
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

- (IBAction)keepSearching:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goMessage:(id)sender {
}
- (IBAction)viewProfile:(id)sender {
    [self performSegueWithIdentifier:@"goProfile" sender:sender];

}

-(UIColor*)greyblueColor{
    
    return [UIColor colorWithRed:0.47 green:0.53 blue:0.60 alpha:1.0];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goProfile"]) {
        
        ProfileViewController *profileVC = (ProfileViewController *)segue.destinationViewController;
     //   profileVC.user_data = self.matched_user;
      //  profileVC.mode = @"matched";
        
        
    }
}
@end
