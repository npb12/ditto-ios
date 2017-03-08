//
//  ProfileViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/3/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface ProfileViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view_height;
- (IBAction)go_back:(id)sender;
@property (strong, nonatomic) IBOutlet UIPageControl *page_control;
@property (strong, nonatomic) IBOutlet UIImageView *pic;
@property (strong, nonatomic) IBOutlet UIImageView *pic2;
@property (strong, nonatomic) IBOutlet UIImageView *pic3;
@property (strong, nonatomic) UIView *tempView;

@property (nonatomic) CGFloat scroll_content_height;

@property (strong, nonatomic) IBOutlet UIImageView *liked_icon;
@end

@implementation ProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initScrollView];
    
    [self.name_age setText:[NSString stringWithFormat:@"%@, %@", self.user_data.name, self.user_data.age]];
    
    [self.occupation_label setText:self.user_data.occupation];
    
    [self.bio_label setText:self.user_data.bio];
        
    
    if([self.mode isEqualToString:@"matched"]){
        self.top_button.userInteractionEnabled = NO;
        [self.top_heart setHidden:YES];
    }
    
    //  [self addBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initScrollView{
    
    CGRect fullScreenRect=[[UIScreen mainScreen] bounds];
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.view_height.constant = self.view.frame.size.height / 2.75;

    
    self.scroll_content_height = self.view.frame.size.height - self.view_height.constant;
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tempView = [[UIView alloc] init];
    //  [self.tempView setFrame:fullScreenRect];
    self.tempView.translatesAutoresizingMaskIntoConstraints = NO;
    //  [self.tempView removeFromSuperview];
    
    
    
    UIView *tempView = self.tempView;
    UIScrollView *scrollView = self.scrollView;
    
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(scrollView, tempView);
    
    [self.scrollView addSubview:self.tempView];
    
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tempView]|" options:0 metrics: 0 views:viewsDictionary]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tempView]|" options:0 metrics: 0 views:viewsDictionary]];
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:fullScreenRect.size.width * 3]];
    
    
 //   [self.scrollView setExclusiveTouch:NO];
    
    //   CGFloat contentHeightModifier = 0.0;
    CGFloat scroll_width = CGRectGetWidth([[UIScreen mainScreen] bounds]) * 3;
    
    
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:300]];
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:scroll_width]];
    
    //   self.scrollView.contentInset = UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
    CGRect cRect = scrollView.bounds;
    //   self.scrollView.contentSize = CGSizeMake(cRect.origin.x, self.gradient_height.constant);
    //   self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width, 0);
    
    [self addPhoto];
    [self addPhoto2];
    [self addPhoto3];
    
}
/*
 - (void)addBackground{
 
 
 self.background.image = [UIImage imageNamed:@"my_image"];
 
 
 
 //  self.background.alpha = 0.95f;
 
 self.background.userInteractionEnabled = YES;
 
 
 
 
 
 
 } */


-(void)addPhoto{
    
    self.pic = [[UIImageView alloc]init];
    
    self.pic.backgroundColor = [UIColor blueColor];
    CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.pic.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic invalidateIntrinsicContentSize];
    
    self.pic.image = [self.user_data.photos objectAtIndex:0];
    
    
    
    [self.tempView addSubview:self.pic];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.self.scroll_content_height];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    [self.tempView addConstraint:constraint4];
    
}


-(void)addPhoto2{
    
    self.pic2 = [[UIImageView alloc]init];
    
    CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.pic2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic2 invalidateIntrinsicContentSize];
    
    self.pic2.image = [self.user_data.photos objectAtIndex:1];
    
    self.pic2.alpha = 2.0;
    
    
    
    [self.tempView addSubview:self.pic2];
    
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic2, @"pic1":self.pic};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pic1]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.self.scroll_content_height];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    [self.tempView addConstraint:constraint4];
    
}

-(void)addPhoto3{
    
    self.pic3 = [[UIImageView alloc]init];
    
    CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.pic3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic3 invalidateIntrinsicContentSize];
    
    self.pic3.image = [self.user_data.photos objectAtIndex:2];
    
    
    
    
    [self.tempView addSubview:self.pic3];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic3, @"pic2":self.pic2};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pic2]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.scroll_content_height];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    [self.tempView addConstraint:constraint4];
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    CGFloat pageWidth = self.pic.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self.page_control setCurrentPage:page];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dragGesture:(UIPanGestureRecognizer*)sender {

    
}
- (IBAction)go_back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)heart_button:(id)sender {
    
    
    [self.top_heart setHidden:YES];
    NSNotification* notification = [NSNotification notificationWithName:@"heartCurrentUser" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.liked_icon setHidden:NO];
    [[TFHeartAnimationView sharedInstance] showWithAnchorPoint:[self.view convertPoint:self.liked_icon.center toView:nil] completion:^(void)
     {
     }];
    
    [self performSelector:@selector(onTick:) withObject:nil afterDelay:0.5];


    
}

-(void)onTick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
