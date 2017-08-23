//
//  MatchViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/7/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface MatchViewController (){
    UIColor *grayColor;
    UIColor *blackColor;
    UIFont *headerFont;
    UIFont *contentFont;
    UIButton *parentButton;
    NSInteger pic_count;
    UIColor *blueColor;

}


@property (strong, nonatomic) IBOutlet UIButton *matchedBtn;
@property (strong, nonatomic) MatchUser *user;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picHeight;
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UILabel *middleLabel;
@property (strong, nonatomic) IBOutlet UIButton *discoverBtn;
@property (strong, nonatomic) IBOutlet UIImageView *nomatch_image;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *noMatchHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *noMatchWidth;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *discoverBtnHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *discoverBtnWidth;


@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    if ([[DataAccess singletonInstance] UserHasMatch])
    {
        self.user = [MatchUser currentUser];
        
        self.topLabel.text = [NSString stringWithFormat:@"%@, %@", self.user.name, self.user.age];
        self.middleLabel.text = [DADateFormatter timeAgoStringFromDate:self.user.match_time];
        [self.profilePic sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:0]]
                    placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                             options:SDWebImageRefreshCached];
        [self.discoverBtn setHidden:YES];
        [self.nomatch_image setHidden:YES];
        
        
        
    }
    else
    {
   //                                                                                                     self.topLabel.text = @"You're Unmatched";
        self.middleLabel.text = @"Go to the Discover section and\n swipe to find your next match!";
        
    }
    
    CGFloat dimen = [[UIScreen mainScreen] bounds].size.width - 80;
    
    self.picHeight.constant = dimen;
    
    
    [self profilePicFrame];
    
    self.noMatchWidth.constant = dimen;
    self.noMatchHeight.constant = dimen;
    
    self.discoverBtnWidth.constant = dimen;
    
    CGFloat height = (dimen - 15) / 5;
    
    self.discoverBtnHeight.constant = height;
    
    [self.discoverBtn layoutIfNeeded];
    
    UIColor *color1 = [UIColor colorWithRed:0.09 green:0.92 blue:0.85 alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:0.08 green:0.77 blue:0.90 alpha:1.0];
    UIColor *color3 = [UIColor colorWithRed:0.08 green:0.67 blue:0.94 alpha:1.0];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.discoverBtn.bounds;//CGRectMake(47.5, 300, self.discoverBtnWidth.constant, self.discoverBtnHeight.constant);
    gradient.colors = [NSArray arrayWithObjects:(id)([color1 colorWithAlphaComponent:1].CGColor),(id)([color2 colorWithAlphaComponent:1].CGColor),(id)([color3 colorWithAlphaComponent:1].CGColor),nil];
    gradient.startPoint = CGPointMake(0.0,0.5);
    gradient.endPoint = CGPointMake(1.0,0.5);
    [self.discoverBtn.layer insertSublayer:gradient atIndex:0];
    gradient.cornerRadius = height / 2;
    gradient.masksToBounds = YES;
    self.discoverBtn.layer.masksToBounds = NO;
    self.discoverBtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.discoverBtn.layer.shadowOpacity = 0.75;
    self.discoverBtn.layer.shadowRadius = 3;
    self.discoverBtn.layer.shadowOffset = CGSizeZero;
    

    self.nomatch_image.layer.masksToBounds = NO;
    self.nomatch_image.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.nomatch_image.layer.shadowOpacity = 0.75;
    self.nomatch_image.layer.shadowRadius = 1;
    self.nomatch_image.layer.shadowOffset = CGSizeZero;
    
    [self.nomatch_image setUserInteractionEnabled:NO];

    
    /*
    self.profilePic.layer.shadowOffset = CGSizeMake(-5.0, 5.0);
    self.profilePic.layer.shadowRadius = 5.0;
    self.profilePic.layer.shadowOpacity = 0.6;
    self.profilePic.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.profilePic.layer.masksToBounds = NO; */

   // self.profilePic.layer.cornerRadius = ;

    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(currentMatchNotification:) name:@"currentMatchNotification" object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToProfile)];
    [self.profilePic addGestureRecognizer:tapGesture];
    
    
}

-(void)profilePicFrame
{
    
    CGFloat dimen = [[UIScreen mainScreen] bounds].size.width - 80;
    
    UIView *avatarImageViewHolder = [[UIView alloc] initWithFrame:self.profilePic.frame];
    avatarImageViewHolder.backgroundColor = [UIColor clearColor];
    [self.profilePic.superview addSubview:avatarImageViewHolder];
    //[avatarImageView removeFromSuperview];//only use this if your object retains its' properties after being removedFromSuperview. (ARC? idk)
    [avatarImageViewHolder addSubview:self.profilePic];
    self.profilePic.center = CGPointMake(avatarImageViewHolder.frame.size.width/2.0f, avatarImageViewHolder.frame.size.height/2.0f);
    
    
    self.profilePic.layer.masksToBounds = YES;
    avatarImageViewHolder.layer.masksToBounds = NO;
    
    
    // set avatar image corner
    self.profilePic.layer.cornerRadius = dimen / 2;
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


- (void)currentMatchNotification:(NSNotification *)notification
{

   // [self loadUserData];
    
}



- (void)didReceiveMemoryWarning
{
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

-(void)updateUnmatch
{
    [UIView animateWithDuration:2.5f animations:^
     {
         [self.profilePic  setHidden:YES];
         self.topLabel.text = @"You're Unmatched";
         self.middleLabel.text = @"Go to the Discover section and\n swipe to find your next match!";
         [self.discoverBtn setHidden:NO];
         [self.nomatch_image setHidden:YES];
         [self.profilePic setHidden:NO];
     }];
}

-(void)updateMatch
{
    [UIView animateWithDuration:2.5f animations:^
     {
         self.user = [MatchUser currentUser];
         
         self.topLabel.text = [NSString stringWithFormat:@"%@, %@", self.user.name, self.user.age];
         self.middleLabel.text = [DADateFormatter timeAgoStringFromDate:self.user.match_time];
         [self.nomatch_image setHidden:YES];
         [self.profilePic sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:0]]
                            placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                                     options:SDWebImageRefreshCached];
         [self.profilePic setHidden:NO];
         [self.discoverBtn setHidden:YES];
         [self.nomatch_image setHidden:YES];
     }];
}



- (IBAction)imageTap:(id)sender
{
    [self performSegueWithIdentifier:@"gotoAlbums" sender:self];
}





-(void)UnmatchSelected:(UIButton*)parentBtn
{
    /*
    parentButton = parentBtn;
    
    [UIView animateWithDuration:2.5f animations:^
     {
         [self alphaAllViews:0.55];

         
         [UIView animateWithDuration:2.5 animations:^{
             [self alphaAllViews:0.35];
             
             [UIView animateWithDuration:1.5 animations:^{
                 [self alphaAllViews:0.15];
                 self.single_label.alpha = 0.10;
                 [self.single_label setHidden:NO];
                 
                 [UIView animateWithDuration:1.5 animations:^{
                     [self alphaAllViews:0.00];
                     self.single_label.alpha = 0.35;
                     
                 }];
                 
             }];
             
         }];
         
         
     }]; */
    
}


-(void)alphaAllViews:(double)value
{
    /*
    self.match_time_label.alpha = value;
    self.name_label.alpha = value;
    self.match_time_label.alpha = value;
    self.messageBtn.alpha = value;
    self.age_label.alpha = value;
    self.name_label.alpha = value;
    self.chat_icon.alpha = value;
    parentButton.alpha = value;
    self.messageBtn.userInteractionEnabled = NO; */
}

- (IBAction)goToMessaging:(id)sender
{
    
    id<SegueProtocol> strongDelegate = self.delegate;
    [strongDelegate gotoMessage];

    
    /*
    NSNotification* notification = [NSNotification notificationWithName:@"goToMessaging" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification]; */
}

- (IBAction)unmatchAction:(id)sender
{
    
    id<SegueProtocol> strongDelegate = self.delegate;
    [strongDelegate unmatchUser];
}



-(UIColor*)grayColor{
    
    return [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
}


-(UIColor*)grayBG
{
    return [UIColor colorWithRed:0.90 green:0.90 blue:0.92 alpha:1.0];
}

-(UIColor*)blueBG
{
    return [UIColor colorWithRed:0.09 green:0.55 blue:1.00 alpha:1.0];
}

-(UIColor*)purpleColor{
    return [UIColor colorWithRed:0.57 green:0.67 blue:0.90 alpha:1.0];
}


-(void)goToProfile
{
    if ([[DataAccess singletonInstance] UserHasMatch])
    {
        id<GoToProfileProtocol> strongDelegate = self.profile_delegate;
        [strongDelegate selectedProfile:[self convertToUser:self.user] matched:YES];
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

- (IBAction)goDiscover:(id)sender
{
    id<GoDiscoverProtocol> strongDelegate = self.discoverDelegate;
    [strongDelegate discoverSelected];
}

-(UIColor*)shadowColor
{
    return [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.0];
}

@end
