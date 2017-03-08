//
//  DraggableView.m
//  portal
//
//  Created by Neil Ballard on 10/9/15.
//  Copyright © 2015 Neil_appworld. All rights reserved.
//

#define ACTION_MARGIN 120 //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
#define SCALE_STRENGTH 4 //%%% how quickly the card shrinks. Higher = slower shrinking
#define SCALE_MAX .93 //%%% upper bar for how much the card shrinks. Higher = shrinks less
#define ROTATION_MAX 1 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
#define ROTATION_STRENGTH 350 //%%% strength of rotation. Higher = weaker rotation
#define ROTATION_ANGLE M_PI/8 //%%% Higher = stronger rotation angle


#import "DraggableView.h"

@implementation DraggableView {
    CGRect _frame;
    CGFloat xFromCenter;
    CGFloat yFromCenter;
}

//delegate is instance of ViewController
@synthesize delegate;


@synthesize panGestureRecognizer;
@synthesize pickbackground;
@synthesize overlayView;

- (void) awakeFromNib
{
    [super awakeFromNib];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [self initializeSubviews];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        [self setupView];
        

        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)([UIColor colorWithRed:0.29 green:0.34 blue:0.86 alpha:1.0].CGColor),(id)([UIColor colorWithRed:0.01 green:0.68 blue:0.80 alpha:1.0].CGColor),nil];
        gradient.startPoint = CGPointMake(0.25,0.0);
        gradient.endPoint = CGPointMake(0.25,1.0);
        [self.layer insertSublayer:gradient atIndex:0];

       // self.backgroundColor = [UIColor clearColor];

        
        panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
        
        [self addGestureRecognizer:panGestureRecognizer];
        

        

        

        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processSingleTap:)];
        [self.scrollView addGestureRecognizer:tapGesture2];
        
        self.scrollView.delegate = self;
        
        [self initScrollView];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.layer.cornerRadius = 15;
      //  self.layer.borderColor = [UIColor whiteColor].CGColor;
      //  self.layer.borderWidth = 3;
        
        overlayView = [[OverlayView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-100, 0, 100, 100)];
        overlayView.alpha = 0;
        [self addSubview:overlayView];
    }
    return self;
}

-(instancetype)initializeSubviews {
    id view =   [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    return view;
}

-(void)setupView
{
    self.layer.cornerRadius =15;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.masksToBounds = YES;

    
    self.pageControl.frame = CGRectMake(self.frame.size.width - 40, 15, 39, 37);
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandView:)];

    
    [self.bottomView  addGestureRecognizer:tapGesture];
    [self.bottomScrollView setExclusiveTouch:NO];
    self.bottomScrollView.userInteractionEnabled = NO;
}



-(void)initScrollView{
    
    // self.scroll_content_height = self.view.frame.size.height - self.view_height.constant;
    
    self.pageControl.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    
    self.scrollView.frame = CGRectMake(3, 3, self.frame.size.width - 6, self.frame.size.height - 6);
    
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
    
    
    [self.scrollView setExclusiveTouch:NO];
    
    self.height = (self.frame.size.height * 3) - (6 * 3); //- contentHeightModifier;
    //self.bounds.size.height * 3;
    self.width = self.frame.size.width - 6;
    
    
    //   self.scrollView.userInteractionEnabled = NO;
    //   [self addGestureRecognizer:self.scrollView.panGestureRecognizer];
    
    //    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayButtonPressed)];
    //    [self.scrollView addGestureRecognizer:self.tapGesture];
    
    
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.height]];
    
    [self.tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.width]];
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
    
    [self addPhoto];
    [self addPhoto2];
    [self addPhoto3];
    
   // [self setAttrHeader];
    
   // self.pageControl.transform = CGAffineTransformMakeRotation(M_PI_2);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    

    if (scrollView == self.scrollView) {
        
        CGFloat pageHeight = self.frame.size.height;
        int page = floor((self.scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
        [self.pageControl setCurrentPage:page];
        
    }
    
    
}


-(void)setAttrHeader{
    UIFont *boldFont = [UIFont fontWithName:@"AvenirNext-Medium" size:self.name_age.font.pointSize];
    UIFont *regularFont = [UIFont fontWithName:@"AvenirNext-Regular" size:self.name_age.font.pointSize];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Neil, " attributes:@{NSFontAttributeName: boldFont}]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"25" attributes:@{NSFontAttributeName: regularFont}]];
    self.name_age.attributedText = attrString;
}


-(void)addPhoto{
    
    self.pic = [[UIImageView alloc]init];
    
    self.pic.backgroundColor = [UIColor blueColor];
    self.pic.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic invalidateIntrinsicContentSize];
    self.pic.contentMode = UIViewContentModeScaleAspectFill;
    self.pic.image = [UIImage imageNamed:@"girl1"];
    self.pic.clipsToBounds = YES;
    
    
    
    [self.tempView addSubview:self.pic];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.height / 3];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.width];
    [self.tempView addConstraint:constraint4];
    
}


-(void)addPhoto2{
    
    self.pic2 = [[UIImageView alloc]init];
    
    self.pic2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic2 invalidateIntrinsicContentSize];
    
    self.pic2.image = [UIImage imageNamed:@"photo3"];
    self.pic2.contentMode = UIViewContentModeScaleAspectFill;
    self.pic2.alpha = 2.0;
    self.pic2.clipsToBounds = YES;
    
    
    
    [self.tempView addSubview:self.pic2];
    
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic2, @"pic1":self.pic};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[pic1]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.height / 3 ];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.width];
    [self.tempView addConstraint:constraint4];
    
}

-(void)addPhoto3{
    
    self.pic3 = [[UIImageView alloc]init];
    
    self.pic3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pic3 invalidateIntrinsicContentSize];
    
    self.pic3.image = [UIImage imageNamed:@"photo3"];
    self.pic3.clipsToBounds = YES;
    self.pic3.contentMode = UIViewContentModeScaleAspectFill;

    
    
    
    [self.tempView addSubview:self.pic3];
    
    
    
    NSDictionary *viewsDictionary = @{@"image":self.pic3, @"pic2":self.pic2};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[pic2]-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self.tempView addConstraints:constraint1];
    [self.tempView addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.height / 3 ];
    [self.tempView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.width];
    [self.tempView addConstraint:constraint4];
    
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//%%% called when you move your finger across the screen.
// called many times a second
-(void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    //%%% this extracts the coordinate data from your swipe movement. (i.e. How much did you move?)
    xFromCenter = [gestureRecognizer translationInView:self].x; //%%% positive for right swipe, negative for left
    yFromCenter = [gestureRecognizer translationInView:self].y; //%%% positive for up, negative for down
    
    //%%% checks what state the gesture is in. (are you just starting, letting go, or in the middle of a swipe?)
    switch (gestureRecognizer.state) {
            //%%% just started swiping
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        };
            //%%% in the middle of a swipe
        case UIGestureRecognizerStateChanged:{
            //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            CGFloat rotationStrength = MIN(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
            
            //%%% degree change in radians
            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            
            //%%% amount the height changes when you move the card up to a certain point
            CGFloat scale = MAX(1 - fabs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            
            //%%% move the object's center by center + gesture coordinate
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter);
            
            //%%% rotate by certain amount
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            
            
            //%%% scale by certain amount
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            
            //%%% apply transformations
            self.transform = scaleTransform;
            [self updateOverlay:xFromCenter];
            
            break;
        };
            //%%% let go of the card
        case UIGestureRecognizerStateEnded: {
            [self afterSwipeAction];
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

//%%% checks to see if you are moving right or left and applies the correct overlay image
-(void)updateOverlay:(CGFloat)distance
{
    if (distance > 0) {
        overlayView.mode = GGOverlayViewModeRight;
    } else {
        overlayView.mode = GGOverlayViewModeLeft;
    }
    
    overlayView.alpha = MIN(fabs(distance)/100, 0.4);
}

//%%% called when the card is let go
- (void)afterSwipeAction
{
    if (xFromCenter > ACTION_MARGIN) {
        [self rightAction];
    } else if (xFromCenter < -ACTION_MARGIN) {
        [self leftAction];
    } else { //%%% resets the card
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.center = self.originalPoint;
                             self.transform = CGAffineTransformMakeRotation(0);
                             overlayView.alpha = 0;
                         }];
    }
}

//%%% called when a swipe exceeds the ACTION_MARGIN to the right
-(void)rightAction
{
    CGPoint finishPoint = CGPointMake(500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self];
    
    NSLog(@"YES");
}

//%%% called when a swip exceeds the ACTION_MARGIN to the left
-(void)leftAction
{
    CGPoint finishPoint = CGPointMake(-500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self];
    
    NSLog(@"NO");
}




//UI Colors

-(UIColor*)grayColor{
    
    return [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
}

-(UIColor*)titleColor{
    
    return [UIColor colorWithRed:0.20 green:0.80 blue:1.00 alpha:1.0];
}


-(UIColor*)backgroundColor{
    
    return [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
    
    
}

//

-(UIColor*)lineColor{
    
    return [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];
    
    
}

- (void)goThere:(id)sender {
        
    NSNotification* notification = [NSNotification notificationWithName:@"pushDetailView" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    /*
    NSNumber *indexPathRow = [NSNumber numberWithInt: indexPath.row];
    NSNotification* notification = [NSNotification notificationWithName:@"pushDetailView" indexPathRow object:indexPathRow];
    [[NSNotificationCenter defaultCenter] postNotification:notification]; */

}

- (void) processSingleTap:(UITapGestureRecognizer *)sender
{

            
            if (self.isExpanded) {
                [self retractView];
            }else{
               // id<ProfileSegueProtocol> strongDelegate = self.delegate;
               // [strongDelegate goToProfileSegue:self obj:cell.dailyItem];
            }
    
}


- (void)expandView:(UITapGestureRecognizer *)recognizer {
    
    if (!self.isExpanded) {
        [self.bottomScrollView setScrollEnabled:YES];
        float height = self.bottomView.frame.size.height * 2.5;
        self.bottomViewHeight.constant = height;
        self.fadeBottom_height.constant = height;
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
    self.fadeBottom_height.constant = height;
    [self.edu_label setHidden:YES];
  //  [self.edu_job setHidden:YES];
    self.isExpanded = NO;
}






@end
