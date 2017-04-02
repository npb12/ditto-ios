//
//  MatchViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/7/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface MatchViewController (){
    UIColor *grayColor;
    UIColor *blackColor;
    UIFont *headerFont;
    UIFont *contentFont;
    UIButton *parentButton;
    NSInteger pic_count;
    UIColor *blueColor;
    MatchUser *user;

}

@property (strong, nonatomic) IBOutlet UIImageView *profile_image;
@property (strong, nonatomic) IBOutlet UIView *bottom_view;
@property (strong, nonatomic) IBOutlet UIView *bottom_divider_view;


@property (strong, nonatomic) IBOutlet UILabel *bio_label;


@property (strong, nonatomic) IBOutlet UILabel *match_time_label;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView *tempView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;


@property (strong, nonatomic) IBOutlet UIView *divider_view;

@property (nonatomic, copy) void (^blocksCompletionHandler)(void);

@property (strong, nonatomic) IBOutlet UIView *profile_parent;

@property (strong, nonatomic) IBOutlet UILabel *single_label;
- (IBAction)unmatchAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *balloon_string;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property (strong, nonatomic) IBOutlet UIView *alpha_view;

@property (strong, nonatomic) IBOutlet UIImageView *cover_view;

@property (strong, nonatomic) IBOutlet UIButton *message_btn;

@property (strong, nonatomic) IBOutlet UILabel *eduLabel;
@property (strong, nonatomic) IBOutlet UIButton *photos_btn;
@property (strong, nonatomic) IBOutlet UILabel *edu_job;
@property (strong, nonatomic) IBOutlet UILabel *age_label;
@property (strong, nonatomic) IBOutlet UIButton *message_fab;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *photoHeight;

@property (strong, nonatomic) IBOutlet UIImageView *pic;
@property (strong, nonatomic) IBOutlet UIImageView *pic2;
@property (strong, nonatomic) IBOutlet UIImageView *pic3;
@property (strong, nonatomic) IBOutlet UIImageView *pic4;
@property (strong, nonatomic) IBOutlet UIImageView *pic5;

@property (strong, nonatomic) IBOutlet UIView *scrollChildView;

@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIImageView *chat_icon;
@property (strong, nonatomic) IBOutlet UILabel *name_label;
@property (strong, nonatomic) IBOutlet UIButton *messageBtn;

@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.profile_image setImage:[UIImage imageNamed:@"girl1"]];

    self.photoHeight.constant = self.view.frame.size.height / 1.75;
    

    user = [MatchUser currentUser];
    self.name_label.text = user.name;
    
    [self setFonts];
    [self setAgeLabel];
    

    if (![user.work isEqualToString:@""] && user.work != nil)
    {
        [self setTitleLabel];
    }
    else
    {
        self.jobLabelHeight.constant = 0;
        self.jobLabelTop.constant = 0;
    }
    
    if (![user.education isEqualToString:@""] && user.education != nil)
    {
        [self setEduLabel];
    }
    else
    {
        self.eduLabelHeight.constant = 0;
        self.eduLabelTop.constant = 0;
    }
    
    if (![user.bio isEqualToString:@""] && user.bio != nil)
    {
        self.bio_label.text = user.bio;
    }
    else
    {
        self.bioLabelHeight.constant = 0;
        self.bioLabelTop.constant = 0;
    }
    

    
    [self initScrollView];

}



-(void)initScrollView{
    
    CGRect fullScreenRect=[[UIScreen mainScreen] bounds];
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    pic_count = 5;//[self.m count];

    
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
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:fullScreenRect.size.width * pic_count]];
    
    
    [self.scrollView setExclusiveTouch:NO];
    
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
    grayColor = self.match_time_label.textColor;
    blackColor = self.bio_label.textColor;
    headerFont = [UIFont systemFontOfSize:11.0];
    contentFont = [UIFont systemFontOfSize:17.0];
    
}

- (void)setAgeLabel
{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"AGE: " attributes:@{NSForegroundColorAttributeName : grayColor, NSFontAttributeName: headerFont}]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:user.age attributes:@{NSForegroundColorAttributeName : blackColor, NSFontAttributeName: contentFont}]];
    self.age_label.attributedText = attrString;
}


- (void)setTitleLabel
{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"TITLE: " attributes:@{NSForegroundColorAttributeName : grayColor, NSFontAttributeName: headerFont}]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:user.work attributes:@{NSForegroundColorAttributeName : blackColor, NSFontAttributeName: contentFont}]];
    self.edu_job.attributedText = attrString;
}

- (void)setEduLabel
{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"EDU: " attributes:@{NSForegroundColorAttributeName : grayColor, NSFontAttributeName: headerFont}]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:user.education attributes:@{NSForegroundColorAttributeName : blackColor, NSFontAttributeName: contentFont}]];
    self.eduLabel.attributedText = attrString;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addPhoto
{
    
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
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.photoHeight.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 30];
    [self.tempView addConstraint:constraint4];
    
}


-(void)addPhoto2
{
    
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
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.photoHeight.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 30];
    [self.tempView addConstraint:constraint4];
    
}

-(void)addPhoto3
{
    
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
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.photoHeight.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 30];
    [self.tempView addConstraint:constraint4];
    
}

-(void)addPhoto4
{
    
    self.pic4 = [[UIImageView alloc]init];
    
    CGFloat width = self.view.frame.size.width;
    self.pic4.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic4 invalidateIntrinsicContentSize];
    self.pic4.layer.cornerRadius = 10;
    [self.pic4 setClipsToBounds:YES];
    
    self.pic4.image = [UIImage imageNamed:@"girl1"];
    
    
    self.pic4.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.tempView addSubview:self.pic4];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic4, @"pic2":self.pic3};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pic2]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:30]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.photoHeight.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 30];
    [self.tempView addConstraint:constraint4];
    
}

-(void)addPhoto5
{
    
    self.pic5 = [[UIImageView alloc]init];
    
    CGFloat width = self.view.frame.size.width;
    self.pic5.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic5 invalidateIntrinsicContentSize];
    self.pic5.layer.cornerRadius = 10;
    [self.pic5 setClipsToBounds:YES];
    
    self.pic5.image = [UIImage imageNamed:@"girl1"];
    
    
    self.pic5.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.tempView addSubview:self.pic5];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic5, @"pic2":self.pic4};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pic2]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:30]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic5 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.photoHeight.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic5 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 30];
    [self.tempView addConstraint:constraint4];
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        
        CGFloat pageWidth = self.view.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        [self setCurrentPage:page];

    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIColor*)greyblueColor
{
    
    return [UIColor colorWithRed:0.47 green:0.53 blue:0.60 alpha:1.0];
}


- (IBAction)imageTap:(id)sender
{
    [self performSegueWithIdentifier:@"gotoAlbums" sender:self];
}





-(void)UnmatchSelected:(UIButton*)parentBtn
{
    parentButton = parentBtn;
    
    [UIView animateWithDuration:2.5f animations:^
     {
         self.profile_parent.alpha = 0.65;
         [self alphaAllViews:0.55];

         self.profile_parent.frame = CGRectOffset(self.profile_parent.frame, 0, -100);
         
         [UIView animateWithDuration:2.5 animations:^{
             self.profile_parent.alpha = 0.30;
             [self alphaAllViews:0.35];
             self.profile_parent.frame = CGRectOffset(self.profile_parent.frame, 0, -100);
             
             [UIView animateWithDuration:1.5 animations:^{
                 self.profile_parent.alpha = 0.25;
                 [self alphaAllViews:0.15];
                 self.single_label.alpha = 0.10;
                 [self.single_label setHidden:NO];
                 self.profile_parent.frame = CGRectOffset(self.profile_parent.frame, 0, -100);
                 
                 [UIView animateWithDuration:1.5 animations:^{
                     self.profile_parent.alpha = 0.10;
                     [self alphaAllViews:0.00];
                     self.single_label.alpha = 0.35;
                     self.profile_parent.frame = CGRectOffset(self.profile_parent.frame, 0, -100);
                     
                 }];
                 
             }];
             
         }];
         
         
     }];
    
}


-(void)alphaAllViews:(double)value
{
    self.bio_label.alpha = value;
    self.match_time_label.alpha = value;
    self.name_label.alpha = value;
    self.divider_view.alpha = value;
    self.bottom_view.alpha = value;
    self.bottom_divider_view.alpha = value;
    self.cover_view.alpha = value;
    self.alpha_view.alpha = value;
    self.match_time_label.alpha = value;
    self.edu_job.alpha = value;
    self.photos_btn.alpha = value;
    self.message_btn.alpha = value;
    self.pageControl.alpha = value;
    self.scrollView.alpha = value;
    self.age_label.alpha = value;
    self.view1.alpha = value;
    self.view2.alpha = value;
    self.name_label.alpha = value;
    self.chat_icon.alpha = value;
    self.eduLabel.alpha = value;
    self.pc1.alpha = value;
    self.pc2.alpha = value;
    self.pc3.alpha = value;
    self.pc4.alpha = value;
    self.pc5.alpha = value;
    parentButton.alpha = value;
    self.messageBtn.userInteractionEnabled = NO;
    [self.scrollView setScrollEnabled:NO];
}

- (IBAction)goToMessaging:(id)sender
{
    
    id<SegueProtocol> strongDelegate = self.delegate;
    [strongDelegate gotoMessage];
    /*
    NSNotification* notification = [NSNotification notificationWithName:@"goToMessaging" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification]; */
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
