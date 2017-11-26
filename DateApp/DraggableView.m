//
//  DraggableView.m
//  portal
//
//  Created by Neil Ballard on 10/9/15.
//  Copyright © 2015 Neil_appworld. All rights reserved.
//

 //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
#define ACTION_MARGIN 120
#define SCALE_STRENGTH 4 //%%% how quickly the card shrinks. Higher = slower shrinking
#define SCALE_MAX .93 //%%% upper bar for how much the card shrinks. Higher = shrinks less
#define ROTATION_MAX 1 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
#define ROTATION_STRENGTH 350 //%%% strength of rotation. Higher = weaker rotation
#define ROTATION_ANGLE M_PI/8 //%%% Higher = stronger rotation angle


#import "DraggableView.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation DraggableView {
    CGRect _frame;
    CGFloat xFromCenter;
    CGFloat yFromCenter;
    UIColor *blueColor;
}

//delegate is instance of ViewController
@synthesize delegate;


@synthesize panGestureRecognizer;
@synthesize pickbackground;
@synthesize overlayView;

- (void) awakeFromNib
{
    [super awakeFromNib];
    if (![[DataAccess singletonInstance] UserHasMatch])
    {
        
    }
    else
    {
        [self.blurView setHidden:NO];
    }
    
}

- (id)initWithUser:(User*)user viewFrame:(CGRect)frame{
    
    if ((self = [super initWithFrame:frame])) {
        self = [self initializeSubviews];
        self.user = user;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        [self setupView];
        
        
    
        
        // self.backgroundColor = [UIColor clearColor];
        
        
        panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
        
        [self addGestureRecognizer:panGestureRecognizer];
        
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processSingleTap:)];
        [self addGestureRecognizer:tapGesture2];
        
        
        [self addPhoto];
        
        
        UIColor *black = [UIColor blackColor];
        UIColor *white = [UIColor blackColor];
        
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bottomView.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)([white colorWithAlphaComponent:0.0].CGColor),(id)([black colorWithAlphaComponent:0.4].CGColor),(id)([white colorWithAlphaComponent:0.7].CGColor),nil];
        gradient.startPoint = CGPointMake(0.25,0.0);
        gradient.endPoint = CGPointMake(0.25,1.0);
        [self.bottomView.layer insertSublayer:gradient atIndex:0];
        
        overlayView = [[OverlayView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-100, 0, 100, 100)];
        overlayView.alpha = 0;
        [self addSubview:overlayView];
        
        self.bottomScrollView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.bottomScrollView.layer.borderWidth = 0.25;
        
    
    }
    
    return self;

}


-(instancetype)initializeSubviews {
    id view =   [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    return view;
}

-(void)setupView
{
    self.layer.cornerRadius =10;
    self.layer.shadowRadius = 10;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(4, 4);
    self.layer.masksToBounds = YES;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shouldRasterize = YES;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandView:)];

    
    [self.bottomView  addGestureRecognizer:tapGesture];
    [self.bottomScrollView setExclusiveTouch:NO];
    self.bottomScrollView.userInteractionEnabled = NO;
    
    NSString *name = [NSString stringWithFormat:@"%@, %@", self.user.name, self.user.age];
    self.name_age.text = name;
    [self.name_age.layer setShouldRasterize:YES];
    
    if (![self.user.edu isEqualToString:@""] && self.user.edu != nil) {
        self.edu.text = self.user.edu;
        [self.edu.layer setShouldRasterize:YES];
    }else{
        [self.edu setHidden:YES];
    }
    
    if (![self.user.job isEqualToString:@""] && self.user.job != nil) {
        self.job.text = self.user.job;
        [self.job.layer setShouldRasterize:YES];

    }else{
        [self.job setHidden:YES];
    }
}


-(void)setAttrHeader{
    UIFont *boldFont = [UIFont fontWithName:@"AvenirNext-Medium" size:self.name_age.font.pointSize];
    UIFont *regularFont = [UIFont fontWithName:@"AvenirNext-Regular" size:self.name_age.font.pointSize];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    
    NSString *name = [NSString stringWithFormat:@"%@, ", self.user.name];
    
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName: boldFont}]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:self.user.age attributes:@{NSFontAttributeName: regularFont}]];
    self.name_age.attributedText = attrString;
}


-(void)addPhoto{
    
   // self.pic = [[UIImageView alloc]init];
    
   // self.pic.backgroundColor = [UIColor whiteColor];
    
    self.pic.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    

    self.pic.contentMode = UIViewContentModeScaleAspectFill;
    self.pic.clipsToBounds = YES;
    
    
    
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:0]]
                placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                         options:SDWebImageRefreshCached];
  
    
    
    

    
    
    
    /*
    NSDictionary *viewsDictionary = @{@"image":self.pic};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[image]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:0]} views:viewsDictionary];
    [self addConstraints:constraint1];
    [self addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.height];
    [self addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.pic attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.width];
    [self addConstraint:constraint4]; */
    
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
        if ([[DataAccess singletonInstance] UserHasMatch])
        {
            id<HasMatchDelegate> strongDelegate = self.noswipe_delegate;
            [strongDelegate noSwipingAlert];
            [self resetCard];
        }
        else
        {
            [self rightAction];
        }
    }
    else if (xFromCenter < -ACTION_MARGIN)
    {
        [self leftAction];
    }
    else
    { //%%% resets the card
        [self resetCard];
    }
}

-(void)resetCard
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = self.originalPoint;
                         self.transform = CGAffineTransformMakeRotation(0);
                         overlayView.alpha = 0;
                     }];
}


//%%% called when a swipe exceeds the ACTION_MARGIN to the right
-(void)rightAction
{
    
    CGPoint finishPoint = CGPointMake(500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self cardResult:1];
                         [self removeFromSuperview];
                     }];
    
    
    
    [delegate cardSwipedRight:self];
    
}

//%%% called when a swip exceeds the ACTION_MARGIN to the left
-(void)leftAction
{
    CGPoint finishPoint = CGPointMake(-500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self cardResult:0];
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self];
    
}


-(void)cardResult:(int)result
{
    
    NSString *uid = [NSString stringWithFormat:@"%ld", (long)self.user.user_id];
    [DAServer swipe:uid liked:result completion:^(NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {
            
        } else {
            // update UI to indicate error or take remedial action
        }
    }];
}


-(void)rightClickAction
{
    CGPoint finishPoint = CGPointMake(600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(1);
                     }completion:^(BOOL complete){
                         [self cardResult:1];
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self];
    
}

-(void)leftClickAction
{
    CGPoint finishPoint = CGPointMake(-600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-1);
                     }completion:^(BOOL complete){
                         [self cardResult:0];
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self];
    
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

    id<ProfileProtocol> strongDelegate = self.profile_delegate;
    [strongDelegate profileSelected:self.user];
    
}



-(void)updateMatch
{
    [self.blurView setHidden:NO];
    [self.lock setHidden:NO];
    [self.matchedLabel setHidden:NO];
    [self.matchedSubLabel setHidden:NO];
}

-(void)updateUnmatch
{
    [self.blurView setHidden:YES];
    [self.lock setHidden:YES];
    [self.matchedLabel setHidden:YES];
    [self.matchedSubLabel setHidden:YES];

}







@end
