//
//  MyProfileViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/12/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface MyProfileViewController (){
    UIColor *grayColor;
    UIColor *blackColor;
    UIFont *headerFont;
    UIFont *contentFont;
}


- (IBAction)go_back:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (strong, nonatomic) IBOutlet UIView *navbar;
@property (strong, nonatomic) IBOutlet UILabel *age_label;
@property (strong, nonatomic) IBOutlet UILabel *edu_job;
@property (strong, nonatomic) IBOutlet UILabel *edit_header;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *photoHeight;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *pic;
@property (strong, nonatomic) IBOutlet UIImageView *pic2;
@property (strong, nonatomic) IBOutlet UIImageView *pic3;
@property (strong, nonatomic) UIView *tempView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation MyProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    /*
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.navbar.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)([UIColor colorWithRed:0.29 green:0.34 blue:0.86 alpha:1.0].CGColor),(id)([UIColor colorWithRed:0.01 green:0.68 blue:0.80 alpha:1.0].CGColor),nil];
    gradient.startPoint = CGPointMake(0.25,0.0);
    gradient.endPoint = CGPointMake(0.25,1.0);
    [self.navbar.layer insertSublayer:gradient atIndex:0]; */
    
    self.photoHeight.constant = self.view.frame.size.height / 2;
    
    
    self.name_label.text = @"Neil";
    [self.profileImage setImage:[UIImage imageNamed:@"girl1"]];
    [self.bio_label setText:@"This is a string about me that is going to persuade you to give me a heart. From there we'll chat it up and make big plans, only for you...."];

    

    
    [self setFonts];
    [self setAgeLabel];
    [self setTitleLabel];
    
    [self initScrollView];
    //  [self addBackground];
}

-(void)initScrollView{
    
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
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:fullScreenRect.size.width * 3]];
    
    
    [self.scrollView setExclusiveTouch:NO];
    
    //   CGFloat contentHeightModifier = 0.0;
    CGFloat scroll_width = CGRectGetWidth([[UIScreen mainScreen] bounds]) * 3;
    
    
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.photoHeight.constant]];
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:scroll_width]];
    
    
    [self addPhoto];
    [self addPhoto2];
    [self addPhoto3];
    
}

-(void)addPhoto{
    
    self.pic = [[UIImageView alloc]init];
    
    self.pic.backgroundColor = [UIColor blueColor];
    CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.pic.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic invalidateIntrinsicContentSize];
    
    self.pic.image = [UIImage imageNamed:@"girl1"];
    
    self.pic.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.tempView addSubview:self.pic];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.photoHeight.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    [self.tempView addConstraint:constraint4];
    
}


-(void)addPhoto2{
    
    self.pic2 = [[UIImageView alloc]init];
    
    CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.pic2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic2 invalidateIntrinsicContentSize];
    
    self.pic2.image = [UIImage imageNamed:@"girl1"];
    
    self.pic2.alpha = 2.0;
    
    self.pic2.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.tempView addSubview:self.pic2];
    
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic2, @"pic1":self.pic};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pic1]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.photoHeight.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    [self.tempView addConstraint:constraint4];
    
}

-(void)addPhoto3{
    
    self.pic3 = [[UIImageView alloc]init];
    
    CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.pic3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic3 invalidateIntrinsicContentSize];
    
    self.pic3.image = [UIImage imageNamed:@"girl1"];
    
    
    self.pic3.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.tempView addSubview:self.pic3];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic3, @"pic2":self.pic2};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pic2]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.photoHeight.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    [self.tempView addConstraint:constraint4];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFonts{
    grayColor = self.colorView.backgroundColor;
    blackColor = self.bio_label.textColor;
    headerFont = [UIFont systemFontOfSize:11.0];
    contentFont = [UIFont systemFontOfSize:17.0];
    
}

- (void)setAgeLabel{
    
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"AGE: " attributes:@{NSForegroundColorAttributeName : grayColor, NSFontAttributeName: headerFont}]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"25" attributes:@{NSForegroundColorAttributeName : blackColor, NSFontAttributeName: contentFont}]];
    self.age_label.attributedText = attrString;
}

//

- (void)setTitleLabel{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"TITLE: " attributes:@{NSForegroundColorAttributeName : grayColor, NSFontAttributeName: headerFont}]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Software Engineer" attributes:@{NSForegroundColorAttributeName : blackColor, NSFontAttributeName: contentFont}]];
    self.edu_job.attributedText = attrString;
}



- (IBAction)edit_images:(id)sender {
}

- (IBAction)edit_info:(id)sender {
}

- (IBAction)go_back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        
        CGFloat pageWidth = self.view.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        [self.pageControl setCurrentPage:page];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"pickerSegue"]) {
        OccupationViewController *vc = segue.destinationViewController;
        vc.view.backgroundColor = [UIColor clearColor];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    /*
    self.networksVC = segue.destinationViewController;
    //  NewMatchViewController *matchVC = (NewMatchViewController *)segue.destinationViewController;
    self.networksVC.user_data = sender;
    //  self.networksVC.view.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3];
    self.networksVC.view.backgroundColor = [UIColor clearColor];
    self.networksVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;*/
}


- (IBAction)goBack:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)editJob:(id)sender {
}

- (IBAction)editBio:(id)sender {
}

@end
