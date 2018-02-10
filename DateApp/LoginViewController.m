//
//  LoginViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/25/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "LoginViewController.h"
#import "DAGradientColor.h"


@interface LoginViewController ()
{
    UIFont *regularFont;
    UIFont *thickFont;
}
@property (strong, nonatomic) IBOutlet UILabel *dittoHeading;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;
@property (strong, nonatomic) IBOutlet UILabel *privacyLabel;

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@property (strong, nonatomic) IBOutlet UILabel *subLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *subLabelTop;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *stackTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *stackBottom;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   
    self.subLabel.text = @"Sign up to discover and match\nexclusively with people nearby";
  //  [self.dittoHeading layoutIfNeeded];
  //  self.dittoHeading.textColor = [DAGradientColor gradientFromColor:self.dittoHeading.frame.size.width];
    
    CGFloat dimen = [[UIScreen mainScreen] bounds].size.width * 0.75;
    
    CGFloat height = [[UIScreen mainScreen] bounds].size.height * 0.32;
    self.bgViewHeight.constant = height;
   // self.subLabelTop.constant = height * 0.0025;
    self.stackTop.constant = height * 0.15;
    self.stackBottom.constant = height * 0.15;

    
    UIColor *color1 = [UIColor colorWithRed:0.09 green:0.92 blue:0.85 alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:0.08 green:0.77 blue:0.90 alpha:1.0];
    UIColor *color3 = [UIColor colorWithRed:0.08 green:0.67 blue:0.94 alpha:1.0];
    
    [self.bgView layoutIfNeeded];
    
    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.frame = self.bgView.bounds;
    grad.colors = [NSArray arrayWithObjects:(id)([color1 colorWithAlphaComponent:1].CGColor),(id)([color2 colorWithAlphaComponent:1].CGColor),(id)([color3 colorWithAlphaComponent:1].CGColor),nil];
    grad.startPoint = CGPointMake(0.5,0.0);
    grad.endPoint = CGPointMake(0.5,1.0);
    [self.bgView.layer insertSublayer:grad atIndex:0];

    self.btnWidth.constant = dimen;
    
    CGFloat btnheight = (dimen - 15) / 6;
    
    self.btnHeight.constant = btnheight;
    
    [self.loginBtn layoutIfNeeded];
    
    
    CAGradientLayer *gradient2 = [CAGradientLayer layer];
    gradient2.frame = self.loginBtn.bounds;
    gradient2.backgroundColor = [self blueColor].CGColor;
    gradient2.startPoint = CGPointMake(0.0,0.5);
    gradient2.endPoint = CGPointMake(1.0,0.5);
    [self.loginBtn.layer insertSublayer:gradient2 atIndex:0];
    gradient2.cornerRadius = 5;
    gradient2.masksToBounds = YES;
    self.loginBtn.layer.masksToBounds = NO;
    self.loginBtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.loginBtn.layer.shadowOpacity = 0.75;
    self.loginBtn.layer.shadowRadius = 1;
    self.loginBtn.layer.shadowOffset = CGSizeZero;
    
    
    
    regularFont = [UIFont fontWithName:@"RooneySansLF-Regular" size:12];
    thickFont = [UIFont fontWithName:@"RooneySansLF-Medium" size:12];
    
    
    
     NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
     [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"By signing up, you agree to\nour" attributes:@{NSForegroundColorAttributeName :[self grayColor], NSFontAttributeName: regularFont}]];
     [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@" Terms " attributes:@{NSForegroundColorAttributeName : [self grayColor], NSFontAttributeName: thickFont}]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"and have read our" attributes:@{NSForegroundColorAttributeName :[self grayColor], NSFontAttributeName: regularFont}]];
         [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@" Privacy Policy." attributes:@{NSForegroundColorAttributeName : [self grayColor], NSFontAttributeName: thickFont}]];
     self.privacyLabel.attributedText = attrString;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)LoginButtonClicked{

    [DAServer facebookLogin:self completion:^(NSMutableArray *result, NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {

            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        
        } else {
            // update UI to indicate error or take remedial action
        }
    }];
    
}

- (IBAction)loginAction:(id)sender
{
    [DAServer facebookAuth:self completion:^(NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self dismissViewControllerAnimated:YES completion:nil];
                [self performSegueWithIdentifier:@"loginUnwind" sender:self];
            });
            
        } else {
            // update UI to indicate error or take remedial action
        }
    }];
}

-(UIColor*)blueColor
{
    return [UIColor colorWithRed:0.23 green:0.35 blue:0.60 alpha:1.0];
}

-(UIColor*)grayColor
{
    return [UIColor colorWithRed:0.63 green:0.63 blue:0.65 alpha:1.0];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
