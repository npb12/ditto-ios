//
//  TutorialViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/20/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "TutorialViewController.h"
#import "DAGradientColor.h"

@interface TutorialViewController ()
{
    CGFloat screenWidth;
    NSString *text1, *text2, *text3, *text4;
    NSString *header1, *header2, *header3, *header4;
    CGFloat scrollHeight;
    CGFloat viewWidth;
    CGFloat viewPadding;
}

@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIButton *skipBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *skipWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *skipHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nextHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nextWidth;

@property (strong, nonatomic) IBOutlet UIImageView *pc1;
@property (strong, nonatomic) IBOutlet UIImageView *pc2;
@property (strong, nonatomic) IBOutlet UIImageView *pc3;
@property (strong, nonatomic) IBOutlet UIImageView *pc4;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;

@property (strong, nonatomic) UIView *tempView;

@property (strong, nonatomic) UIImageView *pic;
@property (strong, nonatomic) UIImageView *pic2;
@property (strong, nonatomic) UIImageView *pic3;
@property (strong, nonatomic) UIImageView *pic4;


@property (nonatomic, strong) UILabel *headingLabel;
@property (nonatomic, strong) UILabel *headingLabel2;
@property (nonatomic, strong) UILabel *headingLabel3;
@property (nonatomic, strong) UILabel *headingLabel4;

@property (nonatomic, strong) UILabel *explainLabel;
@property (nonatomic, strong) UILabel *explainLabel2;
@property (nonatomic, strong) UILabel *explainLabel3;
@property (nonatomic, strong) UILabel *explainLabel4;

@property (strong, nonatomic) UIView *view1;
@property (strong, nonatomic) UIView *view2;
@property (strong, nonatomic) UIView *view3;
@property (strong, nonatomic) UIView *view4;

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat dimen = [[UIScreen mainScreen] bounds].size.width * 0.175;
    
    self.skipWidth.constant = dimen;
    self.skipHeight.constant = dimen / 2.25;
//    self.skipBtn.layer.borderWidth = 1;
    self.skipBtn.layer.masksToBounds = YES;
    self.skipBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.skipBtn.layer.cornerRadius = self.skipHeight.constant / 2;
    [self.skipBtn setAlpha:0.75];

    
    self.nextWidth.constant = dimen;
    self.nextHeight.constant = dimen / 2.25;
 //   self.nextBtn.layer.borderWidth = 1;
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.nextBtn.layer.cornerRadius = self.skipHeight.constant / 2;
    [self.nextBtn setAlpha:0.75];
    
    [self setCurrentPage:0];

    
    header1 = @"Discover";
    header2 = @"Match";
    header3 = @"Exclusive";
    header4 = @"Decision";


    text1 = @"Ditto helps you find people nearby and\nmatches you with the ones\nthat you’re interested in.";
    text2 = @"Match with only one person at a\ntime, so you and your match have\neach other's complete attention.";
    text3 = @"Swiping is disabled while matched,\nallowing for a sincere connection\nbetween two people.";
    text4 = @"Your connection will be put to the\ntest when a new match occurs.\nChoose wisely ;)";
    
    [self initScrollView];
    [self addView1];
    [self addView2];
    [self addView3];
    [self addView4];
    
    [self setupExplainLabel];
    [self setupExplainLabel2];
    [self setupExplainLabel3];
    [self setupExplainLabel4];
    [self addPhoto];
    [self addPhoto2];
    [self addPhoto3];
    [self addPhoto4];
    [self setupHeadingLabel];
    [self setupHeadingLabel2];
    [self setupHeadingLabel3];
    [self setupHeadingLabel4];
    
}

-(void)initScrollView
{
    CGRect fullScreenRect=[[UIScreen mainScreen] bounds];
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.tempView = [[UIView alloc] init];
    self.tempView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    UIView *tempView = self.tempView;
    UIScrollView *scrollView = self.scrollView;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(scrollView, tempView);
    
    [self.scrollView addSubview:self.tempView];
    
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tempView]|" options:0 metrics: 0 views:viewsDictionary]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tempView]|" options:0 metrics: 0 views:viewsDictionary]];
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:fullScreenRect.size.width * 4]];
    
    
    scrollHeight = [[UIScreen mainScreen] bounds].size.height * 0.82;
    
    screenWidth = fullScreenRect.size.width;
    
    self.scrollViewHeight.constant = scrollHeight;
    
    [self.scrollView setExclusiveTouch:NO];
    
    viewWidth = screenWidth * 0.95;
    viewPadding  = (screenWidth - viewWidth) / 2;
    
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:scrollHeight]];
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:fullScreenRect.size.width * 4]];
    
    [self.tempView setBackgroundColor:[UIColor clearColor]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    if (scrollView == self.scrollView) {
        int page = [self getCurrentPage];
        [self setCurrentPage:page];
    }
}

-(int)getCurrentPage
{
    CGFloat pageWidth = self.view.frame.size.width;
    return floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
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
    
    self.pic.backgroundColor = [UIColor clearColor];
    self.pic.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic invalidateIntrinsicContentSize];
    //
    self.pic.image = [UIImage imageNamed:@"landing_1"];
    
    
    self.pic.contentMode = UIViewContentModeScaleAspectFit;
    self.pic.layer.masksToBounds = YES;
    
    [self.view1 addSubview:self.pic];
    
    int offset = CGRectGetHeight([[UIScreen mainScreen] bounds]) * 0.1;
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic, @"label": self.explainLabel};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view1 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view1 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[image]-pad-[label]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:15]} views:viewsDictionary];
    [self.view1 addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(scrollHeight * 0.825) - offset];
    [self.view1 addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewWidth - offset];
    [self.tempView addConstraint:constraint4];
    
}


-(void)addPhoto2{
    
    self.pic2 = [[UIImageView alloc]init];
    self.pic2.backgroundColor = [UIColor clearColor];
    
    self.pic2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic2 invalidateIntrinsicContentSize];
    [self.pic2 setClipsToBounds:YES];
    self.pic2.image = [UIImage imageNamed:@"landing_3"];
    
    
    self.pic2.contentMode = UIViewContentModeScaleAspectFit;
    
    
    [self.view2 addSubview:self.pic2];
    
    
    int offset = CGRectGetHeight([[UIScreen mainScreen] bounds]) * 0.1;
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic2, @"label":self.explainLabel2};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view2 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view2 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[image]-pad-[label]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:15]} views:viewsDictionary];
    [self.view2 addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(scrollHeight * 0.825) - offset];
    [self.view2 addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewWidth - offset];
    [self.tempView addConstraint:constraint4];
    
}

-(void)addPhoto3{
    
    self.pic3 = [[UIImageView alloc]init];
    
    self.pic3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic3 invalidateIntrinsicContentSize];
    [self.pic3 setClipsToBounds:YES];
    self.pic3.backgroundColor = [UIColor clearColor];
    
    self.pic3.image = [UIImage imageNamed:@"landing_2"];
    
    
    self.pic3.contentMode = UIViewContentModeScaleAspectFit;
    
    
    [self.view3 addSubview:self.pic3];
    
    int offset = CGRectGetHeight([[UIScreen mainScreen] bounds]) * 0.1;
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic3, @"label":self.explainLabel3};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view3 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view3 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[image]-pad-[label]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:15]} views:viewsDictionary];
    [self.view3 addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(scrollHeight * 0.825) - offset];
    [self.view3 addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewWidth - offset];
    [self.view3 addConstraint:constraint4];
    
}

-(void)addPhoto4{
    
    self.pic4 = [[UIImageView alloc]init];
    
    self.pic4.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic4 invalidateIntrinsicContentSize];
    self.pic4.clipsToBounds = YES;
    self.pic4.contentMode = UIViewContentModeScaleAspectFit;
    self.pic4.backgroundColor = [UIColor clearColor];
    
    self.pic4.image = [UIImage imageNamed:@"landing_4"];
    
    
    [self.view4 addSubview:self.pic4];
    
    int offset = CGRectGetHeight([[UIScreen mainScreen] bounds]) * 0.1;
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic4, @"label":self.explainLabel4};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.pic4 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view4 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view4 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[image]-pad-[label]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:15]} views:viewsDictionary];
    [self.view4 addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(scrollHeight * 0.825) - offset];
    [self.view4 addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewWidth - offset];
    [self.view4 addConstraint:constraint4];
    
}

- (void)setupHeadingLabel {
    
    CGFloat dimen = [[UIScreen mainScreen] bounds].size.width * 0.25;
    
    self.headingLabel = [[UILabel alloc] init];
    [self.headingLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.headingLabel invalidateIntrinsicContentSize];
    self.headingLabel.numberOfLines = 1;
    self.headingLabel.textAlignment = NSTextAlignmentCenter;
    self.headingLabel.font = [UIFont fontWithName:@"RooneySansLF-Medium" size:24];
    
    self.headingLabel.text = header1;
    
    self.headingLabel.layer.masksToBounds = NO;
    
    
    
    [self.view1 addSubview:self.headingLabel];
    
    
    
    NSDictionary *viewsDictionary = @{@"label" : self.headingLabel, @"image": self.pic};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.headingLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view1 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view1 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:15]} views:viewsDictionary];
    [self.view1 addConstraints:constraint2];
    
    self.headingLabel.textColor = [self baseColor];    
}

- (void)setupHeadingLabel2 {
    
    CGFloat dimen = [[UIScreen mainScreen] bounds].size.width * 0.25;

    
    self.headingLabel2 = [[UILabel alloc] init];
    [self.headingLabel2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.headingLabel2 invalidateIntrinsicContentSize];
    self.headingLabel2.numberOfLines = 1;
    self.headingLabel2.textAlignment = NSTextAlignmentCenter;
    self.headingLabel2.font = [UIFont fontWithName:@"RooneySansLF-Medium" size:24];
    self.headingLabel2.text = header2;
    
    
    self.headingLabel2.layer.masksToBounds = NO;
    
    
    
    [self.view2 addSubview:self.headingLabel2];
    
    NSDictionary *viewsDictionary = @{@"label" : self.headingLabel2, @"image": self.pic2};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.headingLabel2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view2 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view2 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:15]} views:viewsDictionary];
    [self.view2 addConstraints:constraint2];
    
    self.headingLabel2.textColor = [self baseColor];
    
}


- (void)setupHeadingLabel3 {
    
    
    CGFloat dimen = [[UIScreen mainScreen] bounds].size.width * 0.25;
    
    
    self.headingLabel3 = [[UILabel alloc] init];
    [self.headingLabel3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.headingLabel3 invalidateIntrinsicContentSize];
    self.headingLabel3.numberOfLines = 1;
    self.headingLabel3.textAlignment = NSTextAlignmentCenter;
    self.headingLabel3.font = [UIFont fontWithName:@"RooneySansLF-Medium" size:24];
    self.headingLabel3.text = header3;
    
    
    self.headingLabel3.layer.masksToBounds = NO;
    
    
    
    [self.view3 addSubview:self.headingLabel3];
    
    NSDictionary *viewsDictionary = @{@"label" : self.headingLabel3, @"image": self.pic3};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.headingLabel3 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view3 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view3 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:15]} views:viewsDictionary];
    [self.view3 addConstraints:constraint2];
    
    self.headingLabel3.textColor = [self baseColor];

}

- (void)setupHeadingLabel4 {
    
    
    CGFloat dimen = [[UIScreen mainScreen] bounds].size.width * 0.25;
    
    
    self.headingLabel4 = [[UILabel alloc] init];
    [self.headingLabel4 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.headingLabel4 invalidateIntrinsicContentSize];
    self.headingLabel4.numberOfLines = 1;
    self.headingLabel4.textAlignment = NSTextAlignmentCenter;
    self.headingLabel4.font = [UIFont fontWithName:@"RooneySansLF-Medium" size:24];
    self.headingLabel4.text = header4;
    self.headingLabel4.layer.masksToBounds = NO;
    
    [self.view4 addSubview:self.headingLabel4];
    
    NSDictionary *viewsDictionary = @{@"label" : self.headingLabel4, @"image": self.pic4};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.headingLabel4 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view4 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view4 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:15]} views:viewsDictionary];
    [self.view4 addConstraints:constraint2];
    
    self.headingLabel4.textColor = [self baseColor];
}



- (void)setupExplainLabel {
    
    
    self.explainLabel = [[UILabel alloc] init];
    [self.explainLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.explainLabel invalidateIntrinsicContentSize];
    self.explainLabel.textColor = [UIColor whiteColor];
    self.explainLabel.numberOfLines = 3;
    self.explainLabel.textAlignment = NSTextAlignmentCenter;
    self.explainLabel.font = [UIFont fontWithName:@"RooneySansLF-Regular" size:18];
    
    self.explainLabel.text = text1;
    
    
    self.explainLabel.layer.masksToBounds = NO;
    
    
    
    [self.view1 addSubview:self.explainLabel];
    
    NSDictionary *viewsDictionary = @{@"label" : self.explainLabel};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.explainLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view1 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view1 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-pad-|" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:15]} views:viewsDictionary];
    [self.view1 addConstraints:constraint2];
    
}

- (void)setupExplainLabel2 {
    
    
    self.explainLabel2 = [[UILabel alloc] init];
    [self.explainLabel2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.explainLabel2 invalidateIntrinsicContentSize];
    self.explainLabel2.textColor = [UIColor whiteColor];
    self.explainLabel2.numberOfLines = 3;
    self.explainLabel2.textAlignment = NSTextAlignmentCenter;
    self.explainLabel2.font = [UIFont fontWithName:@"RooneySansLF-Regular" size:18];
    self.explainLabel2.text = text2;
    
    
    self.explainLabel2.layer.masksToBounds = NO;
    
    
    
    [self.view2 addSubview:self.explainLabel2];
    
    NSDictionary *viewsDictionary = @{@"label" : self.explainLabel2};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.explainLabel2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view2 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view2 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-pad-|" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:15]} views:viewsDictionary];
    [self.view2 addConstraints:constraint2];
    
}

- (void)setupExplainLabel3 {
    
    
    self.explainLabel3 = [[UILabel alloc] init];
    [self.explainLabel3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.explainLabel3 invalidateIntrinsicContentSize];
    self.explainLabel3.textColor = [UIColor whiteColor];
    self.explainLabel3.numberOfLines = 3;
    self.explainLabel3.textAlignment = NSTextAlignmentCenter;
    self.explainLabel3.font = [UIFont fontWithName:@"RooneySansLF-Regular" size:18];
    self.explainLabel3.text = text3;
    
    
    self.explainLabel3.layer.masksToBounds = NO;
    
    
    
    [self.view3 addSubview:self.explainLabel3];
    
    NSDictionary *viewsDictionary = @{@"label" : self.explainLabel3};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.explainLabel3 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view3 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view3 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-pad-|" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:15]} views:viewsDictionary];
    [self.view3 addConstraints:constraint2];
    
}

- (void)setupExplainLabel4 {
    
    
    self.explainLabel4 = [[UILabel alloc] init];
    [self.explainLabel4 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.explainLabel4 invalidateIntrinsicContentSize];
    self.explainLabel4.textColor = [UIColor whiteColor];
    self.explainLabel4.numberOfLines = 3;
    self.explainLabel4.textAlignment = NSTextAlignmentCenter;
    self.explainLabel4.font = [UIFont fontWithName:@"RooneySansLF-Regular" size:18];
    self.explainLabel4.text = text4;
    
    
    self.explainLabel4.layer.masksToBounds = NO;
    
    
    [self.view4 addSubview:self.explainLabel4];
    
    NSDictionary *viewsDictionary = @{@"label" : self.explainLabel4};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.explainLabel4 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view4 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view4 addConstraint:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-pad-|" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:15]} views:viewsDictionary];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)skipAction:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self.delegate runSetupAfterLogin];
    }];
    
}

- (IBAction)nextAction:(id)sender
{
    int destPage = [self getCurrentPage] + 1;
    CGFloat dimen = [[UIScreen mainScreen] bounds].size.width;
    
    if (destPage < 4)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.scrollView.contentOffset = CGPointMake(dimen*destPage, 0);
                             [self setCurrentPage:destPage];
                         }];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate runSetupAfterLogin];
        }];
        
    }
}

-(UIColor*)borderColor
{
    return [UIColor colorWithRed:0.63 green:0.63 blue:0.65 alpha:1.0];
}

-(UIColor*)baseColor
{
    return [UIColor colorWithRed:0.35 green:0.85 blue:0.64 alpha:1.0];
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
