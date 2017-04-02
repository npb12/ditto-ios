//
//  RootViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/7/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface RootViewController ()<GoToProfileProtocol>{
    int nCurIdx;
    UIButton* btn0;
    UIButton* btn1;
    UIButton* btn2;
    UIColor* purpleColor;
    CAGradientLayer *gradient;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) SwipeViewController *swipeVC;
@property (strong, nonatomic) MatchViewController *matchVC;
@property (strong, nonatomic) MenuViewController *menuVC;

@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@property (strong, nonatomic) UINavigationBar *navBar;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nav_height;

@property (strong, nonatomic) IBOutlet UIView *topview;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    purpleColor = self.topview.backgroundColor;
    
    [self initViewController];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
   
    
    if (![[DataAccess singletonInstance] UserIsLoggedIn])
    {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
    else
    {
        [LocationManager sharedInstance];
        [(AppDelegate*)[UIApplication sharedApplication].delegate registerForRemoteNotifications];

        User *user = [User new];
        
        
        [DAServer postLocation:user completion:^(NSMutableArray *result, NSError *error) {
            // here, update the UI to say "Not busy anymore"
            if (!error) {
                if ([result count] > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.swipeVC)
                        {
                          [self.swipeVC loadCards:result];
                        }
                        
                    });
                }
            } else {
                // update UI to indicate error or take remedial action
            }
        }];
    
    }
 
}


-(void)initViewController{
    
    self.pageTitles = @[@"VC1", @"VC2", @"VC3"];
    //  _pageImages = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
    // Do any additional setup after loading the view.
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.delegate = self;
    
  //  SwipeViewController *startingViewController = [self dailyControllerAtIndex:1];
    SwipeViewController *startingViewController = [self dailyControllerAtIndex:1];
    startingViewController.profile_delegate = self;

    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    nCurIdx = 1;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    btn0 = [[UIButton alloc] initWithFrame:CGRectMake(10,15,45,45)];
    [btn0 setBackgroundColor:[UIColor whiteColor]];
    btn0.layer.cornerRadius = 22.5;
    btn0.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    btn0.layer.shadowOpacity = 0.75;
    btn0.layer.shadowRadius = 3;
    btn0.layer.shadowOffset = CGSizeZero;
  //  [btn0 setAlpha:0.3];
//    btn0.layer.borderWidth = 2;
  //  btn0.layer.borderColor = [UIColor whiteColor].CGColor;
    [btn0 setImage:[UIImage imageNamed:@"Settings_Big"] forState:UIControlStateNormal];
    btn0.layer.masksToBounds = NO;
    [btn0 addTarget:self action:@selector(onLeftClick) forControlEvents:UIControlEventTouchUpInside];
    [_topview addSubview:btn0];
    

    
    btn1 = [[UIButton alloc] initWithFrame:CGRectMake(width/2 - 37.5,-10,75,75)];
  //  [btn1 setTitle:@"PairMe" forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
  //  [self addGradientLayer:btn1];
    [btn1 setBackgroundColor:[UIColor whiteColor]];
    btn1.layer.cornerRadius = 37.5;
    btn1.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    btn1.layer.shadowOpacity = 0.75;
    btn1.layer.shadowRadius = 3;
    btn1.layer.shadowOffset = CGSizeZero;
    [btn1 addTarget:self action:@selector(onMiddleClick) forControlEvents:UIControlEventTouchUpInside];
    btn1.enabled = YES;
  //  btn1.layer.borderWidth = 2;
  //  btn1.layer.borderColor = [UIColor whiteColor].CGColor;
    [_topview addSubview:btn1];
    
    btn2 = [[UIButton alloc] initWithFrame:CGRectMake(width-55,15,45,45)];
    btn2.layer.cornerRadius = 22.5;

    if (/* DISABLES CODE */ (1))
    {
        btn2.layer.borderWidth = 2;
        btn2.layer.borderColor = [UIColor whiteColor].CGColor;
        [btn2 setImage:[UIImage imageNamed:@"girl1"] forState:UIControlStateNormal];
        btn2.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        btn2.layer.shadowOpacity = 0.75;
        btn2.layer.shadowRadius = 3;
        btn2.layer.shadowOffset = CGSizeZero;
        btn2.layer.masksToBounds = NO;
        btn2.imageView.layer.cornerRadius = 22.5;
    }
    else
    {
        [btn2 setBackgroundColor:[UIColor whiteColor]];
        btn2.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        btn2.layer.shadowOpacity = 0.75;
        btn2.layer.shadowRadius = 3;
        btn2.layer.shadowOffset = CGSizeZero;
        [btn2 setImage:[UIImage imageNamed:@"heart2_Icon"] forState:UIControlStateNormal];
        btn2.layer.masksToBounds = NO;
    }
    

    [btn2 addTarget:self action:@selector(onRightClick) forControlEvents:UIControlEventTouchUpInside];
    [_topview addSubview:btn2];
    
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [self.view bringSubviewToFront:self.topview];
}


-(void) onLeftClick {
  //  self.topview.backgroundColor = purpleColor;
    [self offsetScrol:0];
    
    [btn0 setHidden:YES];
 //   [btn0 setImage:[UIImage imageNamed:@"gear_1"] forState:UIControlStateNormal];
 //   btn0.layer.cornerRadius = 37.5;
  //  btn0.layer.backgroundColor = [self purpleColor].CGColor;
   // btn0.layer.borderWidth = 2;
   // btn0.layer.borderColor = [UIColor whiteColor].CGColor;
 /*   btn0.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
    btn0.layer.shadowOffset = CGSizeMake(0, 2.5f);
    btn0.layer.shadowOpacity = 0.0f;
    btn0.layer.shadowRadius = 0.0f;
    btn0.layer.masksToBounds = NO;
    btn0.backgroundColor = [self purpleColor];
    
    /*
    [self removeGradientLayer:btn1];
   // [btn1 setBackgroundColor:[self othBlueColor]];
    btn1.layer.cornerRadius = 22.5;
    btn1.layer.masksToBounds = NO;
    btn1.layer.shadowOffset = CGSizeMake(0, 0.0f);
    btn1.layer.shadowOpacity = 0.0f;
    btn1.layer.shadowRadius = 0.0f; */
    [btn1 setImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
    btn1.layer.cornerRadius = 22.5;
    [btn1 setAlpha:0.5];


 //   [self performSegueWithIdentifier:@"messageNotificationSegue" sender:self];
    
    
    
    if (!self.menuVC) {
        self.menuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
    }
    self.menuVC.pageIndex = 0;
    if( self.menuVC ) {
        NSArray *viewControllers = @[self.menuVC];
        [self.pageViewController setViewControllers:viewControllers
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:YES
                                         completion:nil];
    }
}


-(void) onMiddleClick {
    
    
    btn2.userInteractionEnabled = YES;
    if (nCurIdx == 1) {
        
        NSArray * controllerArray = self.pageViewController.childViewControllers;
        
        

        SwipeViewController *swipeVC;
        
        for (UIViewController *controller in controllerArray){
            if([controller isKindOfClass:[SwipeViewController class]])
            {
                swipeVC = (SwipeViewController*) controller;
            }
        }
        
      //  SwipeViewController *swipeVC = [ firstObject];
        if (swipeVC) {
            [self showHeartAnimation];
            [swipeVC likeCurrentCard];
        }
        return;
    }
    
//   self.topview.backgroundColor = purpleColor;
    NSInteger orient;
    [btn0 setHidden:NO];
    [btn0 setImage:[UIImage imageNamed:@"Settings_Big"] forState:UIControlStateNormal];
    [btn0 setBackgroundColor:[UIColor whiteColor]];
    btn0.layer.cornerRadius = 22.5;
    btn0.layer.masksToBounds = NO;
    btn0.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    btn0.layer.shadowOpacity = 0.75;
    btn0.layer.shadowRadius = 3;
    btn0.layer.shadowOffset = CGSizeZero;
    btn0.layer.borderWidth = 0;
    
    [btn1 setImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
    btn1.layer.cornerRadius = 37.5;
    [btn1 setAlpha:1];
    
    
    btn2.layer.cornerRadius = 22.5;
    if (/* DISABLES CODE */ (1))
    {
        btn2.layer.borderWidth = 2;
        btn2.layer.borderColor = [UIColor whiteColor].CGColor;
        [btn2 setImage:[UIImage imageNamed:@"girl1"] forState:UIControlStateNormal];
        btn2.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        btn2.layer.shadowOpacity = 0.75;
        btn2.layer.shadowRadius = 3;
        btn2.layer.shadowOffset = CGSizeZero;
        btn2.layer.masksToBounds = NO;
        btn2.imageView.layer.cornerRadius = 22.5;
    }
    else
    {
        [btn2 setBackgroundColor:[UIColor whiteColor]];
        btn2.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        btn2.layer.shadowOpacity = 0.75;
        btn2.layer.shadowRadius = 3;
        btn2.layer.shadowOffset = CGSizeZero;
        [btn2 setImage:[UIImage imageNamed:@"heart2_Icon"] forState:UIControlStateNormal];
        btn2.layer.masksToBounds = NO;
    }
    
    

    /*
    [btn2 setBackgroundColor:[UIColor whiteColor]];
    btn2.layer.cornerRadius = 22.5;
    [btn2 setImage:[UIImage imageNamed:@"heart2_Icon"] forState:UIControlStateNormal];
    btn2.layer.masksToBounds = NO;
    btn2.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    btn2.layer.shadowOpacity = 0.75;
    btn2.layer.shadowRadius = 3;
    btn2.layer.shadowOffset = CGSizeZero;
    btn2.layer.borderWidth = 0;
    btn2.imageView.layer.cornerRadius = 0; */
    
  //  btn1.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30];
    if( btn0.frame.origin.x < 0 )
        orient = UIPageViewControllerNavigationDirectionReverse;
    else
        orient = UIPageViewControllerNavigationDirectionForward;
    
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
}

-(void) onRightClick {
 //   self.topview.backgroundColor = [UIColor clearColor];
    
    if (nCurIdx == 2) {
        
        [self unmatchAction];
        return;
    }

    [self offsetScrol:2];
    [btn1 setImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
    btn1.layer.cornerRadius = 22.5;
    [btn1 setAlpha:0.7];

    [btn2 setImage:[UIImage imageNamed:@"falling_heart"] forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[self pinkColor]];
    btn2.layer.cornerRadius = 37.5;
    [btn2 setAlpha:1];
  //  btn2.layer.masksToBounds = NO;
  //  btn2.layer.shadowOffset = CGSizeMake(0, 0.0f);
  //  btn2.layer.shadowOpacity = 0.0f;
  //  btn2.layer.shadowRadius = 0.0f;
   btn2.layer.borderWidth = 2;
   btn2.layer.borderColor = [UIColor whiteColor].CGColor;
   btn2.imageView.layer.cornerRadius = 0;


    if (!self.matchVC) {
        self.matchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchVC"];
    }
    self.matchVC.delegate = self;
    self.matchVC.pageIndex = 2;
    if( self.matchVC ) {
        [self.pageViewController setViewControllers:@[self.matchVC]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
    }
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) offsetScrol : (int) i {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 0.3;
    
    nCurIdx = i;
    
    if( i == 0 ) {
        [UIView animateWithDuration:duration animations:^{
            btn0.frame = CGRectMake(width/2 - 37.5,-10,75,75);
            btn1.frame = CGRectMake(width - 55,15,45,45);
            btn2.frame = CGRectMake(width*2, 15, 45, 45);
            
            btn0.enabled = true;
            btn1.enabled = true;
        }];
        
    } else if( i == 1 ) {
        [UIView animateWithDuration:duration animations:^{
            btn0.frame = CGRectMake(10,15,45,45);
            btn1.frame = CGRectMake(width/2 - 37.5,-10,75,75);
            btn2.frame = CGRectMake(width - 55,15,45,45);
            
            
            btn1.enabled = YES;
            btn0.enabled = btn2.enabled = YES;
        }];
    } else {
        [UIView animateWithDuration:duration animations:^{
            btn0.frame = CGRectMake(-width*2, 15, 45, 45);
            btn1.frame = CGRectMake(10,15,45,45);
            btn2.frame = CGRectMake(width/2 - 37.5,-10,75,75);

            btn1.enabled = YES;
            btn2.enabled = YES;
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
     //   [btn1 setImage:[UIImage imageNamed:@"falling_heart"] forState:UIControlStateNormal];
      //  [btn1 setTitle:@"" forState:UIControlStateNormal];
    }else{
    //    [btn1 setImage:[UIImage imageNamed:@"pairme_logo"] forState:UIControlStateNormal];
   
    }
    [self offsetScrol:index];
}



/*
 mesage VC delegate
*/


-(void) goToMessaging
{
    [self performSegueWithIdentifier:@"segueMessageVC" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueMessageVC"])
    {
        UINavigationController *nc = segue.destinationViewController;
        MessageViewController *vc = (MessageViewController *)nc.topViewController;
        vc.delegateModal = self;
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
        
     //   UINavigationController *nc = segue.destinationViewController;
    //    ProfileViewController *vc = (ProfileViewController *)nc.topViewController;
        ProfileViewController *profileVC = segue.destinationViewController;
        profileVC.user = self.user;
        profileVC.delegate = self;
       // messageAlertVC.delegate = self;
        
        
    }
}

- (void)unmatchAction {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unmatch"
                                                                   message:@"Are you sure you want to unmatch Neil?"
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

- (void)didDismissMessageViewController:(MessageViewController *)vc
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

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



-(void)addGradientLayer:(UIButton*)button{
    if (!gradient) {
        gradient = [CAGradientLayer layer];
        [button.layer insertSublayer:gradient atIndex:0];
    }
    gradient.frame = button.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)([UIColor colorWithRed:0.29 green:0.34 blue:0.86 alpha:1.0].CGColor),(id)([UIColor colorWithRed:0.01 green:0.68 blue:0.80 alpha:1.0].CGColor),nil];
    gradient.startPoint = CGPointMake(0.25,0.0);
    gradient.endPoint = CGPointMake(0.25,1.0);
    [button bringSubviewToFront:button.imageView];
    button.layer.masksToBounds = YES;
}

-(void)removeGradientLayer:(UIButton*)button{
    if (gradient != nil) {
        [gradient removeFromSuperlayer];
        gradient = nil;
    }
}

- (void)sendMessageBack:(NSString *)message{
    
      [self.matchVC UnmatchSelected:btn2];
      btn2.userInteractionEnabled = NO;
}

- (void)gotoMessage{
    [self goToMessaging];
}

-(void)selectedProfile:(User *)user{
    self.user = user;
    [self performSegueWithIdentifier:@"goToProfile" sender:self];
}

-(void)likeCurrent{
    [self dismissViewControllerAnimated:NO completion:^(void){
        [self showHeartAnimation];
        [self.swipeVC likeCurrentCard];
    }];
}

-(void)showHeartAnimation{
    [[TFHeartAnimationView sharedInstance] showWithAnchorPoint:[self.view convertPoint:self.view.center toView:nil] completion:^(void)
     {
     }];
}

@end
