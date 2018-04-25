//
//  ProfileViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/3/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"
@import PullToDismiss;


@interface ProfileViewController (){
    UIColor *blackColor;
    UIFont *headerFont;
    UIFont *contentFont;
    UIButton *parentButton;
    NSInteger pic_count;
    UIColor *blueColor;
}

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewWidth;

@property (strong, nonatomic) IBOutlet UIView *contentContainerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerTrailingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerLeadingConstraint;

@property (strong, nonatomic) IBOutlet UILabel *bio_label;

@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView *tempView;

@property (strong, nonatomic) IBOutlet UILabel *name_label;
@property (strong, nonatomic) IBOutlet UILabel *eduLabel;


@property (nonatomic, copy) void (^blocksCompletionHandler)(void);

@property (strong, nonatomic) IBOutlet UIButton *likeBtn;
@property (strong, nonatomic) IBOutlet UIButton *dislikeBtn;


@property (strong, nonatomic) IBOutlet UILabel *edu_job;


@property (strong, nonatomic) UIImageView *pic;
@property (strong, nonatomic) UIImageView *pic2;
@property (strong, nonatomic) UIImageView *pic3;
@property (strong, nonatomic) UIImageView *pic4;
@property (strong, nonatomic) UIImageView *pic5;

@property (strong, nonatomic) IBOutlet UIView *scrollChildView;

@property (strong, nonatomic) IBOutlet UIView *grayView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatBottom;

@property (strong, nonatomic) IBOutlet UIButton *chatBtn;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatWidth;

@property(nonatomic, nullable) PullToDismiss *pullToDismiss;
@end

@implementation ProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pullToDismiss = [[PullToDismiss alloc] initWithScrollView:self.contentScrollView];
    
    self.pullToDismiss.delegate = self;
    self.pullToDismiss.dismissableHeightPercentage = 0.35f;
    __weak typeof(self) wSelf = self;
    self.pullToDismiss.dismissAction = ^{
        NSLog(@"!!!");
        [wSelf dismissVC];
    };
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat bigSize = width / 5;
    
    self.chatHeight.constant = bigSize;
    self.chatWidth.constant = bigSize;
    

    if (self.match)
    {
        NSLog(@"View match profile");
        [self.chatBtn setHidden:NO];
        [self.likeBtn setHidden:YES];
        [self.dislikeBtn setHidden:YES];

    }
    else if(self.isMine)
    {
        [self.chatBtn setHidden:YES];
        [self.likeBtn setHidden:YES];
        [self.dislikeBtn setHidden:YES];
    }
    else
    {
        NSLog(@"Non match profile");
        [self.chatBtn setHidden:YES];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height + 35;
        CGFloat bigSize = width / 5;
         self.likeBtn.frame = CGRectMake(self.view.frame.size.width / 1.9,height,bigSize,bigSize);
        self.dislikeBtn.frame = CGRectMake(self.view.frame.size.width / 4.1,height,bigSize,bigSize);
        
    }
    
        
    self.name_label.text = [NSString stringWithFormat:@"%@, %@", self.user.name, self.user.age];    
    
    if (![self.user.job isEqualToString:@""] && self.user.job != nil)
    {
        self.edu_job.text = self.user.job;
    }
    else
    {
        [self.edu_job setHidden:YES];
    }
    
    if (![self.user.edu isEqualToString:@""] && self.user.edu != nil)
    {
        self.eduLabel.text = self.user.edu;
    }else{
        [self.eduLabel setHidden:YES];
    }
    
    if (![self.user.bio isEqualToString:@""] && self.user.bio != nil)
    {
        self.bio_label.text = self.user.bio;
    }


    
    
    if (self.user.distance == 1)
    {
        self.distanceLabel.text = [NSString stringWithFormat:@"%ld mile away", (long)self.user.distance];
    }
    else
    {
        self.distanceLabel.text = [NSString stringWithFormat:@"%ld miles away", (long)self.user.distance];
    }
    
    NSInteger distance = floor(self.user.distance);
    NSString *distanceStr;
    
    if (distance == 1)
    {
        distanceStr = @" mile away";
    }
    else
    {
        distanceStr = @" miles away";
    }
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%ld%@", (long)distance, distanceStr];

    [self initScrollView];
    //   self.tableViewHeight.constant = self.view.bounds.size.height / 3;
    
    //   [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    /*
    UIPanGestureRecognizer * pan1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveObject:)];
    pan1.minimumNumberOfTouches = 1;
    [self.scrollView addGestureRecognizer:pan1]; */

}


#pragma animation stuff

/*
 internal func configureRoundedCorners(shouldRound: Bool) {
 headerImageView.layer.cornerRadius = shouldRound ? 14.0 : 0.0
 }
 */

-(void)configureRoundedCorners:(BOOL)shouldRound
{
    self.scrollView.layer.cornerRadius = shouldRound ? 14.0 : 0.0;
    self.headerView.layer.cornerRadius = shouldRound ? 14.0 : 0.0;
}

-(void)setHeaderHeight:(CGFloat)height
{
    self.headerViewHeight.constant = height;
    [self.view layoutIfNeeded];
}

-(void)positionContainer:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom
{
    self.containerLeadingConstraint.constant = left;
    self.containerTrailingConstraint.constant = right;
    self.containerTopConstraint.constant = top;
    self.containerBottomConstraint.constant = bottom;
    [self.view layoutIfNeeded];
}


-(void)initScrollView{
    
    pic_count = [self.user.pics count];

    
    CGRect fullScreenRect=[[UIScreen mainScreen] bounds];
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.scrollView setClipsToBounds:YES];
    self.scrollView.layer.masksToBounds = YES;
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
    self.scrollViewWidth.constant = CGRectGetWidth([[UIScreen mainScreen] bounds]) * pic_count;
    
    
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.headerViewHeight.constant]];
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.scrollViewWidth.constant]];
    
    
    UIColor *black = [UIColor blackColor];
    UIColor *white = [UIColor blackColor];
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bottomView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)([white colorWithAlphaComponent:0.0].CGColor),(id)([black colorWithAlphaComponent:0.4].CGColor),(id)([white colorWithAlphaComponent:0.7].CGColor),nil];
    gradient.startPoint = CGPointMake(0.25,0.0);
    gradient.endPoint = CGPointMake(0.25,1.0);
    [self.bottomView.layer insertSublayer:gradient atIndex:0];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addPhoto{
    
    self.pic = [[UIImageView alloc]init];
    
    //  CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.pic.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic invalidateIntrinsicContentSize];
    [self.pic setClipsToBounds:YES];
    [self.pic setBackgroundColor:[UIColor lightTextColor]];
    
    /*
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:0]]
                 placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           if (!error) {
                               self.pic.layer.borderWidth = 0;
                               self.pic.layer.borderColor = [UIColor clearColor].CGColor;
                               
                           }
                       }]; */
    
    if (self.user.profileImage)
    {
        CGSize size = CGSizeMake(self.view.frame.size.width, self.headerViewHeight.constant);
        UIImage *scaledImage = [self.user.profileImage scaleImageToSize:size];
        self.pic.image = scaledImage;
    }
    else
    {
        [PhotoDownloader downloadImage:[self.user.pics objectAtIndex:0] completion:^(UIImage *image, NSError *error)
         {
             if (image && !error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     CGSize size = CGSizeMake(self.view.frame.size.width, self.headerViewHeight.constant);
                     UIImage *scaledImage = [image scaleImageToSize:size];
                     self.pic.image = scaledImage;
                 });
             }
             
         }];
    }
    
    
    self.pic.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.tempView addSubview:self.pic];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.headerViewHeight.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width];
    [self.tempView addConstraint:constraint4];
    
}


-(void)addPhoto2{
    
    self.pic2 = [[UIImageView alloc]init];
    
    self.pic2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic2 invalidateIntrinsicContentSize];
    [self.pic2 setClipsToBounds:YES];
    [self.pic2 setBackgroundColor:[UIColor lightTextColor]];

    /*
    [self.pic2 sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:1]]
                 placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                          options:SDWebImageRefreshCached]; */
    
    [PhotoDownloader downloadImage:[self.user.pics objectAtIndex:1] completion:^(UIImage *image, NSError *error)
     {
         if (image && !error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 CGSize size = CGSizeMake(self.view.frame.size.width, self.headerViewHeight.constant);
                 UIImage *scaledImage = [image scaleImageToSize:size];
                 self.pic2.image = scaledImage;
             });
        
         }
         
     }];
    
    self.pic2.alpha = 2.0;
    
    self.pic2.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.tempView addSubview:self.pic2];
    
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic2, @"pic1":self.pic};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pic1]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.headerViewHeight.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width];
    [self.tempView addConstraint:constraint4];
    
}

-(void)addPhoto3{
    
    self.pic3 = [[UIImageView alloc]init];
    
    self.pic3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic3 invalidateIntrinsicContentSize];
    [self.pic3 setClipsToBounds:YES];
    [self.pic3 setBackgroundColor:[UIColor lightTextColor]];

    
    /*
    [self.pic3 sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:2]]
                 placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                          options:SDWebImageRefreshCached]; */
    
    [PhotoDownloader downloadImage:[self.user.pics objectAtIndex:2] completion:^(UIImage *image, NSError *error)
     {
         if (image && !error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 CGSize size = CGSizeMake(self.view.frame.size.width, self.headerViewHeight.constant);
                 UIImage *scaledImage = [image scaleImageToSize:size];
                 self.pic3.image = scaledImage;
             });
         }
         
     }];
    
    self.pic3.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.tempView addSubview:self.pic3];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic3, @"pic2":self.pic2};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pic2]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.headerViewHeight.constant];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width];
    [self.tempView addConstraint:constraint4];
    
}

-(void)addPhoto4{
    
    self.pic4 = [[UIImageView alloc]init];
    
    self.pic4.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic4 invalidateIntrinsicContentSize];
    self.pic4.clipsToBounds = YES;
    [self.pic4 setBackgroundColor:[UIColor lightTextColor]];

    /*
    [self.pic4 sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:3]]
                 placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                          options:SDWebImageRefreshCached]; */
    [PhotoDownloader downloadImage:[self.user.pics objectAtIndex:3] completion:^(UIImage *image, NSError *error)
     {
         if (image && !error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 CGSize size = CGSizeMake(self.view.frame.size.width, self.headerViewHeight.constant);
                 UIImage *scaledImage = [image scaleImageToSize:size];
                 self.pic4.image = scaledImage;
             });

             
         }
         
     }];
    self.pic4.contentMode = UIViewContentModeScaleAspectFill;

    
    
    [self.tempView addSubview:self.pic4];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic4, @"pic3":self.pic3};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pic3]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.headerViewHeight.constant ];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width];
    [self.tempView addConstraint:constraint4];
    
}


-(void)addPhoto5{
    
    self.pic5 = [[UIImageView alloc]init];
    
    self.pic5.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic5 invalidateIntrinsicContentSize];
    self.pic5.clipsToBounds = YES;
    self.pic5.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.pic5 setBackgroundColor:[UIColor lightTextColor]];
    
    /*
    [self.pic5 sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:4]]
                 placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                          options:SDWebImageRefreshCached]; */
    [PhotoDownloader downloadImage:[self.user.pics objectAtIndex:4] completion:^(UIImage *image, NSError *error)
     {
         if (image && !error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 CGSize size = CGSizeMake(self.view.frame.size.width, self.headerViewHeight.constant);
                 UIImage *scaledImage = [image scaleImageToSize:size];
                 self.pic5.image = scaledImage;
             });

         }
         
     }];
    
    
    [self.tempView addSubview:self.pic5];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic5, @"pic4":self.pic4};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pic4]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic5 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.headerViewHeight.constant ];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic5 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width];
    [self.tempView addConstraint:constraint4];
    
}


- (IBAction)liked:(id)sender {
    id<LikedProfileProtocol> strongDelegate = self.delegate;
    [strongDelegate likeCurrent:YES];
    
}

- (IBAction)disliked:(id)sender {
    id<LikedProfileProtocol> strongDelegate = self.delegate;
    [strongDelegate likeCurrent:NO];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    if (scrollView == self.scrollView) {
        
        CGFloat pageWidth = self.view.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        [self setCurrentPage:page];
    }
    
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
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
    [self.backIcon setAlpha:0.0];
    
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page > 0 && !self.isMine && !self.match)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else
    {
        [self dismissVC];
    }
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self dismissVC];
}

-(void)initPageController
{
    
    blueColor = self.name_label.textColor;
    
    [self setCurrentPage:0];
    

    if (pic_count == 1)
    {
        [self hideAllPCs];
    }
    else if (pic_count == 2)
    {
        [self.pc3 setHidden:YES];
        [self.pc4 setHidden:YES];
        [self.pc5 setHidden:YES];
        self.centerConstraint.constant = 28;
    }
    else if (pic_count == 3)
    {
     [self.pc4 setHidden:YES];
     [self.pc5 setHidden:YES];
     self.centerConstraint.constant = 21;
    }
    else if (pic_count == 4)
    {
        [self.pc5 setHidden:YES];
        self.centerConstraint.constant = 14;
        
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
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self.pc1 setImage:[UIImage imageNamed:@"indicator_active"]];
                             [self.pc2 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             [self.pc3 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             [self.pc4 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             [self.pc5 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             
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
                             [self.pc5 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             
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
                             [self.pc5 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             
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
                             [self.pc5 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             
                         }];
    }
    else if (index == 4)
    {
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self.pc1 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             [self.pc2 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             [self.pc3 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             [self.pc4 setImage:[UIImage imageNamed:@"indicator_inactive"]];
                             [self.pc5 setImage:[UIImage imageNamed:@"indicator_active"]];
                             
                         }];
    }
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"messageSegue"])
    {
        /*
        UINavigationController *nc = segue.destinationViewController;
        MessageViewController *vc = (MessageViewController *)nc.topViewController;
        vc.delegateModal = self; */
    }
}
/*
- (void)didDismissMessageViewController:(MessageViewController *)vc
{
    [self dismissViewControllerAnimated:YES completion:nil];
} */


-(void)dismissVC
{
    if (self.match || self.isMine)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(UIColor*)bgGray
{
    return [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
}

- (void)viewDidLayoutSubviews
{
    CGFloat bottom = self.bio_label.frame.origin.y + self.bio_label.frame.size.height + 50;
    
    if (bottom < [UIScreen mainScreen].bounds.size.height)
    {
        bottom = [UIScreen mainScreen].bounds.size.height + 50;
    }
    
    dispatch_async (dispatch_get_main_queue(), ^
                    {
                        [self.contentScrollView setContentSize:CGSizeMake(0, bottom)];
                    });
}



@end
