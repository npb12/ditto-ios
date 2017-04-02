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
    NSInteger pic_count;
    UIColor *blueColor;
    BOOL loadedView;
}


- (IBAction)go_back:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (strong, nonatomic) IBOutlet UIView *navbar;
@property (strong, nonatomic) IBOutlet UILabel *age_label;
@property (strong, nonatomic) IBOutlet UILabel *edu_job;
@property (strong, nonatomic) IBOutlet UILabel *eduLabel;
@property (strong, nonatomic) IBOutlet UILabel *edit_header;
@property (strong, nonatomic)  User *user;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic)  UIImageView *pic;
@property (strong, nonatomic)  UIImageView *pic2;
@property (strong, nonatomic)  UIImageView *pic3;
@property (strong, nonatomic)  UIImageView *pic4;
@property (strong, nonatomic)  UIImageView *pic5;

@property (strong, nonatomic) UIView *tempView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view_height;

@property (nonatomic) CGFloat scroll_content_height;
@property (strong, nonatomic) IBOutlet UIView *scrollChildView;

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
    
    
    
    self.name_label.text = @"Neil";
    [self.profileImage setImage:[UIImage imageNamed:@"girl1"]];
    [self.bio_label setText:@"This is a string about me that is going to persuade you to give me a heart. From there we'll chat it up and make big plans, only for you...."];

    

    
    [self setFonts];

    
    [self initScrollView];
    //  [self addBackground];
}

-(void)getData
{
    [DAServer getProfile:@"" completion:^(User *user, NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {
            self.user = user;
            [self setAgeLabel];
            [self setTitleLabel];
            [self setEduLabel];
        } else {
            // update UI to indicate error or take remedial action
        }
    }];
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

- (void)setEduLabel{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"EDU: " attributes:@{NSForegroundColorAttributeName : grayColor, NSFontAttributeName: headerFont}]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Florida State University" attributes:@{NSForegroundColorAttributeName : blackColor, NSFontAttributeName: contentFont}]];
    self.eduLabel.attributedText = attrString;
}

-(void)initScrollView{
    
    CGRect fullScreenRect=[[UIScreen mainScreen] bounds];
    
    pic_count = 5;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    [self.view.layer insertSublayer:gradient atIndex:0];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)([UIColor whiteColor].CGColor),(id)([UIColor colorWithRed:0.95 green:0.95 blue:0.98 alpha:1.0].CGColor),nil];
    gradient.startPoint = CGPointMake(0.25,0.0);
    gradient.endPoint = CGPointMake(0.25,1.0);
    self.view.layer.masksToBounds = YES;
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.view_height.constant = self.view.frame.size.height / 1.75;

    
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
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:fullScreenRect.size.width * pic_count]];
    
    
    [self.scrollView setExclusiveTouch:NO];
    
    //   CGFloat contentHeightModifier = 0.0;
    CGFloat scroll_width = CGRectGetWidth([[UIScreen mainScreen] bounds]) * pic_count;
    
    
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.view_height.constant]];
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:scroll_width]];
    
    
    [self initPageController];
    
    
    if (pic_count > 0)
    {
        [self addPhoto];
    }
    
    if (pic_count > 1)
    {
        [self addPhoto2];
    }
    
    if (pic_count > 2)
    {
        [self addPhoto3];
    }
    
    if (pic_count > 3)
    {
        [self addPhoto4];
        
    }
    
    if (pic_count > 4)
    {
        [self addPhoto5];
    }
    
}

-(void)addPhoto{
    
    self.pic = [[UIImageView alloc]init];
    
    self.pic.backgroundColor = [UIColor blueColor];
    //  CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.pic.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic invalidateIntrinsicContentSize];
    self.pic.layer.cornerRadius = 10;
    [self.pic setClipsToBounds:YES];
    
    self.pic.image = [UIImage imageNamed:@"girl1"];
    
    self.pic.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.tempView addSubview:self.pic];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:15]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view_height.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 30];
    [self.tempView addConstraint:constraint4];
    
}


-(void)addPhoto2{
    
    self.pic2 = [[UIImageView alloc]init];
    
    CGFloat width = self.view.frame.size.width;
    self.pic2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic2 invalidateIntrinsicContentSize];
    self.pic2.layer.cornerRadius = 10;
    [self.pic2 setClipsToBounds:YES];
    self.pic2.image = [UIImage imageNamed:@"girl1"];
    
    self.pic2.alpha = 2.0;
    
    self.pic2.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.tempView addSubview:self.pic2];
    
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic2, @"pic1":self.pic};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pic1]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:30]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view_height.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 30];
    [self.tempView addConstraint:constraint4];
    
}

-(void)addPhoto3{
    
    self.pic3 = [[UIImageView alloc]init];
    
    CGFloat width = self.view.frame.size.width;
    self.pic3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic3 invalidateIntrinsicContentSize];
    self.pic3.layer.cornerRadius = 10;
    [self.pic3 setClipsToBounds:YES];
    
    self.pic3.image = [UIImage imageNamed:@"girl1"];
    
    
    self.pic3.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.tempView addSubview:self.pic3];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic3, @"pic2":self.pic2};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pic2]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:30]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view_height.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 30];
    [self.tempView addConstraint:constraint4];
    
}

-(void)addPhoto4{
    
    self.pic4 = [[UIImageView alloc]init];
    
    self.pic4.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic4 invalidateIntrinsicContentSize];
    self.pic4.layer.cornerRadius = 10;
    [self.pic4 setClipsToBounds:YES];
    
    self.pic4.image = [UIImage imageNamed:@"girl1"];
    
    
    self.pic4.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.tempView addSubview:self.pic4];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic4, @"pic3":self.pic3};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pic3]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:30]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view_height.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 30];
    [self.tempView addConstraint:constraint4];
    
}


-(void)addPhoto5{
    
    self.pic5 = [[UIImageView alloc]init];
    
    self.pic5.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic5 invalidateIntrinsicContentSize];
    self.pic5.layer.cornerRadius = 10;
    [self.pic5 setClipsToBounds:YES];
    
    self.pic5.image = [UIImage imageNamed:@"girl1"];
    
    
    self.pic5.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.tempView addSubview:self.pic5];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic5, @"pic4":self.pic4};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pic4]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:30]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic5 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view_height.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic5 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 30];
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
        [self setCurrentPage:page];
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

-(void)initPageController
{
    CGFloat radius = self.pc1.frame.size.width / 2;
    
    blueColor = self.name_label.textColor;
    
    [self setCurrentPage:0];
    
    self.pc1.layer.cornerRadius = radius;
    self.pc2.layer.cornerRadius = radius;
    self.pc3.layer.cornerRadius = radius;
    self.pc4.layer.cornerRadius = radius;
    self.pc5.layer.cornerRadius = radius;
    
    
    
    self.pc1.layer.borderColor = blueColor.CGColor;
    self.pc1.layer.borderWidth = 1;
    self.pc2.layer.borderColor = blueColor.CGColor;
    self.pc2.layer.borderWidth = 1;
    self.pc3.layer.borderColor = blueColor.CGColor;
    self.pc3.layer.borderWidth = 1;
    self.pc4.layer.borderColor = blueColor.CGColor;
    self.pc4.layer.borderWidth = 1;
    self.pc5.layer.borderColor = blueColor.CGColor;
    self.pc5.layer.borderWidth = 1;
    if (pic_count == 1)
    {
        [self hideAllPCs];
    }
    else if (pic_count == 2)
    {
        [self.pc3 setHidden:YES];
        [self.pc4 setHidden:YES];
        [self.pc5 setHidden:YES];
        self.centerConstraint.constant = 18;
    }
    else if (pic_count == 3)
    {
        [self.pc4 setHidden:YES];
        [self.pc5 setHidden:YES];
        self.centerConstraint.constant = 12;
    }
    else if (pic_count == 4)
    {
        [self.pc5 setHidden:YES];
        self.centerConstraint.constant = 6;
        
    }
    
    
    
}

-(void)hideAllPCs
{
    [self.pc1 setHidden:YES];
    [self.pc2 setHidden:YES];
    [self.pc3 setHidden:YES];
    [self.pc4 setHidden:YES];
    [self.pc5 setHidden:YES];
    
}

-(void)setCurrentPage:(int)index
{
    
    
    if (index == 0)
    {
        self.pc1.backgroundColor = blueColor;
        self.pc2.backgroundColor = [UIColor clearColor];
        self.pc3.backgroundColor = [UIColor clearColor];
        self.pc4.backgroundColor = [UIColor clearColor];
        self.pc5.backgroundColor = [UIColor clearColor];
        
    }
    else if (index == 1)
    {
        self.pc1.backgroundColor = [UIColor clearColor];
        self.pc2.backgroundColor = blueColor;
        self.pc3.backgroundColor = [UIColor clearColor];
        self.pc4.backgroundColor = [UIColor clearColor];
        self.pc5.backgroundColor = [UIColor clearColor];
    }
    else if (index == 2)
    {
        self.pc1.backgroundColor = [UIColor clearColor];
        self.pc2.backgroundColor = [UIColor clearColor];
        self.pc3.backgroundColor = blueColor;
        self.pc4.backgroundColor = [UIColor clearColor];
        self.pc5.backgroundColor = [UIColor clearColor];
    }
    else if (index == 3)
    {
        self.pc1.backgroundColor = [UIColor clearColor];
        self.pc2.backgroundColor = [UIColor clearColor];
        self.pc3.backgroundColor = [UIColor clearColor];
        self.pc4.backgroundColor = blueColor;
        self.pc5.backgroundColor = [UIColor clearColor];
    }
    else if (index == 4)
    {
        self.pc1.backgroundColor = [UIColor clearColor];
        self.pc2.backgroundColor = [UIColor clearColor];
        self.pc3.backgroundColor = [UIColor clearColor];
        self.pc4.backgroundColor = [UIColor clearColor];
        self.pc5.backgroundColor = blueColor;
    }
    
    
}

@end
