//
//  UserLandingViewController.m
//  DateApp
//
//  Created by Neil Ballard on 7/3/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "UserLandingViewController.h"

@interface UserLandingViewController ()
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UILabel *middleLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picHeight;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *settingsBtn;
@property (strong, nonatomic) IBOutlet UIView *gradientView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *editBtnWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *editBtnHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *settingsBtnHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *settingsBtnWidth;

@end

@implementation UserLandingViewController
{
    BOOL notInitial;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.headerLabel.textColor = [DAGradientColor gradientFromColor:self.headerLabel.frame.size.width];
    
    self.picHeight.constant = [[UIScreen mainScreen] bounds].size.width - 112;
    
    if (notInitial)
    {
        [self getData];
        notInitial = YES;
    }
    
 //   self.profilePic.layer.masksToBounds = YES;
  //  self.profilePic.layer.cornerRadius = self.picHeight.constant / 2;
    
    [self profilePicFrame];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoProfile)];
    [self.profilePic addGestureRecognizer:tapGesture];
    
    self.profilePic.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.profilePic.layer.borderWidth = 1;

    CGFloat dimen = [[UIScreen mainScreen] bounds].size.width - 80;
    CGFloat height = (dimen - 15) / 5;
    
    self.editBtnWidth.constant = dimen;
    self.editBtnHeight.constant = height;
    [self.editBtn layoutIfNeeded];
    
    UIColor *color1 = [UIColor colorWithRed:0.09 green:0.92 blue:0.85 alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:0.08 green:0.77 blue:0.90 alpha:1.0];
    UIColor *color3 = [UIColor colorWithRed:0.08 green:0.67 blue:0.94 alpha:1.0];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.editBtn.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)([color1 colorWithAlphaComponent:1].CGColor),(id)([color2 colorWithAlphaComponent:1].CGColor),(id)([color3 colorWithAlphaComponent:1].CGColor),nil];
    gradient.startPoint = CGPointMake(0.0,0.5);
    gradient.endPoint = CGPointMake(1.0,0.5);
    [self.editBtn.layer insertSublayer:gradient atIndex:0];
    gradient.cornerRadius = height / 2;
    gradient.masksToBounds = YES;
    self.editBtn.layer.masksToBounds = NO;
    self.editBtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.editBtn.layer.shadowOpacity = 0.75;
    self.editBtn.layer.shadowRadius = 3;
    self.editBtn.layer.shadowOffset = CGSizeZero;
  //  self.editBtn.layer.shouldRasterize = YES;
    
    
    [self.gradientView layoutIfNeeded];
    
    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.frame = self.gradientView.bounds;
    grad.colors = [NSArray arrayWithObjects:(id)([color1 colorWithAlphaComponent:1].CGColor),(id)([color2 colorWithAlphaComponent:1].CGColor),(id)([color3 colorWithAlphaComponent:1].CGColor),nil];
    grad.startPoint = CGPointMake(0.0,0.5);
    grad.endPoint = CGPointMake(1.0,0.5);
    [self.gradientView.layer insertSublayer:grad atIndex:0];
    
    self.settingsBtnWidth.constant = dimen;
    self.settingsBtnHeight.constant = height;
    [self.settingsBtn layoutIfNeeded];

    CAGradientLayer *gradient2 = [CAGradientLayer layer];
    gradient2.frame = self.settingsBtn.bounds;
  //  gradient2.colors = [NSArray arrayWithObjects:(id)([[UIColor whiteColor] colorWithAlphaComponent:1].CGColor),nil];
    gradient2.backgroundColor = [UIColor whiteColor].CGColor;
    gradient2.startPoint = CGPointMake(0.0,0.5);
    gradient2.endPoint = CGPointMake(1.0,0.5);
    [self.settingsBtn.layer insertSublayer:gradient2 atIndex:0];
    gradient2.cornerRadius = height / 2;
    gradient2.masksToBounds = YES;
    self.settingsBtn.layer.masksToBounds = NO;
    self.settingsBtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.settingsBtn.layer.shadowOpacity = 0.75;
    self.settingsBtn.layer.shadowRadius = 1;
    self.settingsBtn.layer.shadowOffset = CGSizeZero;
 //   self.settingsBtn.layer.shouldRasterize = YES;
    
     
    
   // self.settingsBtn.titleLabel.textColor = [UIColor blueColor];[DAGradientColor gradientFromColor:self.settingsBtn.titleLabel.frame.size.width];
    
  //  [self.settingsBtn setTitleColor:[DAGradientColor gradientFromColor:self.settingsBtn.titleLabel.frame.size.width] forState:UIControlStateNormal];
    
     //   [self.settingsBtn setTitleColor:[DAGradientColor gradientFromColor:self.settingsBtn.titleLabel.frame.size.width] forState:UIControlStateNormal];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    if (!notInitial)
    {
        [self getData];
    }
}

-(void)profilePicFrame
{
    
    [self.profilePic layoutIfNeeded];
    
    UIView *avatarImageViewHolder = [[UIView alloc] initWithFrame:self.profilePic.frame];
    avatarImageViewHolder.backgroundColor = [UIColor clearColor];
    [self.profilePic.superview addSubview:avatarImageViewHolder];
    //[avatarImageView removeFromSuperview];//only use this if your object retains its' properties after being removedFromSuperview. (ARC? idk)
    [avatarImageViewHolder addSubview:self.profilePic];
    self.profilePic.center = CGPointMake(avatarImageViewHolder.frame.size.width/2.0f, avatarImageViewHolder.frame.size.height/2.0f);
    
    
    self.profilePic.layer.masksToBounds = YES;
    avatarImageViewHolder.layer.masksToBounds = NO;
    
    
    // set avatar image corner
    self.profilePic.layer.cornerRadius = self.picHeight.constant / 2;
    // set avatar image border
    //  [self.avatarImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    //  [self.avatarImageView.layer setBorderWidth: 2.0];
    
    // set holder shadow
    
    [avatarImageViewHolder.layer setShadowOffset:CGSizeZero];
    [avatarImageViewHolder.layer setShadowOpacity:0.5];
    [avatarImageViewHolder.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    avatarImageViewHolder.layer.shouldRasterize = YES;
    avatarImageViewHolder.clipsToBounds = NO;
}

-(void)getData
{
    [DAServer getProfile:^(User *user, NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.user = user;
                [self populate];
            });
        } else {
            // update UI to indicate error or take remedial action
        }
    }];
}

-(void)populate
{
    
    self.topLabel.text = [NSString stringWithFormat:@"%@, %@", self.user.name, self.user.age];
    
    if (self.user.job && ![self.user.job isEqualToString:@""])
    {
        self.middleLabel.text = self.user.job;
    }
    else if (self.user.edu && ![self.user.edu isEqualToString:@""])
    {
        self.middleLabel.text = self.user.edu;
    }
    else
    {
        
        self.middleLabel.text = @"Go to Edit Profile to add more info about yourself.";
    }
    
    [self getPhotoData];
}

-(void)getPhotoData
{
    if ([self.user.pics count] > 0) {
        
        [PhotoDownloader downloadImage:[self.user.pics objectAtIndex:0] completion:^(UIImage *image, NSError *error)
         {
             if (image && !error)
             {
                 self.profilePic.layer.borderWidth = 0;
                 self.profilePic.layer.borderColor = [UIColor clearColor].CGColor;
                 CGSize size = CGSizeMake(self.picHeight.constant, self.picHeight.constant);
                 UIImage *scaledImage = [image scaleImageToSize:size];
                 self.profilePic.image = scaledImage;
             }
             
         }];
        
        /*
         [self.profilePic sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:0]]
         placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         if (!error) {
         self.profilePic.layer.borderWidth = 0;
         self.profilePic.layer.borderColor = [UIColor clearColor].CGColor;
         
         }
         }]; */
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)imageTap:(id)sender
{
 //   [self performSegueWithIdentifier:@"gotoAlbums" sender:self];
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editAction:(id)sender
{
    [self performSegueWithIdentifier:@"EditSeg" sender:self];
}

- (IBAction)settingsBtn:(id)sender
{
    [self performSegueWithIdentifier:@"SettingsSeg" sender:self];
}

-(void)gotoProfile
{
    [self performSegueWithIdentifier:@"myprofileSegue" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[ProfileViewController class]])
    {
        
        ProfileViewController *profileVC = segue.destinationViewController;
        profileVC.user = self.user;
        profileVC.isMine = YES;
        
    }
    else if ([segue.destinationViewController isKindOfClass:[EditPhotosViewController class]])
    {
        
        EditPhotosViewController *profileVC = segue.destinationViewController;
        profileVC.user = self.user;
        
    }
    else if ([segue.destinationViewController isKindOfClass:[SettingsViewController class]])
    {
        SettingsViewController *settingsVC = segue.destinationViewController;
        settingsVC.settings = self.user;
    }
}

@end
