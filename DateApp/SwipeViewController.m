//
//  SwipeViewController.m
//  portal
//
//  Created by Neil Ballard on 12/13/15.
//  Copyright © 2015 Neil_appworld. All rights reserved.
//

#import "SwipeViewController.h"

@interface SwipeViewController ()

@property (nonatomic, strong) UIImageView *settingsIcon;


@end

@implementation SwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self addMainView];
    [self.backgroundView createView];

}





-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
 //   [self.navigationItem setHidesBackButton:YES];
 //   self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
 //   [self styleNavBar];
    
    if ([[DataAccess singletonInstance] IsInitialUser]) {
        [self pushIntro];
    }
    

    
}

-(void)addMainView{
    
    DraggableViewBackground *draggableBackground = [[DraggableViewBackground alloc]init];
    CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    draggableBackground.translatesAutoresizingMaskIntoConstraints = NO;
    [draggableBackground invalidateIntrinsicContentSize];
    
 //   draggableBackground.layer.masksToBounds = NO;
 //   self.tableBack.layer.shadowOffset = CGSizeMake(-.1, .2);
 //   self.tableBack.layer.shadowRadius = .5;
 ///   self.tableBack.layer.shadowOpacity = 0.5;
    
    //
    
    //
    
    //
    
    //
    
    
    CGFloat pad = 0, sub;

        pad = 0;
        sub = 0;
    
    
    CGFloat height = CGRectGetHeight([[UIScreen mainScreen] bounds]) - sub;

    
    [self.view addSubview:draggableBackground];
    
    
    
    NSDictionary *viewsDictionary = @{@"back":draggableBackground};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:draggableBackground attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[back]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:pad]} views:viewsDictionary];
    [self.view addConstraint:constraint1];
    [self.view addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:draggableBackground attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height];
    [self.view addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:draggableBackground attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    [self.view addConstraint:constraint4];
    
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





-(UIColor*)navColor{
    
    return [UIColor colorWithRed:0.0 green:172.0f/255.0f blue:237.0f/255.0f alpha:1.0];
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
