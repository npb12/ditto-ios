//
//  RootViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/7/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface RootViewController (){
    int nCurIdx;
    UIButton* btn0;
    UIButton* btn1;
    UIButton* btn2;
    UIColor* purpleColor;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;
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
    
    /*
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.topview.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)([UIColor colorWithRed:0.29 green:0.34 blue:0.86 alpha:1.0].CGColor),(id)([UIColor colorWithRed:0.01 green:0.68 blue:0.80 alpha:1.0].CGColor),nil];
    gradient.startPoint = CGPointMake(0.25,0.0);
    gradient.endPoint = CGPointMake(0.25,1.0);
    [self.topview.layer insertSublayer:gradient atIndex:0]; */
    
    if ([[DataAccess singletonInstance] UserIsLoggedIn]) {
        [self initViewController];
        [LocationManager sharedInstance];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToMessaging:) name:@"goToMessaging" object:nil];
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
   
    if (![[DataAccess singletonInstance] UserIsLoggedIn]) {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
  //  else{
  //      [self initViewController];
  //  }
 
}


-(void)initViewController{
    
    self.pageTitles = @[@"Over 200 Tips and Tricks", @"Discover Hidden Features", @"Bookmark Favorite Tip"];
    //  _pageImages = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
    // Do any additional setup after loading the view.
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.delegate = self;
    
    SwipeViewController *startingViewController = [self dailyControllerAtIndex:1];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, self.nav_height.constant, self.view.frame.size.width, self.view.frame.size.height);
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    
    btn0 = [[UIButton alloc] initWithFrame:CGRectMake(10,27,30,30)];
    [btn0 setImage:[UIImage imageNamed:@"gear"] forState:UIControlStateNormal];
    [btn0 setImage:[UIImage imageNamed:@"gear_1"] forState:UIControlStateDisabled];
    [btn0 addTarget:self action:@selector(onLeftClick) forControlEvents:UIControlEventTouchUpInside];
    [_topview addSubview:btn0];
    

    
    btn1 = [[UIButton alloc] initWithFrame:CGRectMake(width/2.75,27,92,30)];
    [btn1 setTitle:@"PairMe" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont fontWithName:@"Playball" size:28];
    [btn1 setTitleColor:[self blueColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[self blueColor] forState:UIControlStateDisabled];
   // [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   // [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
  //  [btn1 setImage:[UIImage imageNamed:@"pairme_logo"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(onMiddleClick) forControlEvents:UIControlEventTouchUpInside];
    btn1.enabled = false;
    [_topview addSubview:btn1];
    
    btn2 = [[UIButton alloc] initWithFrame:CGRectMake(width-40,27,30,30)];
    [btn2 setImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"heart_1"] forState:UIControlStateDisabled];
    [btn2 addTarget:self action:@selector(onRightClick) forControlEvents:UIControlEventTouchUpInside];
    [_topview addSubview:btn2];
    
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}


-(void) onLeftClick {
  //  self.topview.backgroundColor = purpleColor;
    [self offsetScrol:0];
    [btn1 setTitle:@"" forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"falling_heart"] forState:UIControlStateNormal];
    MenuViewController *oneVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
    oneVC.pageIndex = 0;
    if( oneVC ) {
        NSArray *viewControllers = @[oneVC];
        [self.pageViewController setViewControllers:viewControllers
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:YES
                                         completion:nil];
    }
}


-(void) onMiddleClick {
    
//   self.topview.backgroundColor = purpleColor;
    NSInteger orient;
  //  [btn1 setImage:[UIImage imageNamed:@"pairme_logo"] forState:UIControlStateNormal];
    [btn1 setImage:nil forState:UIControlStateNormal];
    [btn1 setTitle:@"PairMe" forState:UIControlStateNormal];
    [btn2 setTitle:@"" forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"heart_1"] forState:UIControlStateDisabled];
  //  btn1.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30];
    if( btn0.frame.origin.x < 0 )
        orient = UIPageViewControllerNavigationDirectionReverse;
    else
        orient = UIPageViewControllerNavigationDirectionForward;
    
    [self offsetScrol:1];
    
    SwipeViewController *twoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SwipeVC"];
    twoVC.pageIndex = 1;
    if( twoVC ) {
        [self.pageViewController setViewControllers:@[twoVC]
                                          direction:orient
                                           animated:YES
                                         completion:nil];
    }
}

-(void) onRightClick {
 //   self.topview.backgroundColor = [UIColor clearColor];
    [self offsetScrol:2];
    [btn1 setTitle:@"" forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"falling_heart"] forState:UIControlStateNormal];
    [btn2 setImage:nil forState:UIControlStateNormal];
    [btn2 setImage:nil forState:UIControlStateDisabled];
    btn2.titleLabel.font = [UIFont systemFontOfSize:22];
    [btn2 setTitleColor:[UIColor colorWithRed:0.01 green:0.68 blue:0.80 alpha:1.0] forState:UIControlStateNormal];
    [btn2 setTitle:@"Neil" forState:UIControlStateNormal];

    MatchViewController *threeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchVC"];
    threeVC.pageIndex = 2;
    if( threeVC ) {
        [self.pageViewController setViewControllers:@[threeVC]
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

-(void) offsetScrol : (NSUInteger) i {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 0.3;
    
    if( i == 0 ) {
        [UIView animateWithDuration:duration animations:^{
            btn0.frame = CGRectMake(width/2-15,27,30,30);
            btn1.frame = CGRectMake(width-50, 27, 46, 30);
            btn2.frame = CGRectMake(width*2, 27, 30, 30);
            
            btn0.enabled = false;
            btn1.enabled = true;
        }];
        
    } else if( i == 1 ) {
        [UIView animateWithDuration:duration animations:^{
            btn0.frame = CGRectMake(10,27,30,30);
            btn1.frame = CGRectMake(width/2.75,27,92,30);
            btn2.frame = CGRectMake(width-40,27,30,30);
            
            
            btn1.enabled = NO;
            btn0.enabled = btn2.enabled = YES;
        }];
    } else {
        [UIView animateWithDuration:duration animations:^{
            btn0.frame = CGRectMake(-width,27,30,30);
            btn1.frame = CGRectMake(2,27,46,30);
           // btn2.frame = CGRectMake(width/2-15, 27, 46, 30);
            btn2.frame = CGRectMake(width/5.25,27,200,30);

            btn1.enabled = YES;
            btn2.enabled = NO;
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
        MenuViewController *menuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
        menuVC.pageIndex = index;
        return menuVC;
        
    }else if(index == 1){
        SwipeViewController *dailyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SwipeVC"];
        dailyVC.pageIndex = index;
        return dailyVC;
    }else{
        
        MatchViewController *matchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchVC"];
        matchVC.pageIndex = index;
        return matchVC;
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
        MenuViewController *menuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
        menuVC.pageIndex = index;
        return menuVC;
        
    }else if(index == 1){
        SwipeViewController *dailyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SwipeVC"];
        dailyVC.pageIndex = index;
        return dailyVC;
    }else{

        MatchViewController *matchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchVC"];
        matchVC.pageIndex = index;
        return matchVC;
    }
}


- (SwipeViewController *)dailyControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    SwipeViewController *dailyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SwipeVC"];
    dailyVC.pageIndex = index;
    
    return dailyVC;
}

- (MatchViewController *)matchControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    MatchViewController *matchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchVC"];
    matchVC.pageIndex = index;
    
    return matchVC;
}



- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
        [btn1 setImage:[UIImage imageNamed:@"falling_heart"] forState:UIControlStateNormal];
        [btn1 setTitle:@"" forState:UIControlStateNormal];
    }else{
    //    [btn1 setImage:[UIImage imageNamed:@"pairme_logo"] forState:UIControlStateNormal];
        [btn1 setTitle:@"PairMe" forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22];

    }
    [self offsetScrol:index];
}



/*
 mesage VC delegate
*/


-(void) goToMessaging:(id)sender
{
    [self performSegueWithIdentifier:@"segueMessageVC" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueMessageVC"]) {
        UINavigationController *nc = segue.destinationViewController;
        MessageViewController *vc = (MessageViewController *)nc.topViewController;
        vc.delegateModal = self;
    }
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

@end
