//
//  MatchViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/7/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"
#import "LastMessageView.h"
#import "DateApp-Swift.h"

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

@property (strong, nonatomic) IBOutlet UIView *messageInputView;
@property (strong, nonatomic) IBOutlet UIView *messagesContainer;

@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(updateMatch) name:@"updateNewMatch" object:nil];
    
    NSString *str = [[DataAccess singletonInstance] getName];
    
    if ([[DataAccess singletonInstance] UserHasMatch])
    {
        self.user = [MatchUser currentUser];
        
        self.topLabel.text = [NSString stringWithFormat:@"%@, %@", self.user.name, self.user.age];
        
        if (self.user.match_time)
        {
            NSString *matchedTime = [DADateFormatter timeAgoStringFromDate:self.user.match_time];
            if (matchedTime)
            {
                self.middleLabel.text = matchedTime;
            }
            else
            {
                self.middleLabel.text = @"";
            }
        }
        else
        {
            self.middleLabel.text = @"Matched for 3 days";

        }
   //     [self.discoverBtn setHidden:YES];
        [self.discoverBtn setTitle:@"Matched" forState:UIControlStateNormal];
        [self.discoverBtn setBackgroundColor:[self matchColor]];
        [self.nomatch_image setHidden:YES];
        
        if ([[DataAccess singletonInstance] UserHasMessages])
        {
            LastMessageView *messagesView =   [[[NSBundle mainBundle] loadNibNamed:@"LastMessage" owner:self options:nil] firstObject];
            //self.menuView.parentVC = self;
            [self.messagesContainer layoutIfNeeded];
            messagesView.frame = CGRectMake(0, 0, self.messagesContainer.frame.size.width, self.messagesContainer.frame.size.height);
            [self.messagesContainer addSubview:messagesView];
            
            UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(self.messagesContainer.bounds.origin.x, self.messagesContainer.bounds.origin.x, self.messagesContainer.bounds.size.width - (2 * self.messagesContainer.bounds.origin.x), self.messagesContainer.bounds.size.height - (2 * self.messagesContainer.bounds.origin.y))];
            [self.messagesContainer insertSubview:shadowView atIndex:0];
            
            UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:shadowView.bounds cornerRadius:14.0];
            shadowView.layer.masksToBounds = NO;
            shadowView.layer.shadowRadius = 4.0;
            shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
            [shadowView.layer setShadowOffset:CGSizeZero];//CGSizeMake(0.051, -0.070)];
            [shadowView.layer setShouldRasterize:YES];
            [shadowView.layer setShadowOpacity:0.15];
            shadowView.layer.shadowPath = shadowPath.CGPath;
            [self.messageInputView setHidden:YES];
        }
        else
        {
            [self.messageInputView setHidden:NO];
            [self.messageButton setUserInteractionEnabled:YES];
            [self.messagesContainer setHidden:YES];
        }
    }
    else
    {
        self.topLabel.text = @"You're Unmatched";
        self.middleLabel.text = @"Go to the Discover section and\n swipe to find your next match!";
        [self.profilePic setHidden:YES];
        [self.discoverBtn setTitle:@"Discover a Match" forState:UIControlStateNormal];
        [self.discoverBtn setBackgroundColor:[self singleColor]];
        [self.messageInputView setHidden:YES];
        [self.messageButton setUserInteractionEnabled:NO];
    }
    
    CGFloat dimen = [[UIScreen mainScreen] bounds].size.width - 80;
    
    self.picHeight.constant = [[UIScreen mainScreen] bounds].size.width - 112;

    
    [self profilePicFrame];
    
    self.noMatchWidth.constant = self.picHeight.constant;
    self.noMatchHeight.constant = self.picHeight.constant;
    
    self.discoverBtnWidth.constant = self.picHeight.constant;
    
    CGFloat height = (dimen - 15) / 5;
    
    self.discoverBtnHeight.constant = height;
    self.discoverBtn.layer.cornerRadius = height / 2;
    

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
  //  avatarImageViewHolder.layer.shouldRasterize = YES;
    avatarImageViewHolder.clipsToBounds = NO;
    
    /*
    [self.profilePic sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:0]]
                       placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                                options:SDWebImageRefreshCached]; */
    NSURL *url = [NSURL URLWithString:[self.user.pics objectAtIndex:0]];
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    [manager downloadImageWithURL:url
                          options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {  } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished && !error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.user.profileImage = image;
                 CGSize size = CGSizeMake(self.picHeight.constant, self.picHeight.constant);
                 UIImage *resizedImage =  [image scaleImageToSize:size];
                 [self.profilePic setImage:resizedImage];
             });

         }
     }];
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
    [self.messageButton setUserInteractionEnabled:NO];
    [UIView animateWithDuration:2.5f animations:^
     {
         [self.profilePic  setHidden:YES];
         self.topLabel.text = @"You're Unmatched";
         self.middleLabel.text = @"Go to the Discover section and\n swipe to find your next match!";
         [self.discoverBtn setTitle:@"Discover a Match" forState:UIControlStateNormal];
         [self.discoverBtn setBackgroundColor:[self singleColor]];
         //  [self.discoverBtn setHidden:NO];
         [self.nomatch_image setHidden:NO];
         [self.profilePic setHidden:YES];
         [self.messageInputView setHidden:YES];
     }];
}

-(void)updateMatch
{
    [self.messageButton setUserInteractionEnabled:YES];
    [UIView animateWithDuration:2.5f animations:^
     {
         self.user = [MatchUser currentUser];
         
         self.topLabel.text = [NSString stringWithFormat:@"%@, %@", self.user.name, self.user.age];
         NSString *matchedTime = [DADateFormatter timeAgoStringFromDate:self.user.match_time];
         if (matchedTime)
         {
             self.middleLabel.text = matchedTime;
         }
         [self.nomatch_image setHidden:YES];
         [self.messageInputView setHidden:NO];
        /* [self.profilePic sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:0]]
                            placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       if (!error) {
                                           self.profilePic.layer.borderWidth = 0;
                                           self.profilePic.layer.borderColor = [UIColor clearColor].CGColor;
                                           
                                       }
                                   }]; */
         
         if ([self.user.pics count] > 0)
         {
             [PhotoDownloader downloadImage:[self.user.pics objectAtIndex:0] completion:^(UIImage *image, NSError *error)
              {
                  if (image && !error)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          self.profilePic.layer.borderWidth = 0;
                          self.profilePic.layer.borderColor = [UIColor clearColor].CGColor;
                          self.profilePic.image = image;
                      });

                  }
                  
              }];
         }
         

         [self.profilePic setHidden:NO];
         [self.discoverBtn setTitle:@"Matched" forState:UIControlStateNormal];
         [self.discoverBtn setBackgroundColor:[self matchColor]];
       //  [self.discoverBtn setHidden:YES];
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
    
  //  id<SegueProtocol> strongDelegate = self.delegate;
  //  [strongDelegate gotoMessage];

    
    
    NSNotification* notification = [NSNotification notificationWithName:@"goToMessaging" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (IBAction)unmatchAction:(id)sender
{
    
    id<SegueProtocol> strongDelegate = self.delegate;
    [strongDelegate unmatchUser];
}


-(CGRect)profileFrame
{
    CGFloat x = self.profilePic.frame.origin.x;
    CGFloat y = self.profilePic.frame.origin.y;
    UIWindow* myWindow = self.profilePic.window;
    CGPoint pointInWindow = [self.profilePic convertPoint:CGPointMake(x, y) toView:myWindow];
    
    return CGRectMake(pointInWindow.x, pointInWindow.y, self.profilePic.frame.size.width, self.profilePic.frame.size.height);
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
    if (matchUser.profileImage)
    {
        user.profileImage = matchUser.profileImage;
    }
    
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

-(UIColor*)matchColor
{
    return [UIColor colorWithRed:0.93 green:0.26 blue:0.45 alpha:1.0];
}

-(UIColor*)singleColor
{
    return [UIColor colorWithRed:0.22 green:0.59 blue:0.94 alpha:1.0];
}
@end
