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
}

@property (strong, nonatomic) IBOutlet UIImageView *profile_image;
@property (strong, nonatomic) IBOutlet UIView *bottom_view;
@property (strong, nonatomic) IBOutlet UIView *bottom_divider_view;

@property (strong, nonatomic) IBOutlet UIButton *matched_button;

@property (strong, nonatomic) IBOutlet UILabel *bio_label;

@property (strong, nonatomic) IBOutlet UILabel *name_label;

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

@property (strong, nonatomic) IBOutlet UIButton *photos_btn;
@property (strong, nonatomic) IBOutlet UILabel *edu_job;
@property (strong, nonatomic) IBOutlet UILabel *age_label;
@property (strong, nonatomic) IBOutlet UIButton *message_fab;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *photoHeight;

@property (strong, nonatomic) IBOutlet UIImageView *pic;
@property (strong, nonatomic) IBOutlet UIImageView *pic2;
@property (strong, nonatomic) IBOutlet UIImageView *pic3;
@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.profile_image setImage:[UIImage imageNamed:@"girl1"]];
    

    self.matched_button.layer.shadowColor = [self greyblueColor].CGColor;
    self.matched_button.layer.shadowOffset = CGSizeZero;
    self.matched_button.layer.shadowOpacity = 1.0;
    self.matched_button.layer.shadowRadius = 1.0;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.matched_button.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)([UIColor colorWithRed:0.29 green:0.34 blue:0.86 alpha:1.0].CGColor),(id)([UIColor colorWithRed:0.01 green:0.68 blue:0.80 alpha:1.0].CGColor),nil];
    gradient.startPoint = CGPointMake(0.25,0.0);
    gradient.endPoint = CGPointMake(0.25,1.0);
    [self.matched_button.layer insertSublayer:gradient atIndex:0];
    
    self.matched_button.layer.masksToBounds = YES;
    

    
    self.photoHeight.constant = self.view.frame.size.height / 2;
    

   // self.message_btn.layer.cornerRadius = 15;
   // self.photos_btn.layer.cornerRadius = 15;


    [self setFonts];
    [self setAgeLabel];
    [self setTitleLabel];
    
    
    self.message_fab.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
    self.message_fab.layer.shadowOffset = CGSizeMake(0, 2.5f);
    self.message_fab.layer.shadowOpacity = 1.0f;
    self.message_fab.layer.shadowRadius = 0.0f;
    self.message_fab.layer.masksToBounds = NO;
    
    [self initScrollView];
 //   self.tableViewHeight.constant = self.view.bounds.size.height / 3;
    
 //   [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];


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




- (void)setFonts{
    grayColor = self.match_time_label.textColor;
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    if (scrollView == self.scrollView) {
        
        CGFloat pageWidth = self.view.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        [self.pageControl setCurrentPage:page];
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

-(UIColor*)greyblueColor{
    
    return [UIColor colorWithRed:0.47 green:0.53 blue:0.60 alpha:1.0];
}


- (IBAction)imageTap:(id)sender {
    [self performSegueWithIdentifier:@"gotoAlbums" sender:self];
}



- (IBAction)unmatchAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unmatch"
                                                                   message:@"Are you sure you want to unmatch Neil?"
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"YES"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [self UnmatchSelected];
                                                          }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"NO"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               
                                                           }]; // 3
    
    [alert addAction:firstAction]; // 4
    [alert addAction:secondAction]; // 5
    
    [self presentViewController:alert animated:YES completion:nil]; // 6
    

}

-(void)UnmatchSelected{
    
    
    [self.balloon_string setHidden:NO];
    [self.matched_button setHidden:YES];
    
    
    [UIView animateWithDuration:2.5f animations:^
     {
         self.profile_parent.alpha = 0.65;
         [self hideAllViews:0.55];

         self.profile_parent.frame = CGRectOffset(self.profile_parent.frame, 0, -100);
         
         [UIView animateWithDuration:2.5 animations:^{
             self.profile_parent.alpha = 0.30;
             [self hideAllViews:0.35];
             self.profile_parent.frame = CGRectOffset(self.profile_parent.frame, 0, -100);
             
             [UIView animateWithDuration:1.5 animations:^{
                 self.profile_parent.alpha = 0.25;
                 [self hideAllViews:0.15];
                 self.single_label.alpha = 0.10;
                 [self.single_label setHidden:NO];
                 self.profile_parent.frame = CGRectOffset(self.profile_parent.frame, 0, -100);
                 
                 [UIView animateWithDuration:1.5 animations:^{
                     self.profile_parent.alpha = 0.10;
                     [self hideAllViews:0.00];
                     self.single_label.alpha = 0.35;
                     self.profile_parent.frame = CGRectOffset(self.profile_parent.frame, 0, -100);
                     
                 }];
                 
             }];
             
         }];
         
         
     }];
    
}


-(void)hideAllViews:(double)value{
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

}

- (IBAction)goToMessaging:(id)sender {
    
    NSNotification* notification = [NSNotification notificationWithName:@"goToMessaging" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

/*
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableViewHeight.constant / 3;
} */

@end
