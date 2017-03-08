//
//  TFDailyCollectionCell.h
//  TIFF
//
//  Created by Rhonda DeVore on 4/18/16.
//  Copyright © 2016 Silverpine Software. All rights reserved.
//

#import "Includes.h"



@interface TFDailyCollectionCell : UICollectionViewCell <TFCollectionCellFactory>


@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *imageSpinner;
//@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
//@property (strong, nonatomic) IBOutlet UILabel *topLabel;
//@property (strong, nonatomic) IBOutlet UILabel *bottomLabel;
@property (strong, nonatomic) IBOutlet UIView *dimmerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backgroundImageViewLeading;

@property (strong, nonatomic) IBOutlet UILabel *name_age;
@property (strong, nonatomic) IBOutlet UILabel *edu_job;

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *fadeBottom1;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *middleLabelCenterConstraint;

-(void)showHeart;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


@property (strong, nonatomic) IBOutlet UIImageView *pic;
@property (strong, nonatomic) IBOutlet UIImageView *pic2;
@property (strong, nonatomic) IBOutlet UIImageView *pic3;

@property (nonatomic, strong) TFDailyItem *dailyItem;

@property (strong, nonatomic) IBOutlet UIPageControl *page_control;

@property (strong, nonatomic) IBOutlet UIView *parentView;

@property (strong, nonatomic) IBOutlet UIScrollView *bottomScrollView;

@property (strong, nonatomic) IBOutlet UILabel *edu_label;

-(void)retractView;

@property (nonatomic, assign) BOOL isExpanded;


@end




