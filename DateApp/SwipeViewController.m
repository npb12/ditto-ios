//
//  SwipeViewController.m
//  portal
//
//  Created by Neil Ballard on 12/13/15.
//  Copyright © 2015 Neil_appworld. All rights reserved.
//

#import "SwipeViewController.h"

@interface SwipeViewController ()<NoSwipeProtocol, SelectedProfileProtocol>{
    BOOL didLoadCards;
}

@property (nonatomic, strong) UIImageView *settingsIcon;


@end

@implementation SwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self addMainView];

    /*
    CAGradientLayer *gradient = [CAGradientLayer layer];
    [self.backgroundView.layer insertSublayer:gradient atIndex:0];
    gradient.frame = self.backgroundView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)([UIColor whiteColor].CGColor),(id)([UIColor colorWithRed:0.95 green:0.95 blue:0.98 alpha:1.0].CGColor),nil];
    gradient.startPoint = CGPointMake(0.25,0.0);
    gradient.endPoint = CGPointMake(0.25,1.0); */
    self.backgroundView.layer.masksToBounds = YES;
    
    self.backgroundView.matched_delegate = self;
    self.backgroundView.noswipe_delegate = self;
    self.backgroundView.profile_delegate = self;
    
    self.backgroundView.emptyLabel.text = @"No one new is currently around.\nCheck back again soon!";

}


-(BOOL)noUsers
{
    return [self.backgroundView getTotalCardsCount] == 0;
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    
 //   [self performSegueWithIdentifier:@"goToMatchedConflict" sender:self];

    
    

    
}


-(void)loadCards:(NSMutableArray*)users withHeight:(CGFloat)height
{
    [self.backgroundView createViewWithUsers:users withHeight:height];
    
    if ([users count] < 1)
    {
        [self.backgroundView.emptyLabel setAlpha:0];
        [self.backgroundView.emptyLabel2 setAlpha:0];
        [self.backgroundView.emptyPin setAlpha:0.0];
    }
}

-(void)showEmptyLabel:(BOOL)show
{
    if (show)
    {
      //  self.backgroundView.emptyLabel.text = @"No one new currently around.";
      //  self.backgroundView.emptyLabel2.text = @"Check back again soon!";
        [self.backgroundView.emptyLabel setAlpha:1.0];
        [self.backgroundView.emptyLabel2 setAlpha:1.0];
        [self.backgroundView.emptyPin setAlpha:1.0];
        [self.backgroundView.stackLabels setAlpha:0.0];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
                [self.backgroundView.emptyLabel setAlpha:0.0];
                [self.backgroundView.emptyLabel2 setAlpha:0.0];
            [self.backgroundView.emptyPin setAlpha:0.0];
        });
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)leftButtonPressed:(id)sender {
    

    
}



- (void)rightButtonPressed:(id)sender {
    

    
}




-(void) pushDetailView:(id)sender
{
    // do your pushViewController


    
}

-(void) pushSettings:(id)sender
{

}


-(void)pushIntro
{
    
    /*
    IntroductionViewController *intro = [[IntroductionViewController alloc]init];
    self.parentViewController.providesPresentationContextTransitionStyle = YES;
    self.parentViewController.definesPresentationContext = YES;
    [intro setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    intro.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self.parentViewController presentViewController:intro animated:NO completion:nil]; */


}


-(void)goToMatchedSegue:(id)sender obj:(User*)object{
    
    /*
     if (user currently has match) {
     [self performSegueWithIdentifier:@"goToMatchedConflict" sender:object];
     }else{
     [self performSegueWithIdentifier:@"goToMatched" sender:object];
     } */
    
    [self performSegueWithIdentifier:@"goToMatchedConflict" sender:object];
    
}





-(UIColor*)navColor{
    
    return [UIColor colorWithRed:0.0 green:172.0f/255.0f blue:237.0f/255.0f alpha:1.0];
}


-(void)likeCurrentCard:(BOOL)option{
    [self.backgroundView likedCurrent:option];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    /*
    if ([[segue identifier] isEqualToString:@"goToMatchedConflict"]) {
        
        
        //   self.definesPresentationContext = YES;
        
        
        NewMatchConflictViewController *matchVC = (NewMatchConflictViewController *)segue.destinationViewController;
        matchVC.matched_user = sender;
        matchVC.view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        matchVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }else if ([[segue identifier] isEqualToString:@"goToMatched"]) {
        
        
        //   self.definesPresentationContext = YES;
        
        
        NewMatchViewController *matchVC = (NewMatchViewController *)segue.destinationViewController;
        matchVC.matched_user = sender;
        matchVC.view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        matchVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    } */
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


-(void)selectedProfile:(User *)user{
    id<GoToProfileProtocol> strongDelegate = self.profile_delegate;
    [strongDelegate selectedProfile:user matched:NO];
}




/*

 
 
 
 //get user profile
 [DAServer getProfile:@"" completion:^(User *user, NSError *error) {
 // here, update the UI to say "Not busy anymore"
 if (!error) {
 
 } else {
 // update UI to indicate error or take remedial action
 }
 }];
 
 
 
 //drop current match -- needs update
 [DAServer dropMatch:@"24"  completion:^(NSError *error) {
 // here, update the UI to say "Not busy anymore"
 if (!error) {
 
 } else {
 // update UI to indicate error or take remedial action
 }
 }];
 

 
 */

-(void)updateMatch
{
    [self.backgroundView updateMatch];
}

-(void)updateUnmatch
{
    [self.backgroundView updateUnmatch];
}



@end
