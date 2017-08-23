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
    CGFloat screenWidth, picWidth;
    NSString *text1, *text2, *text3, *text4;
    CGFloat scrollHeight;
    CGFloat viewWidth;
    CGFloat viewPadding;
}
@property (strong, nonatomic) IBOutlet UILabel *dittoHeading;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;

@property (strong, nonatomic) IBOutlet UIImageView *pc1;
@property (strong, nonatomic) IBOutlet UIImageView *pc2;
@property (strong, nonatomic) IBOutlet UIImageView *pc3;
@property (strong, nonatomic) IBOutlet UIImageView *pc4;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView *tempView;

@property (strong, nonatomic) UIImageView *pic;
@property (strong, nonatomic) UIImageView *pic2;
@property (strong, nonatomic) UIImageView *pic3;
@property (strong, nonatomic) UIImageView *pic4;

@property (nonatomic, strong) UILabel *explainLabel;
@property (nonatomic, strong) UILabel *explainLabel2;
@property (nonatomic, strong) UILabel *explainLabel3;
@property (nonatomic, strong) UILabel *explainLabel4;

@property (strong, nonatomic) UIView *view1;
@property (strong, nonatomic) UIView *view2;
@property (strong, nonatomic) UIView *view3;
@property (strong, nonatomic) UIView *view4;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    self.dittoHeading.textColor = [DAGradientColor gradientFromColor:self.dittoHeading.frame.size.width];
    
    CGFloat dimen = [[UIScreen mainScreen] bounds].size.width - 80;

    self.btnWidth.constant = dimen;
    
    CGFloat btnheight = (dimen - 15) / 5;
    
    self.btnHeight.constant = btnheight;
    
    [self.loginBtn layoutIfNeeded];
    
    
    CAGradientLayer *gradient2 = [CAGradientLayer layer];
    gradient2.frame = self.loginBtn.bounds;
    //  gradient2.colors = [NSArray arrayWithObjects:(id)([[UIColor whiteColor] colorWithAlphaComponent:1].CGColor),nil];
    gradient2.backgroundColor = [self blueColor].CGColor;
    gradient2.startPoint = CGPointMake(0.0,0.5);
    gradient2.endPoint = CGPointMake(1.0,0.5);
    [self.loginBtn.layer insertSublayer:gradient2 atIndex:0];
    gradient2.cornerRadius = btnheight / 2;
    gradient2.masksToBounds = YES;
    self.loginBtn.layer.masksToBounds = NO;
    self.loginBtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.loginBtn.layer.shadowOpacity = 0.75;
    self.loginBtn.layer.shadowRadius = 1;
    self.loginBtn.layer.shadowOffset = CGSizeZero;
    
    
    /*
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
     */
    
    [self setCurrentPage:0];
    
    
    picWidth = screenWidth * 0.73;
    
    text1 = @"See people around you who are also\nlooking for people to match with";
    text2 = @"Swipe left to like someone. Swipe\nright to dislike someone";
    text3 = @"Match with someone if you both\nswipe left on each other.";
    text4 = @"You can only be matched with one\nperson at a time! Choose wisely ;)";
    
    [self initScrollView];
    [self addView1];
    [self addView2];
    [self addView3];
    [self addView4];
    [self addPhoto];
    [self addPhoto2];
    [self addPhoto3];
    [self addPhoto4];
    [self setupExplainLabel];
    [self setupExplainLabel2];
    [self setupExplainLabel3];
    [self setupExplainLabel4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initScrollView
{
    CGRect fullScreenRect=[[UIScreen mainScreen] bounds];
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
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
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:fullScreenRect.size.width * 4]];
    
    scrollHeight = [[UIScreen mainScreen] bounds].size.height * 0.52;
    
    screenWidth = fullScreenRect.size.width;
    
    self.scrollViewHeight.constant = scrollHeight;
    
    [self.scrollView setExclusiveTouch:NO];
    
    viewWidth = screenWidth * 0.75;
    viewPadding  = (screenWidth - viewWidth) / 2;
    
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:scrollHeight]];
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:fullScreenRect.size.width * 4]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    if (scrollView == self.scrollView) {
        
        CGFloat pageWidth = self.view.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        [self setCurrentPage:page];
    }
    
    
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



-(void)setCurrentPage:(int)index
{
    
    
    if (index == 0)
    {
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self.pc1 setImage:[UIImage imageNamed:@"indicator_active"]];
                             [self.pc2 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             [self.pc3 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             [self.pc4 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             
                         }];
        
        
    }
    else if (index == 1)
    {
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self.pc1 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             [self.pc2 setImage:[UIImage imageNamed:@"indicator_active"]];
                             [self.pc3 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             [self.pc4 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             
                         }];
    }
    else if (index == 2)
    {
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self.pc1 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             [self.pc2 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             [self.pc3 setImage:[UIImage imageNamed:@"indicator_active"]];
                             [self.pc4 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                         }];
    }
    else if (index == 3)
    {
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self.pc1 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             [self.pc2 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             [self.pc3 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             [self.pc4 setImage:[UIImage imageNamed:@"indicator_active"]];
                         }];
    }
    
    
}

-(void)addView1{
    
    self.view1 = [[UIView alloc]init];
    self.view1.backgroundColor = [UIColor clearColor];
    self.view1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view1 invalidateIntrinsicContentSize];
    [self.tempView addSubview:self.view1];
    
    
    NSDictionary *viewsDictionary = @{@"view":self.view1};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[view]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:viewPadding]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[view]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:scrollHeight];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewWidth];
    [self.tempView addConstraint:constraint4];
}


-(void)addView2{
    
    self.view2 = [[UIView alloc]init];
    self.view2.backgroundColor = [UIColor clearColor];
    self.view2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view2 invalidateIntrinsicContentSize];
    [self.tempView addSubview:self.view2];
    
    NSDictionary *viewsDictionary = @{@"side":self.view1, @"view":self.view2};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[side]-pad-[view]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:viewPadding * 2]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[view]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.view2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:scrollHeight];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.view2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewWidth];
    [self.tempView addConstraint:constraint4];
    
}

-(void)addView3{
    
    self.view3 = [[UIView alloc]init];
    self.view3.backgroundColor = [UIColor clearColor];
    self.view3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view3 invalidateIntrinsicContentSize];
    [self.tempView addSubview:self.view3];
    
    
    NSDictionary *viewsDictionary = @{@"side":self.view2, @"view":self.view3};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[side]-pad-[view]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:viewPadding * 2]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[view]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.view3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:scrollHeight];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.view3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewWidth];
    [self.tempView addConstraint:constraint4];
    
}

-(void)addView4{
    
    self.view4 = [[UIView alloc]init];
    self.view4.backgroundColor = [UIColor clearColor];
    self.view4.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view4 invalidateIntrinsicContentSize];
    [self.tempView addSubview:self.view4];
    
    
    
    NSDictionary *viewsDictionary = @{@"side":self.view3, @"view":self.view4};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[side]-pad-[view]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:viewPadding * 2]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[view]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.view4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:scrollHeight];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.view4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewWidth];
    [self.tempView addConstraint:constraint4];
    
}


-(void)addPhoto{
    
    self.pic = [[UIImageView alloc]init];
    
    self.pic.backgroundColor = [self grayColor];
    //  CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.pic.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic invalidateIntrinsicContentSize];
   //
  //  self.pic.image = [UIImage imageNamed:@"girl2"];
    
    
    self.pic.contentMode = UIViewContentModeScaleAspectFill;
  //  [self.pic setClipsToBounds:YES];
    self.pic.layer.masksToBounds = YES;
    
    [self.view1 addSubview:self.pic];
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.view1 addConstraints:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.view1 addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:scrollHeight * 0.85];
    [self.view1 addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewWidth];
    [self.view1 addConstraint:constraint4];
    
}


-(void)addPhoto2{
    
    self.pic2 = [[UIImageView alloc]init];
    self.pic2.backgroundColor = [self grayColor];

    self.pic2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic2 invalidateIntrinsicContentSize];
    [self.pic2 setClipsToBounds:YES];
   // self.pic2.image = [UIImage imageNamed:@"page2"];

    self.pic2.alpha = 2.0;
    
    self.pic2.contentMode = UIViewContentModeScaleAspectFit;
    
    
    [self.view2 addSubview:self.pic2];
    
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic2, @"pic1":self.pic};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view2 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view2 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.view2 addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:scrollHeight * 0.85];
    [self.view2 addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewWidth];
    [self.tempView addConstraint:constraint4];
    
}

-(void)addPhoto3{
    
    self.pic3 = [[UIImageView alloc]init];
    
    self.pic3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic3 invalidateIntrinsicContentSize];
    [self.pic3 setClipsToBounds:YES];
    self.pic3.backgroundColor = [self grayColor];

  //  self.pic3.image = [UIImage imageNamed:@"page3"];

    
    self.pic3.contentMode = UIViewContentModeScaleAspectFit;
    
    
    [self.view3 addSubview:self.pic3];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic3, @"pic2":self.pic2};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view3 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view3 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.view3 addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:scrollHeight * 0.85];
    [self.view3 addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewWidth];
    [self.view3 addConstraint:constraint4];
    
}

-(void)addPhoto4{
    
    self.pic4 = [[UIImageView alloc]init];
    
    self.pic4.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic4 invalidateIntrinsicContentSize];
    self.pic4.clipsToBounds = YES;
    self.pic4.contentMode = UIViewContentModeScaleAspectFit;
    self.pic4.backgroundColor = [self grayColor];

   // self.pic4.image = [UIImage imageNamed:@"page4"];

    
    
    
    [self.view4 addSubview:self.pic4];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic4, @"pic3":self.pic3};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.pic4 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view4 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view4 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.view4 addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:scrollHeight * 0.85];
    [self.view4 addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewWidth];
    [self.view4 addConstraint:constraint4];
    
}


- (void)setupExplainLabel {
    
    
    self.explainLabel = [[UILabel alloc] init];
    [self.explainLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.explainLabel invalidateIntrinsicContentSize];
    self.explainLabel.textColor = [UIColor blackColor];
    self.explainLabel.numberOfLines = 2;
    self.explainLabel.textAlignment = NSTextAlignmentCenter;
    self.explainLabel.font = [UIFont fontWithName:@"RooneySansLF-Regular" size:14];
    
    self.explainLabel.text = text1;
    
    
    self.explainLabel.layer.masksToBounds = NO;
    
    
    
    [self.view1 addSubview:self.explainLabel];
    
    NSDictionary *viewsDictionary = @{@"label" : self.explainLabel};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.explainLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view1 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view1 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-pad-|" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.view1 addConstraints:constraint2];
    
}

- (void)setupExplainLabel2 {
    
    
    self.explainLabel2 = [[UILabel alloc] init];
    [self.explainLabel2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.explainLabel2 invalidateIntrinsicContentSize];
    self.explainLabel2.textColor = [UIColor blackColor];
    self.explainLabel2.numberOfLines = 2;
    self.explainLabel2.textAlignment = NSTextAlignmentCenter;
    self.explainLabel2.font = [UIFont fontWithName:@"RooneySansLF-Regular" size:14];
    self.explainLabel2.text = text2;
    
    
    self.explainLabel2.layer.masksToBounds = NO;
    
    
    
    [self.view2 addSubview:self.explainLabel2];
    
    NSDictionary *viewsDictionary = @{@"label" : self.explainLabel2};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.explainLabel2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view2 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view2 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-pad-|" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.view2 addConstraints:constraint2];
    
}

- (void)setupExplainLabel3 {
    
    
    self.explainLabel3 = [[UILabel alloc] init];
    [self.explainLabel3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.explainLabel3 invalidateIntrinsicContentSize];
    self.explainLabel3.textColor = [UIColor blackColor];
    self.explainLabel3.numberOfLines = 2;
    self.explainLabel3.textAlignment = NSTextAlignmentCenter;
    self.explainLabel3.font = [UIFont fontWithName:@"RooneySansLF-Regular" size:14];
    self.explainLabel3.text = text3;
    
    
    self.explainLabel3.layer.masksToBounds = NO;
    
    
    
    [self.view3 addSubview:self.explainLabel3];
    
    NSDictionary *viewsDictionary = @{@"label" : self.explainLabel3};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.explainLabel3 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view3 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view3 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-pad-|" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.view3 addConstraints:constraint2];
    
}

- (void)setupExplainLabel4 {
    
    
    self.explainLabel4 = [[UILabel alloc] init];
    [self.explainLabel4 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.explainLabel4 invalidateIntrinsicContentSize];
    self.explainLabel4.textColor = [UIColor blackColor];
    self.explainLabel4.numberOfLines = 2;
    self.explainLabel4.textAlignment = NSTextAlignmentCenter;
    self.explainLabel4.font = [UIFont fontWithName:@"RooneySansLF-Regular" size:14];
    self.explainLabel4.text = text4;
    
    
    self.explainLabel4.layer.masksToBounds = NO;
    
    
    
    [self.view4 addSubview:self.explainLabel4];
    
    NSDictionary *viewsDictionary = @{@"label" : self.explainLabel4};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.explainLabel4 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view4 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view4 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-pad-|" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.view4 addConstraints:constraint2];
}

-(UIColor*)blueColor
{
    return [UIColor colorWithRed:0.23 green:0.35 blue:0.60 alpha:1.0];
}

-(UIColor*)grayColor
{
    return [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.0];
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
