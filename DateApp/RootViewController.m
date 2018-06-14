//
//  RootViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/7/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "RootViewController.h"
#import "DAGradientColor.h"
#import "MenuView.h"
#import <DateApp-Swift.h>
#import "TutorialViewController.h"

@interface RootViewController ()<GoToProfileProtocol,LikedProfileProtocol, UIViewControllerTransitioningDelegate, TwicketSegmentedControlDelegate>
{
    int nCurIdx, nPrevIdx;
    UIColor* purpleColor;
    BOOL isMatch;
    BOOL isMine;
    BOOL notif;
    CGFloat height;
    CGFloat pvcHeight;
    BOOL observerActive;
    BOOL hamburgerMenuIsVisible;
    UIColor *headerColor;
    BOOL tutorialWasShown;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) SwipeViewController *swipeVC;
@property (strong, nonatomic) MatchViewController *matchVC;
@property (strong, nonatomic) MenuViewController *menuVC;
@property (strong, nonatomic) IBOutlet UIView *menuContainer;
@property (strong, nonatomic) IBOutlet UIButton *matchBtn;
@property (strong, nonatomic) IBOutlet UIImageView *matchImg;

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@property (strong, nonatomic) NSMutableArray *altMatches;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UIImageView *proImage;

@property (strong, nonatomic) IBOutlet UIButton *profileBtn;
@property (strong, nonatomic) IBOutlet UIButton *likeBtn;
@property (strong, nonatomic) IBOutlet UIButton *unmatchBtn;
@property (strong, nonatomic) IBOutlet UIView *matchView;

@property (strong, nonatomic) MenuView *menuView;

@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) UINavigationBar *navBar;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nav_height;

@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) IBOutlet UIButton *noButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (strong, nonatomic) IBOutlet UILabel *discoverLabel;
@property (strong, nonatomic) IBOutlet UILabel *mymatchLabel;

@property (strong, nonatomic) PresentStoryViewAnimationController *storyVC;
@property (strong, nonatomic) DismissStoryViewAnimationController *dismissVC;


@end

@implementation RootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
 //   self.storyVC = [PresentStoryViewAnimationController new];
 //   self.dismissVC = [DismissStoryViewAnimationController new];
    [self initViewController];
    self.storyVC = [PresentStoryViewAnimationController new];
    self.dismissVC = [DismissStoryViewAnimationController new];
    
    if ([[DataAccess singletonInstance] UserIsLoggedIn])
    {
        if ([[DataAccess singletonInstance] UserHasMatch])
        {
            [DAServer getMessages:^(NSArray *messages, NSError *err){
                if ([messages count] > 0)
                {
                    [[DataAccess singletonInstance] setUserHasMessages:YES];
                }
                else
                {
                    [[DataAccess singletonInstance] setUserHasMessages:NO];
                }
            }];
        }
    }
    

}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets safeAreaInsets = self.view.safeAreaInsets;
    
    CGFloat top = safeAreaInsets.top + self.topViewHeight.constant;
    CGFloat bottom = safeAreaInsets.bottom + self.nav_height.constant;
    pvcHeight = self.view.frame.size.height - (top + bottom);
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, pvcHeight);
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    if (![[DataAccess singletonInstance] UserIsLoggedIn])
    {
       // [self performSegueWithIdentifier:@"tutorialSegue" sender:self];
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
    else
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] registerForRemoteNotifications];

        [self setLocationObserver];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationEnteredForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(altMatchesNotification:) name:@"altMatchesNotification" object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(updateLastMessageUI) name:@"newMessage" object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(currentMatchNotification:) name:@"currentMatchNotification" object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(noMatchNotification:) name:@"noMatchNotification" object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(setLocationObserver:) name:@"setLocationObserver" object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(goToMessaging) name:@"goToMessaging" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(goToMessaging)
                                                     name: @"callSegue"
                                                   object: nil];
        
        
        if (self.menuView)
        {
            [self.menuView displayData];
        }
    }
}


-(void)runSetupAfterLogin
{
    
    if (![[DataAccess singletonInstance] IsReturningUser])
    {
        if (!tutorialWasShown)
        {
            tutorialWasShown = YES;
            [self performSegueWithIdentifier:@"tutorialSegue" sender:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"selectionVC" sender:self];
        }

        return;
    }
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] registerForRemoteNotifications];

    [self setLocationObserver];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(altMatchesNotification:) name:@"altMatchesNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(currentMatchNotification:) name:@"currentMatchNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(noMatchNotification:) name:@"noMatchNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(setLocationObserver:) name:@"setLocationObserver" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(goToMessaging) name:@"goToMessaging" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(goToMessaging)
                                                 name: @"callSegue"
                                               object: nil];
    
    if (self.menuView)
    {
        [self.menuView displayData];
    }
}

- (void)applicationEnteredForeground:(NSNotification *)notification {
    NSLog(@"Application Entered Foreground");
    if ([[DataAccess singletonInstance] UserIsLoggedIn])
    {
        if (self.swipeVC)
        {
            if (!observerActive)
            {
                if ([self.swipeVC noUsers])
                {
                    [self setLocationObserver];
                }
                else
                {
                    
                /*
                    [DAServer getMatchesData:NO completion:^(NSError *error) {
                        // here, update the UI to say "Not busy anymore"
                        if (!error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                ///  [self.chatBtn setImage:[UIImage imageNamed:@"chat_full_message"] forState:UIControlStateNormal];
                            });
                        } else {
                            // update UI to indicate error or take remedial action
                        }
                    }]; */
                }
            }
        }
    }
}

-(void)setLocationObserver:(NSNotification *)notification
{
    [self setLocationObserver];
}

-(void)setLocationObserver
{
    if ([self.swipeVC noUsers])
    {
        if (CLLocationCoordinate2DIsValid(self.curr_location) && self.curr_location.latitude != 0 && self.curr_location.longitude != 0)
        {
            [self runLocationRequest];
        }
        else
        {
            [LocationManager sharedInstance];
            [[LocationManager sharedInstance] addObserver:self forKeyPath:@"location" options:NSKeyValueObservingOptionNew context:nil];
            observerActive = YES;
        }
    }
}

-(void)updateLastMessageUI
{
    [DAServer getMessages:^(NSArray *messages, NSError *err){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self.navigationController.topViewController isKindOfClass:[ConversationViewController class]])
            {
                Message *message = [messages lastObject];
                if(message.type == RECEIVED_MESSAGE)
                {
                    message.unread = YES;
                    MatchMessages *matchMessage = [MatchMessages new];
                    matchMessage.lastMessage = message;
                    [MatchMessages saveAsLastMessage:matchMessage];
                }
            }
            
            if (self.matchVC)
            {
                [self.matchVC setMessageUI];
            }
        });
    }];
}

-(void)initViewController{
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)([[UIColor whiteColor] colorWithAlphaComponent:1.0].CGColor),(id)([[self bgGray] colorWithAlphaComponent:1].CGColor),nil];
    gradient.startPoint = CGPointMake(0.5,0.0);
    gradient.endPoint = CGPointMake(0.5,1.0);
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    self.pageTitles = @[@"VC1", @"VC2"];
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.delegate = self;
    
    
  //  SwipeViewController *startingViewController = [self dailyControllerAtIndex:1];
    SwipeViewController *startingViewController = [self dailyControllerAtIndex:1];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    nCurIdx = 0;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height * 0.095;
    
    self.topViewHeight.constant = [UIScreen mainScreen].bounds.size.height * 0.0875;

    self.nav_height.constant = 0;//[UIScreen mainScreen].bounds.size.height * 0.15;
    
    CGFloat sideSize = width / 9.5;
    CGFloat bigSize = width / 5;


    self.profileBtn.frame = CGRectMake(20,sideSize * 1.1,sideSize,sideSize);
    self.unmatchBtn.frame = CGRectMake(width / 1.2,sideSize * 1.1,sideSize,sideSize);
    
    [self.profileBtn setBackgroundColor:[UIColor clearColor]];
    [self.profileBtn setAlpha:0.9];
    self.profileBtn.layer.masksToBounds = NO;

    self.likeBtn.frame = CGRectMake(self.view.frame.size.width / 1.9,bigSize * 0.125,bigSize,bigSize);
    
    [self addChildViewController:_pageViewController];
    [self.containerView addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
  //  [self.view bringSubviewToFront:self.bottomView];
    
    self.indicatorView.frame = CGRectMake(30, self.topViewHeight.constant - 6, 30, 4);
    self.indicatorView.layer.cornerRadius = 1;
    self.indicatorView.layer.masksToBounds = YES;
    
    self.noButton.frame = CGRectMake(self.view.frame.size.width / 4.1,bigSize * 0.125,bigSize,bigSize);

    self.chatBtn.frame = CGRectMake(self.view.frame.size.width / 2 - (bigSize / 2),bigSize * 0.125,bigSize,bigSize);
    
   // self.discoverLabel.textColor = [DAGradientColor gradientFromColor:self.discoverLabel.frame.size.width];
    
    
    if (![[DataAccess singletonInstance] UserHasMatch])
    {
        self.matchImg.image = [UIImage imageNamed:@"match_inactive"];
        [self.matchBtn setUserInteractionEnabled:NO];
    
    }
    else
    {
        self.matchImg.image = [UIImage imageNamed:@"match_active"];
        [self.matchBtn setUserInteractionEnabled:YES];
    }

    [self.chatBtn setAlpha:1.0];
    [self.chatBtn setHidden:YES];
    
    self.proImage.layer.cornerRadius = 17.5;
    self.proImage.layer.masksToBounds = YES;
 //   [self setProfileImage];
    
    
    /*
    self.topView.layer.masksToBounds = NO;
    self.topView.layer.shadowOffset = CGSizeMake(-1, 1);
    self.topView.layer.shadowRadius = 1;
    self.topView.layer.shadowOpacity = 0.1; */
    
    
    NSArray *titles = @[@"DISCOVER", @"MY MATCH"];
    
    
    /*
    self.twicketControl = [TwicketSegmentedControl new];
    [self.twicketControl setSegmentItems:titles];
    self.twicketControl.delegate = self;
    CGFloat twidth = width * 0.5;
    CGFloat theight = 37.5;
    self.twicketControl.frame = CGRectMake((width / 2) - (twidth / 2), (self.topViewHeight.constant / 2) - (theight / 2) - 5, twidth, theight);

    
    [self.topView addSubview:self.twicketControl]; */
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.menuView =   [[[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:self options:nil] firstObject];
    self.menuView.parentVC = self;
    self.menuView.frame = CGRectMake(0, 0, 300, screenHeight);
    [self.menuContainer addSubview:self.menuView];
}

- (IBAction)hamburgerAction:(id)sender
{
    if (!hamburgerMenuIsVisible)
    {
        self.menuTrailing.constant = 300;
        hamburgerMenuIsVisible = YES;
        [self.menuButton setHidden:NO];
        [self.menuButton setUserInteractionEnabled:YES];
        [self animationOpen];
    }
    else
    {
        [self closeMenu];
    }
    
}

- (IBAction)outsideTouch:(id)sender
{
    [self closeMenu];
}

-(void)setProfileImage
{
    self.user = [User currentUser];
    
    if (!self.user)
    {
        [DAServer getProfile:^(User *settings, NSError *error) {
            // here, update the UI to say "Not busy anymore"
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadPhoto];
                });
            } else {
                // update UI to indicate error or take remedial action
            }
        }];
    }
    else
    {
        [self loadPhoto];
    }
}

-(void)loadPhoto
{
    [PhotoDownloader downloadImage:[self.user.pics objectAtIndex:0] completion:^(UIImage *image, NSError *error)
     {
         if (image && !error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.user.profileImage = image;
                 CGSize size = CGSizeMake(40, 40);
                 UIImage *scaledImage = [image scaleImageToSize:size];
                 self.proImage.image = scaledImage;
             });
         }
         
     }];
}

-(void)closeMenu
{
    self.menuTrailing.constant = 0;
    hamburgerMenuIsVisible = NO;
    [self.menuButton setHidden:YES];
    [self.menuButton setUserInteractionEnabled:NO];
    [self animationClose];
}

-(void)animationClose
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{[self.view layoutIfNeeded];} completion:nil];
}

-(void)animationOpen
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{[self.view layoutIfNeeded];} completion:nil];
}

/*
-(void) onMiddleClick {
    
    
    
    
    if (nCurIdx == 0) {
        
        NSArray * controllerArray = self.pageViewController.childViewControllers;
        
        

        SwipeViewController *swipeVC;
        
        for (UIViewController *controller in controllerArray){
            if([controller isKindOfClass:[SwipeViewController class]])
            {
                swipeVC = (SwipeViewController*) controller;
            }
        }
        
        if (swipeVC)
        {
            if (![[DataAccess singletonInstance] UserHasMatch])
            {
                [self showHeartAnimation];
                [swipeVC likeCurrentCard];
            }

        }
        return;
    }
    
    
    NSInteger orient;

    if( nPrevIdx == 0 )
        orient = UIPageViewControllerNavigationDirectionForward;
    else
        orient = UIPageViewControllerNavigationDirectionReverse;
 
    [self offsetScrol:1];
    


    if (!self.swipeVC) {
        self.swipeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SwipeVC"];
    }
    self.swipeVC.pageIndex = 1;
    if( self.swipeVC ) {
        [self.pageViewController setViewControllers:@[self.swipeVC]
                                          direction:orient
                                           animated:YES
                                         completion:nil];
    }
} */

-(void) onRightClick
{
    if([[DataAccess singletonInstance] UserHasMatch])
    {
        [self unmatchUser];
    }
}

- (IBAction)tap:(id)sender {
    NSLog(@"tap");
}


-(void)noSwipingAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Swiper no swiping!"
                                                                   message:@"You can't swipe while matched with someone."
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OKAY"
                                                          style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                              
                                                          }]; // 2
    
    
    [alert addAction:firstAction]; // 4
    
    [self presentViewController:alert animated:YES completion:nil]; // 6
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) offsetScrol : (int) i {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 0.1;
    
    nCurIdx = i;
    
    
    if( i == 0 ) {
        [UIView animateWithDuration:duration animations:^{

            self.indicatorView.alpha = 1;
 //           self.indicatorView.frame = CGRectMake(10, self.topViewHeight.constant, width/2 - 10, 2);
            self.indicatorView.frame = CGRectMake(30, self.topViewHeight.constant - 6, 30, 4);
            [self.noButton setHidden:NO];
            [self.likeBtn setHidden:NO];
            [self.chatBtn setAlpha:0];
            [self.chatBtn setHidden:YES];
            [self.profileBtn setHidden:NO];
            [self.mymatchLabel setTextColor:[self grayColor]];
            self.discoverLabel.textColor = [self baseColor];
            [self.mymatchLabel setAlpha:0.5];
            [self.discoverLabel setAlpha:1.0];
            
            //[DAGradientColor gradientFromColor:self.discoverLabel.frame.size.width];
            
        }];
        
    } else if( i == 1 ) {
        [UIView animateWithDuration:duration animations:^{
   
       //     self.indicatorView.frame = CGRectMake(width/2, self.topViewHeight.constant, width/2 - 10, 2);
            self.indicatorView.frame = CGRectMake(self.matchView.frame.origin.x, self.topViewHeight.constant - 6, 30, 4);
            [self.noButton setHidden:YES];
            [self.likeBtn setHidden:YES];
            [self.discoverLabel setTextColor:[self grayColor]];
            self.mymatchLabel.textColor = [self baseColor];
            [self.mymatchLabel setAlpha:1.0];
            [self.discoverLabel setAlpha:0.5];
            //[DAGradientColor gradientFromColor:self.mymatchLabel.frame.size.width];

            
            if (![[DataAccess singletonInstance] UserHasMatch])
            {
           //     [self.profileBtn setHidden:YES];
                [self.chatBtn setAlpha:0.0];
                [self.chatBtn setHidden:YES];

            }
            else
            {
           //     [self.profileBtn setHidden:NO];
                [self.chatBtn setAlpha:1.0];
                [self.chatBtn setHidden:NO];

            }
            
            
        }];
    }

}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((SwipeViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    if (index == 0) {
        if (!self.menuVC) {
            self.menuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];

        }
        self.menuVC.pageIndex = index;
        return self.menuVC;
        
    }else if(index == 1){
        if (!self.swipeVC) {
           self.swipeVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"SwipeVC"];

        }
        self.swipeVC.pageIndex = index;
        return self.swipeVC;
    }else{
        
        if (!self.matchVC) {
            self.matchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchVC"];

        }
        self.matchVC.pageIndex = index;
        return self.matchVC;
    }
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((SwipeViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    if (index == 0) {
        if (!self.menuVC) {
            self.menuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
        }
        self.menuVC.pageIndex = index;
        return self.menuVC;
        
    }else if(index == 1){
        if (!self.swipeVC) {
            self.swipeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SwipeVC"];
        }
        self.swipeVC.pageIndex = index;
        return self.swipeVC;
    }else{
        if (!self.matchVC) {
            self.matchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchVC"];
        }
        
        self.matchVC.pageIndex = index;
        return self.matchVC;
    }
}


- (SwipeViewController *)dailyControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    if (!self.swipeVC) {
        self.swipeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SwipeVC"];
        self.swipeVC.profile_delegate = self;
    }
  //  SwipeViewController *dailyVC =
    self.swipeVC.pageIndex = index;

    
    return self.swipeVC;
}

- (MatchViewController *)matchControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    if (!self.matchVC) {
        self.matchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchVC"];
    }
    self.matchVC.pageIndex = index;
    return self.matchVC;
}



- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


#pragma mark - UIPageViewController delegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
    //    NSInteger nCurIx = ((ViewControllerOne*)[pageViewController.viewControllers lastObject]).pageIndex;
    //    NSLog( @"willTransition %d", (int)nCurIx);
    
}

// Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    //    NSLog( @"didFinishAnimating");
    
    if (!completed)
    {
        return;
    }
    
    NSInteger index = ((MenuViewController*)[pageViewController.viewControllers lastObject]).pageIndex;
    if (index != 1) {
     //   [likeBtn setImage:[UIImage imageNamed:@"falling_heart"] forState:UIControlStateNormal];
      //  [likeBtn setTitle:@"" forState:UIControlStateNormal];
    }else{
    //    [likeBtn setImage:[UIImage imageNamed:@"pairme_logo"] forState:UIControlStateNormal];
   
    }
    [self offsetScrol:index];
}



/*
 mesage VC delegate
*/


-(void) goToMessaging
{
    [self.chatBtn setImage:[UIImage imageNamed:@"chat_full"] forState:UIControlStateNormal];
    [self performSegueWithIdentifier:@"segueMessageVC" sender:self];

}

-(void)unmatchUser
{
    [self unmatchAction];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueMessageVC"])
    {
        
        UINavigationController *nc = segue.destinationViewController;
        ConversationViewController *vc = (ConversationViewController *)nc.topViewController;
    }
    else if ([segue.destinationViewController isKindOfClass:[LoginViewController class]])
    {
        if (self.presentedViewController)
        {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        LoginViewController *loginVC = segue.destinationViewController;
        loginVC.delegate = self;
        loginVC.view.backgroundColor = [UIColor clearColor];
        loginVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
    }
    else if ([segue.destinationViewController isKindOfClass:[PartingMessageViewController class]])
    {
        if (self.presentedViewController)
        {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        PartingMessageViewController *partingVC = segue.destinationViewController;
        
        partingVC.delegate = self;
        partingVC.view.backgroundColor = [UIColor clearColor];
        partingVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
    }
    else if ([segue.destinationViewController isKindOfClass:[NewMessageViewController class]])
    {
        if (self.presentedViewController)
        {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        NewMessageViewController *messageAlertVC = segue.destinationViewController;
        messageAlertVC.delegate = self;
        messageAlertVC.view.backgroundColor = [UIColor clearColor];
        messageAlertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
    }
    else if ([segue.destinationViewController isKindOfClass:[ProfileViewController class]])
    {
        if (self.presentedViewController)
        {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        ProfileViewController *profileVC = segue.destinationViewController;
        profileVC.user = self.user;
        profileVC.match = isMatch;
        profileVC.isMine = isMine;
        profileVC.delegate = self;
        profileVC.view.backgroundColor = [UIColor clearColor];
        profileVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;

        

        if (!isMine && !isMatch)
        {
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            profileVC.transitioningDelegate = self;
            CGRect frame = CGRectMake(20, (pvcHeight * 0.05) / 2, width - 40, pvcHeight * 0.73);
            self.storyVC.selectedCardFrame = frame;
            self.dismissVC.selectedCardFrame = frame;
        }
        else if(!isMine && isMatch)
        {
            if (self.matchVC)
            {
                profileVC.transitioningDelegate = self;
                CGRect frame = [self.matchVC profileFrame];
                self.storyVC.selectedCardFrame = frame;
                self.dismissVC.selectedCardFrame = frame;
            }
        }
        
        /*
         
         presentStoryAnimationController.selectedCardFrame = cell.frame
         dismissStoryAnimationController.selectedCardFrame = cell.frame
         
         destinationViewController.transitioningDelegate = self
         destinationViewController.interactor = interactor
         */
        
    }
    else if ([segue.destinationViewController isKindOfClass:[NewMatchConflictViewController class]])
    {
        
        if (self.presentedViewController)
        {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        NewMatchConflictViewController *matchVC = (NewMatchConflictViewController *)segue.destinationViewController;
        matchVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        if ([[DataAccess singletonInstance] UserHasMatch] && !notif)
        {
            matchVC.isConflict = YES;
        }
        
        matchVC.altMatches = self.altMatches;
        matchVC.view.backgroundColor = [UIColor clearColor];
    }
    else if ([segue.destinationViewController isKindOfClass:[SecondChancePickerViewController class]])
    {
        if (self.presentedViewController)
        {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        SecondChancePickerViewController *secondChanceVC = segue.destinationViewController;
        secondChanceVC.view.backgroundColor = [UIColor clearColor];
        secondChanceVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
    }
    else if ([segue.destinationViewController isKindOfClass:[SelectionViewController class]])
    {
        if (self.presentedViewController)
        {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        SelectionViewController *selectionVC = segue.destinationViewController;
        selectionVC.view.backgroundColor = [UIColor clearColor];
        selectionVC.delegate = self;
        selectionVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
    }
    else if ([segue.destinationViewController isKindOfClass:[EditPhotosViewController class]])
    {
        if (self.presentedViewController)
        {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        EditPhotosViewController *selectionVC = segue.destinationViewController;
        selectionVC.user = self.user;
    }
    else if ([segue.destinationViewController isKindOfClass:[TutorialViewController class]])
    {
        if (self.presentedViewController)
        {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        TutorialViewController *tutorialVC = segue.destinationViewController;
        tutorialVC.delegate = self;
        tutorialVC.view.backgroundColor = [UIColor clearColor];
        tutorialVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
}

-(void)showMatchIcon
{
    //   if (nCurIdx == 1)
    //   {
    
    self.unmatchBtn.layer.borderWidth = 2;
    self.unmatchBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.unmatchBtn setImage:nil forState:UIControlStateNormal];
    [self.unmatchBtn setBackgroundColor:[UIColor clearColor]];
    //  [unmatchBtn setImage:[UIImage imageNamed:@"girl3"] forState:UIControlStateNormal];
    
    [self.unmatchBtn sd_setImageWithURL:[NSURL URLWithString:[[MatchUser currentUser].pics objectAtIndex:0]]
                               forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                                options:SDWebImageRefreshCached];
    
    self.unmatchBtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.unmatchBtn.layer.shadowOpacity = 0.75;
    self.unmatchBtn.layer.shadowRadius = 3;
    self.unmatchBtn.layer.shadowOffset = CGSizeZero;
    self.unmatchBtn.layer.masksToBounds = NO;
    self.unmatchBtn.imageView.layer.cornerRadius = 20;
    
    // }
}

- (void)unmatchAction {
    
    MatchUser *match_user = [MatchUser currentUser];
    NSString *message = [NSString stringWithFormat:@"Are you sure you want to unmatch %@?", match_user.name];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unmatch"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"YES"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              NSArray * controllerArray = self.pageViewController.childViewControllers;
                                                              
                                                              
                                                              for (UIViewController *controller in controllerArray){
                                                                  if([controller isKindOfClass:[MatchViewController class]])
                                                                  {
                                                                      self.matchVC = (MatchViewController*) controller;
                                                                  }
                                                              }
                                                              
                                                              if (self.matchVC) {
                                                                  [self performSegueWithIdentifier:@"partingSegue" sender:self];
                                                              }
                                                          }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"NO"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               
                                                           }]; // 3
    
    [alert addAction:firstAction]; // 4
    [alert addAction:secondAction]; // 5
    
    [self presentViewController:alert animated:YES completion:nil]; // 6
    
    
}

-(void)resetMatchButton
{
    /*
     [self.unmatchBtn setBackgroundColor:[UIColor whiteColor]];
     self.unmatchBtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
     self.unmatchBtn.layer.shadowOpacity = 0.75;
     self.unmatchBtn.layer.shadowRadius = 3;
     self.unmatchBtn.layer.shadowOffset = CGSizeZero;
     [self.unmatchBtn setImage:[UIImage imageNamed:@"heart2_Icon"] forState:UIControlStateNormal];
     self.unmatchBtn.layer.masksToBounds = NO;
     [self.unmatchBtn setAlpha:1.0]; */
}
/*
- (void)didDismissMessageViewController:(MessageViewController *)vc
{
    [self dismissViewControllerAnimated:YES completion:nil];
} */

-(UIColor*)blackColor{
    return [UIColor colorWithRed:0.16 green:0.16 blue:0.17 alpha:1.0];
}

-(UIColor*)blueColor{
    return [UIColor colorWithRed:0.18 green:0.49 blue:0.83 alpha:1.0];
}

-(UIColor*)pinkColor{
    return [UIColor colorWithRed:0.80 green:0.28 blue:0.42 alpha:1.0];
}

-(UIColor*)othBlueColor{
    return [UIColor colorWithRed:0.18 green:0.49 blue:0.83 alpha:1.0];//  [UIColor colorWithRed:0.01 green:0.68 blue:0.80 alpha:1.0];
}

-(UIColor*)purpleColor{
    return [UIColor colorWithRed:0.43 green:0.40 blue:0.77 alpha:1.0];
}

-(UIColor*)grayColor
{
    return [UIColor colorWithRed:0.78 green:0.78 blue:0.80 alpha:1.0];
}

-(UIColor*)bgGray
{
    return [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
}


- (void)sendMessageBack:(NSString *)message
{
    [self.matchVC UnmatchSelected:self.unmatchBtn];
    self.unmatchBtn.userInteractionEnabled = NO;
}

-(void)selectedProfile:(User *)user matched:(BOOL)match{
    self.user = user;
    isMatch = match;
    isMine = NO;
    [self performSegueWithIdentifier:@"goToProfile" sender:self];
}

-(void)likeCurrent:(BOOL)option{
    [self dismissViewControllerAnimated:NO completion:^(void){
        
        if (option)
        {
            [self showHeartAnimation];
            [self.swipeVC likeCurrentCard:YES];
        }
        else
        {
            [self.swipeVC likeCurrentCard:NO];
        }
        
        
    }];
}

-(void)showHeartAnimation{
    [[TFHeartAnimationView sharedInstance] showWithAnchorPoint:[self.view convertPoint:self.view.center toView:nil] completion:^(void)
     {
     }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object  change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"location"]) {
        
        [self runLocationRequest];
        
        @try {
            [object removeObserver:self forKeyPath:@"location"];
            observerActive = NO;
        }
        @catch (NSException * __unused exception) {
            NSLog(@"oh here we go %@", exception);
        }
        
        
    }
}

-(void)runLocationRequest
{
    self.curr_location = [LocationManager sharedInstance].location;
    
    // [[DataAccess singletonInstance] setUserLocation:self.curr_location];
    
    [self.swipeVC showEmptyLabel:NO];
    
    if (CLLocationCoordinate2DIsValid(self.curr_location) && self.curr_location.latitude != 0 && self.curr_location.longitude != 0)
    {
        [DAServer postLocation:self.curr_location completion:^(NSMutableArray *result, NSError *error) {
            // here, update the UI to say "Not busy anymore"
            if (!error) {
                if ([result count] > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.swipeVC)
                        {
                            [self.swipeVC loadCards:result withHeight: pvcHeight];
                            if (![[DataAccess singletonInstance] UserHasMatch])
                            {
                                
                                self.matchImg.image = [UIImage imageNamed:@"match_inactive"];
                                [self.matchBtn setUserInteractionEnabled:NO];
                            }
                            
                        }
                        else
                        {
                            //figure this stuff out for loading cards before user tranistions
                            //to index 2
                        }
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.swipeVC)
                        {
                            [self.swipeVC showEmptyLabel:YES];
                        }
                    });
                }
                
            } else {
                // update UI to indicate error or take remedial action
            }
        }];
    }
}


-(void) altMatchesNotification:(NSNotification*)notification
{
    //if conflict
    if (notification.object)
    {
        self.altMatches = notification.object;
    }
    else if(notification.userInfo)
    {
        //regular match
        [self updateMatch];
        MatchUser *matchUser = [[notification userInfo] valueForKey:@"Match"];
        [self.altMatches setObject:matchUser atIndexedSubscript:0];
        notif = YES;
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"MatchedConflictViewController" sender:self];
        [[TFHeartAnimationView sharedInstance] showWithAnchorPoint:[self.view convertPoint:self.view.center toView:nil] completion:^(void)
         {
         }];
        
    });
    
    /*
     if ([[DataAccess singletonInstance] UserHasMatch])
     {
     [self performSegueWithIdentifier:@"MatchedConflictViewController" sender:self];
     }
     else
     {
     [self performSegueWithIde
     ntifier:@"MatchedViewController" sender:self];
     }
     */
    
}

-(void) currentMatchNotification:(NSNotification*)notification
{
    self.matchImg.image = [UIImage imageNamed:@"match_active"];
    [self.matchBtn setUserInteractionEnabled:YES];
}

-(void) noMatchNotification:(NSNotification*)notification
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updateUnmatch];
        
    });
    
}


- (IBAction)myMatchAction:(id)sender
{
    
    if (nCurIdx == 1) {
        return;
    }
    
    if (!self.matchVC) {
        self.matchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchVC"];
    }
    [self offsetScrol:1];
    self.matchVC.delegate = self;
    self.matchVC.profile_delegate = self;
    self.matchVC.discoverDelegate = self;
    self.matchVC.pageIndex = 1;
    if( self.matchVC ) {
        [self.pageViewController setViewControllers:@[self.matchVC]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
    }
}


- (IBAction)discoverAction:(id)sender
{
    
    if (nCurIdx == 0)
    {
        return;
    }
    
    
    [self offsetScrol:0];
    
    
    
    if (!self.swipeVC) {
        self.swipeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SwipeVC"];
    }
    self.swipeVC.pageIndex = 1;
    if( self.swipeVC ) {
        [self.pageViewController setViewControllers:@[self.swipeVC]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:YES
                                         completion:nil];
    }
}

-(void)discoverSelected
{
    if ([[DataAccess singletonInstance] UserHasMatch])
    {
        [self performSegueWithIdentifier:@"partingSegue" sender:self];
    }
    else
    {
        [self discoverAction:self];
    }
}

-(void)updateUnmatch
{
    self.matchImg.image = [UIImage imageNamed:@"match_inactive"];
    [self.matchBtn setUserInteractionEnabled:NO];
    
    [self.unmatchBtn setHidden:YES];
    
    if (nCurIdx == 1)
    {
        [self.chatBtn setHidden:YES];
    }
    
    if (self.swipeVC)
    {
        [self.swipeVC updateUnmatch];
    }
    
    if (self.matchVC)
    {
        [self.matchVC updateUnmatch];
    }
    
    
}


-(void)updateMatch
{
    self.matchImg.image = [UIImage imageNamed:@"match_inactive"];
    [self.matchBtn setUserInteractionEnabled:YES];
    
    if (nCurIdx == 1)
    {
        [self.chatBtn setHidden:NO];
    }
    
    if (self.swipeVC != nil)
    {
        [self.swipeVC updateMatch];
    }
    
    if (self.matchVC)
    {
        [self.matchVC updateMatch];
    }
    
}

-(void)settingsAction
{
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];
}

- (void)profileAction:(User*)user
{
    self.user = user;
    isMatch = NO;
    isMine = YES;
    [self performSegueWithIdentifier:@"myprofileSegue" sender:self];
  //  [self performSegueWithIdentifier:@"selectionVC" sender:self];
}

-(void)editProfile:(User*)user
{
    self.user = user;
    [self performSegueWithIdentifier:@"editProfileSegue" sender:self];
}

- (IBAction)gotoMessaging:(id)sender
{
    if ([[DataAccess singletonInstance] UserHasMatch])
    {
        [self goToMessaging];
    }
}
- (IBAction)likeAction:(id)sender
{
    NSArray * controllerArray = self.pageViewController.childViewControllers;
    
    SwipeViewController *swipeVC;
    
    for (UIViewController *controller in controllerArray){
        if([controller isKindOfClass:[SwipeViewController class]])
        {
            swipeVC = (SwipeViewController*) controller;
        }
    }
    
    if (swipeVC)
    {
        if (![[DataAccess singletonInstance] UserHasMatch])
        {
            [self showHeartAnimation];
            [swipeVC likeCurrentCard:YES];
        }
        
    }
    return;
}

- (IBAction)dislikeAction:(id)sender
{
    NSArray * controllerArray = self.pageViewController.childViewControllers;
    
    SwipeViewController *swipeVC;
    
    for (UIViewController *controller in controllerArray){
        if([controller isKindOfClass:[SwipeViewController class]])
        {
            swipeVC = (SwipeViewController*) controller;
        }
    }
    
    if (swipeVC)
    {
        if (![[DataAccess singletonInstance] UserHasMatch])
        {
            [swipeVC likeCurrentCard:NO];
        }
        
    }
    return;
}

- (IBAction)unmatchSelected:(id)sender
{
    if([[DataAccess singletonInstance] UserHasMatch])
    {
        [self performSegueWithIdentifier:@"partingSegue" sender:self];
        
    }
}


- (IBAction)returnToStepOne:(UIStoryboardSegue *)segue {
    
}

-(IBAction)afterLoginUnwind:(UIStoryboardSegue *)segue {
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIColor*)baseColor
{
    return [UIColor blackColor];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.storyVC;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissVC;
    
}

-(void)didSelect:(NSInteger)segmentIndex
{
    if (segmentIndex == 0)
    {
        [self discoverAction:self];
    }
    else
    {
        [self myMatchAction:self];
    }
}

-(void)goToInAppPurchaes
{
    [self performSegueWithIdentifier:@"purchaseSegue" sender:self];
}

/*


- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    
    return nil;
} */


@end
