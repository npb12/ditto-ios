//
//  ProfileViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/3/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface ProfileViewController (){
    UIColor *grayColor;
    UIColor *blackColor;
    UIFont *headerFont;
    UIFont *contentFont;
    UIButton *parentButton;
    NSInteger pic_count;
    UIColor *blueColor;
}



@property (strong, nonatomic) IBOutlet UILabel *bio_label;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView *tempView;

@property (strong, nonatomic) IBOutlet UILabel *name_label;
@property (strong, nonatomic) IBOutlet UILabel *eduLabel;


@property (nonatomic, copy) void (^blocksCompletionHandler)(void);



@property (strong, nonatomic) IBOutlet UILabel *edu_job;
@property (strong, nonatomic) IBOutlet UILabel *age_label;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *photoHeight;

@property (strong, nonatomic) UIImageView *pic;
@property (strong, nonatomic) UIImageView *pic2;
@property (strong, nonatomic) UIImageView *pic3;
@property (strong, nonatomic) UIImageView *pic4;
@property (strong, nonatomic) UIImageView *pic5;

@property (strong, nonatomic) IBOutlet UIView *scrollChildView;

@property (strong, nonatomic) IBOutlet UIButton *likeBtn;
@property (strong, nonatomic) IBOutlet UIView *grayView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *likeBottomSpace;


@end

@implementation ProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    self.photoHeight.constant = self.view.frame.size.height / 1.75;
    
    
    // self.message_btn.layer.cornerRadius = 15;
    // self.photos_btn.layer.cornerRadius = 15;
    
    
    [self setFonts];
    [self setAgeLabel];
    
    if (![self.user.job isEqualToString:@""] && self.user.job != nil) {
        [self setTitleLabel];
    }else{
        self.jobLabelHeight.constant = 0;
        self.jobLabelTop.constant = 0;
    }
    
    if (![self.user.edu isEqualToString:@""] && self.user.edu != nil) {
        [self setEduLabel];
    }else{
        self.eduLabelHeight.constant = 0;
        self.eduLabelTop.constant = 0;
    }

    [self addGradientLayer:self.likeBtn];
    [self.likeBtn setImage:[UIImage imageNamed:@"Icon_HeartWithShadow_Active"] forState:UIControlStateNormal];
    self.likeBtn.layer.cornerRadius = 37.5;
    self.likeBtn.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
    self.likeBtn.layer.shadowOffset = CGSizeMake(0, 2.5f);
    self.likeBtn.layer.shadowOpacity = 1.0f;
    self.likeBtn.layer.shadowRadius = 0.0f;
    self.likeBtn.layer.borderWidth = 2;
    self.likeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    

    [self initScrollView];
    //   self.tableViewHeight.constant = self.view.bounds.size.height / 3;
    
    //   [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.name_label.text = self.user.name;
    
}

- (void) viewDidAppear:(BOOL)animated
{
  //  NSInteger offset = (self.view.frame.size.height / 2.85);
    [UIView animateWithDuration:0.25 delay:0.0 options:0 animations:^
     {
         self.likeBottomSpace.constant = 5;
         [self.view layoutIfNeeded];
     }
                     completion:^(BOOL finished)
     {

     }];
}

-(void)initScrollView{
    
    pic_count = [self.user.pics count];

    
    CGRect fullScreenRect=[[UIScreen mainScreen] bounds];
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    [self.view.layer insertSublayer:gradient atIndex:0];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)([UIColor whiteColor].CGColor),(id)([UIColor colorWithRed:0.95 green:0.95 blue:0.98 alpha:1.0].CGColor),nil];
    gradient.startPoint = CGPointMake(0.25,0.0);
    gradient.endPoint = CGPointMake(0.25,1.0);
    self.view.layer.masksToBounds = YES;
    
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
    CGFloat scroll_width = CGRectGetWidth([[UIScreen mainScreen] bounds]) * pic_count;
    
    
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.photoHeight.constant]];
    
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




- (void)setFonts{
    grayColor = self.grayView.backgroundColor;
    blackColor = self.bio_label.textColor;
    headerFont = [UIFont systemFontOfSize:11.0];
    contentFont = [UIFont systemFontOfSize:17.0];
    
}

- (void)setAgeLabel{
    
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"AGE: " attributes:@{NSForegroundColorAttributeName : grayColor, NSFontAttributeName: headerFont}]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:self.user.age attributes:@{NSForegroundColorAttributeName : blackColor, NSFontAttributeName: contentFont}]];
    self.age_label.attributedText = attrString;
}

//

- (void)setTitleLabel{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"TITLE: " attributes:@{NSForegroundColorAttributeName : grayColor, NSFontAttributeName: headerFont}]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:self.user.job attributes:@{NSForegroundColorAttributeName : blackColor, NSFontAttributeName: contentFont}]];
    self.edu_job.attributedText = attrString;
}

- (void)setEduLabel{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"EDU: " attributes:@{NSForegroundColorAttributeName : grayColor, NSFontAttributeName: headerFont}]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:self.user.edu attributes:@{NSForegroundColorAttributeName : blackColor, NSFontAttributeName: contentFont}]];
    self.eduLabel.attributedText = attrString;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addPhoto{
    
    self.pic = [[UIImageView alloc]init];
    
    self.pic.backgroundColor = [UIColor blueColor];
    //  CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.pic.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic invalidateIntrinsicContentSize];
    self.pic.layer.cornerRadius = 10;
    [self.pic setClipsToBounds:YES];
    
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:0]]
                 placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                          options:SDWebImageRefreshCached];
    self.pic.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.tempView addSubview:self.pic];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:15]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.photoHeight.constant];
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
    [self.pic2 sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:1]]
                 placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                          options:SDWebImageRefreshCached];
    self.pic2.alpha = 2.0;
    
    self.pic2.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.tempView addSubview:self.pic2];
    
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic2, @"pic1":self.pic};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pic1]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:30]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.photoHeight.constant];
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
    
    [self.pic3 sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:2]]
                 placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                          options:SDWebImageRefreshCached];
    
    self.pic3.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.tempView addSubview:self.pic3];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic3, @"pic2":self.pic2};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pic2]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:30]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.photoHeight.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 30];
    [self.tempView addConstraint:constraint4];
    
}

-(void)addPhoto4{
    
    self.pic4 = [[UIImageView alloc]init];
    
    self.pic4.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic4 invalidateIntrinsicContentSize];
    self.pic4.clipsToBounds = YES;
    self.pic4.contentMode = UIViewContentModeScaleAspectFill;
    [self.pic4 sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:3]]
                 placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                          options:SDWebImageRefreshCached];
    
    
    
    [self.tempView addSubview:self.pic4];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic4, @"pic3":self.pic3};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[pic3]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.photoHeight.constant ];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 30];
    [self.tempView addConstraint:constraint4];
    
}


-(void)addPhoto5{
    
    self.pic5 = [[UIImageView alloc]init];
    
    self.pic5.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic5 invalidateIntrinsicContentSize];
    self.pic5.clipsToBounds = YES;
    self.pic5.contentMode = UIViewContentModeScaleAspectFill;
    [self.pic5 sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:4]]
                 placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                          options:SDWebImageRefreshCached];
    
    
    
    [self.tempView addSubview:self.pic5];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic5, @"pic4":self.pic4};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[pic4]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic5 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.photoHeight.constant ];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic5 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 30];
    [self.tempView addConstraint:constraint4];
    
}


- (IBAction)liked:(id)sender {
    id<LikedProfileProtocol> strongDelegate = self.delegate;
    [strongDelegate likeCurrent];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    if (scrollView == self.scrollView) {
        
        CGFloat pageWidth = self.view.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        [self setCurrentPage:page];
    }
    
    
}


/*
- (IBAction)heart_button:(id)sender {
    
    
    [self.top_heart setHidden:YES];
    NSNotification* notification = [NSNotification notificationWithName:@"heartCurrentUser" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.liked_icon setHidden:NO];
    [[TFHeartAnimationView sharedInstance] showWithAnchorPoint:[self.view convertPoint:self.liked_icon.center toView:nil] completion:^(void)
     {
     }];
    
    [self performSelector:@selector(onTick:) withObject:nil afterDelay:0.5];


    
} */

-(void)addGradientLayer:(UIButton*)button{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    [button.layer insertSublayer:gradient atIndex:0];
    gradient.frame = button.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)([UIColor colorWithRed:0.29 green:0.34 blue:0.86 alpha:1.0].CGColor),(id)([UIColor colorWithRed:0.01 green:0.68 blue:0.80 alpha:1.0].CGColor),nil];
    gradient.startPoint = CGPointMake(0.25,0.0);
    gradient.endPoint = CGPointMake(0.25,1.0);
    [button bringSubviewToFront:button.imageView];
    button.layer.masksToBounds = YES;
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
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
