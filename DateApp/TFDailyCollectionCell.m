//
//  TFDailyCollectionCell.m
//  TIFF
//
//  Created by Rhonda DeVore on 4/18/16.
//  Copyright © 2016 Silverpine Software. All rights reserved.
//

#import "Includes.h"

@interface TFDailyCollectionCell ()
@property (nonatomic, strong) NSDictionary *filmDict;
//@property (nonatomic, strong) TFFilm *film;
@property (strong, nonatomic) IBOutlet UIImageView *gradientCover;

@property (strong, nonatomic) IBOutlet UIImageView *heart;


@property (strong, nonatomic) UIView *tempView;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;



@property (strong, nonatomic) UITapGestureRecognizer* tapGesture;


@property (strong, nonatomic) IBOutlet UIButton *overlay;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *fadeBottomHeight;

@end

@implementation TFDailyCollectionCell






#pragma mark - TFCellFactory

+ (NSString*) reuseIdentifier
{
    return @"TFDailyCollectionCellReuseIdentifier";
}


+ (CGSize) sizeWithCellData:(TFCellData *)cellData
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width),([UIScreen mainScreen].bounds.size.height - 64 - 49));
}

- (void) updateFromCellData:(TFCellData *)cellData
{
    
 //   self.gradientCover.image = [UIImage uuSolidColorImage:[UIColor colorWithWhite:0 alpha:0.4]];
    
    
    //TFDebugLog(@"   FROM CELL  %@", @(self.frame.origin.x));
    if (cellData.cellType == TFCT_Daily_CC)
    {
        
        /*
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 7.0; */
        
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.fadeBottom1.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.fadeBottom1 addSubview:blurEffectView];
        
        /*
        self.fadeBottom1.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.fadeBottom1.layer.shadowOffset = CGSizeZero;
        self.fadeBottom1.layer.shadowOpacity = 1.0;
        self.fadeBottom1.layer.shadowRadius = 1.0; */
        [self initScrollView];
        [self.bottomScrollView setExclusiveTouch:NO];
        self.bottomScrollView.userInteractionEnabled = NO;
        [self addGestureRecognizer:self.bottomScrollView.panGestureRecognizer];
                
        
        self.gradientCover.hidden = NO;
  //      self.middleLabel.font = [TFStyle fontStyleWSM20];
        
        //self.film = [cellData getSafeFilm];
        self.dailyItem = cellData.dataObject;
        //self.backgroundImage.image = [self.film cachedImage];
    //    self.backgroundImage.image = [self.dailyItem cachedImage];
        [self.imageSpinner stopAnimating];
     //   self.backgroundImage.image = [UIImage imageNamed:@"my_image"]; //[d valueForKey:@"backgroundImage"];
        
        self.pic.image = [self.dailyItem.photos objectAtIndex:0];
        self.pic2.image = [self.dailyItem.photos objectAtIndex:1];
        self.pic3.image = [self.dailyItem.photos objectAtIndex:2];
        
        
        [self.name_age setText:[NSString stringWithFormat:@"%@, %@", self.dailyItem.name, self.dailyItem.age]];
        
        if (self.dailyItem.occupation == nil) {
            if (self.dailyItem.education != nil) {
                [self.edu_job setText:self.dailyItem.education];
            }
        }else{
            [self.edu_job setText:self.dailyItem.occupation];
        }


        
      //  self.bottomView.layer.borderWidth = 1;
     //   self.bottomView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        
      //  self.parentView.layer.borderWidth = 1.5;
      //  self.parentView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        
        
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 3.0;
        self.layer.zPosition = 100;
        
        self.isExpanded = NO;
        

        
        
  //      NSString *top = self.dailyItem.title;//[NSString stringWithFormat:@"%@\n", self.dailyItem.title];//self.film.subtitle;// or whatever
  //      NSString *bottom = self.dailyItem.subtitle;//self.film.title;
        
        
       // TFDebugLog(@"   id: %@, top=%@  bottom=%@", self.dailyItem.identifier, top, bottom);
        
   /*     NSMutableParagraphStyle *ps = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        ps.lineHeightMultiple = 1;
        ps.alignment = NSTextAlignmentLeft;
        
        NSMutableAttributedString *topAttrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",top] attributes:@{NSFontAttributeName:[TFStyle fontStyleWSM20], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:ps}];
        
        [topAttrib appendAttributedString:[[NSAttributedString alloc] initWithString:bottom attributes:@{NSFontAttributeName:[TFStyle fontStyleWSR14], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:ps}]];*/

   //     self.middleLabel.attributedText = [NSAttributedString tfDailyTextWithTitle:top subtitle:bottom];//topAttrib;
        
        /*
        if ([self.dailyItem hasImage])
        {
            if ([self.dailyItem isWaitingForImage])
            {
                //[self.imageSpinner startAnimating];
               // self.backgroundImage.image = nil;
            }
            else
            {
                //[self.imageSpinner stopAnimating];
            }
        }
        else
        {
            //[self.imageSpinner stopAnimating];
            //self.backgroundImage.image = nil;
        } */
        
     
    }
    else
        if (cellData.cellType == TFCT_Daily_Quote_CC)
    {
        self.hidden = YES;
        self.gradientCover.hidden = YES;
   //     self.middleLabel.font = [TFStyle fontStyleWSM20];
   //     self.authorLabel.font = [TFStyle fontStyleWSR10];
        
     //   self.authorLabel.hidden = NO;
        
        
  //      NSString *origQuote = [d uuSafeGetString:@"quote"];
        
        
  //      NSString *str = [NSString stringWithFormat:@"\"%@\"", origQuote];//[d uuSafeGetString:@"quote"];
        
        
        
        
        
        
        /*
        NSMutableAttributedString *topAttrib = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[TFStyle fontStyleWSM20], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:ps}];
        */
        
     //   self.middleLabel.attributedText = topAttrib;
     //   self.backgroundImage.image = [UIImage imageNamed:@"my_image"]; //[d valueForKey:@"backgroundImage"];
        [self.imageSpinner stopAnimating];
    }
}



-(void)initScrollView{
    
   // self.scroll_content_height = self.view.frame.size.height - self.view_height.constant;
    
    self.pageControl.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    
 //   self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    
    self.scrollView.backgroundColor = [UIColor whiteColor];

    [self.scrollView setExclusiveTouch:NO];
    
    //   CGFloat contentHeightModifier = 0.0;
    int surplus = 5 * 2;
    self.height = (self.frame.size.height * 3);
    //self.bounds.size.height * 3;
    self.width = self.bounds.size.width;
    
    
 //   self.scrollView.userInteractionEnabled = NO;
 //   [self addGestureRecognizer:self.scrollView.panGestureRecognizer];
    
//    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayButtonPressed)];
//    [self.scrollView addGestureRecognizer:self.tapGesture];

    
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.height]];
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.width]];
    
       self.scrollView.contentInset = UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
    //   self.scrollView.contentSize = CGSizeMake(cRect.origin.x, self.gradient_height.constant);
    //   self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width, 0);
    
    [self addPhoto];
    [self addPhoto2];
    [self addPhoto3];
    
    self.page_control.transform = CGAffineTransformMakeRotation(M_PI_2);
    
}



-(void)addPhoto{
    
    self.pic = [[UIImageView alloc]init];
    
    self.pic.backgroundColor = [UIColor blueColor];
    self.pic.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic invalidateIntrinsicContentSize];
    self.pic.contentMode = UIViewContentModeScaleToFill;
    
  //  self.pic.image = [UIImage imageNamed:@"my_image"];
    
    
    
    [self.tempView addSubview:self.pic];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.frame.size.height];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.width];
    [self.tempView addConstraint:constraint4];
    
}


-(void)addPhoto2{
    
    self.pic2 = [[UIImageView alloc]init];
    
    self.pic2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic2 invalidateIntrinsicContentSize];
    
 //   self.pic2.image = [UIImage imageNamed:@"my_image"];
    
    self.pic2.alpha = 2.0;
    
    
    
    [self.tempView addSubview:self.pic2];
    
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic2, @"pic1":self.pic};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[pic1]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.frame.size.height];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.width];
    [self.tempView addConstraint:constraint4];
    
}

-(void)addPhoto3{
    
    self.pic3 = [[UIImageView alloc]init];
    
    self.pic3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic3 invalidateIntrinsicContentSize];
    
  //  self.pic3.image = [UIImage imageNamed:@"my_image"];
    
    
    
    
    [self.tempView addSubview:self.pic3];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic3, @"pic2":self.pic2};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[pic2]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.frame.size.height];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.width];
    [self.tempView addConstraint:constraint4];
    
}







-(void)overlayButtonPressed{
  //  if (CGRectContainsPoint(self.overlay.frame, [self.tapGesture locationOfTouch:0 inView:self.scrollView])) {
        [self.overlay sendActionsForControlEvents:UIControlEventTouchUpInside];
  //  }

}





- (void) prepareForReuse
{
    [super prepareForReuse];
    
  //  self.backgroundImage.image = nil;
    
    self.dailyItem = nil;
}

-(void)showHeart{
    [[TFHeartAnimationView sharedInstance] showWithAnchorPoint:[self convertPoint:self.heart.center toView:nil] completion:^(void)
     {
     }];
    [self.heart setHidden:NO];
}


- (void)expandView:(UITapGestureRecognizer *)recognizer {

    if (!self.isExpanded) {
        [self.bottomScrollView setScrollEnabled:YES];
        float height = self.bottomView.frame.size.height * 2.5;
        self.bottomViewHeight.constant = height;
        self.fadeBottomHeight.constant = height;
        [self.edu_job setHidden:NO];
        [self.edu_label setHidden:NO];
        self.isExpanded = YES;
    }else{
        [self retractView];
    }


}

-(void)retractView{
    self.bottomScrollView.contentOffset = CGPointMake(0,0);
    [self.bottomScrollView setScrollEnabled:NO];
    float height = self.bottomView.frame.size.height / 2.5;
    self.bottomViewHeight.constant = height;
    self.fadeBottomHeight.constant = height;
    [self.edu_label setHidden:YES];
    [self.edu_job setHidden:YES];
    self.isExpanded = NO;
}


@end
