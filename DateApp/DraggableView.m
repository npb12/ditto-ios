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
    BOOL isPressed;
    BOOL shouldAllowPan;
}

//delegate is instance of ViewController
@synthesize delegate;


@synthesize panGestureRecognizer;
@synthesize pickbackground;
@synthesize overlayView;

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setHidden:YES];
}

- (id)initWithUser:(User*)user viewFrame:(CGRect)frame{
    
    if ((self = [super initWithFrame:frame])) {
        self = [self initializeSubviews];
        self.user = user;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        [self setupView];
        
        
        // self.backgroundColor = [UIColor clearColor];
        
        
        panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];
        
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processSingleTap:)];
        [self addGestureRecognizer:tapGesture2];
        
        
        
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
        
        
        
        if (![[DataAccess singletonInstance] UserHasMatch])
        {
            [self updateUnmatch];
        }
        else
        {
            [self updateMatch];
        }
        
        
    }
    
    return self;
    
}


-(instancetype)initializeSubviews {
    id view =   [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    return view;
}

-(void)setupView
{
    [self profilePicFrame];
    
    
    self.matchedSubLabel.text = @"Unmatch with your current\nmatch to discover more people";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandView:)];
    
    
    [self.bottomView  addGestureRecognizer:tapGesture];
    
    [self configureLongPress];
    
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


-(void)profilePicFrame
{
    
    [self layoutIfNeeded];
    
    self.pic.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.pic.contentMode = UIViewContentModeScaleAspectFill;
    //self.pic.backgroundColor = [UIColor blackColor];
    /*
     [self.pic sd_setImageWithURL:[NSURL URLWithString:[self.user.pics objectAtIndex:0]]
     placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
     options:SDWebImageRefreshCached]; */
    NSURL *url = [NSURL URLWithString:[self.user.pics objectAtIndex:0]];
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    [manager downloadImageWithURL:url
                          options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {  } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished && !error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.user.profileImage = image;
                 CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
                 UIImage *resizedImage =  [image scaleImageToSize:size];
                 [self.pic setImage:resizedImage];
                 [self setHidden:NO];
             });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self setHidden:NO];
             });
         }
     }];
    /*
    self.avatarImageViewHolder = [[UIView alloc] initWithFrame:self.pic.frame];
    self.avatarImageViewHolder.backgroundColor = [UIColor clearColor];
    [self.pic.superview addSubview:self.avatarImageViewHolder];
    [self.avatarImageViewHolder addSubview:self.pic];
    self.pic.center = CGPointMake(self.avatarImageViewHolder.frame.size.width/2.0f, self.avatarImageViewHolder.frame.size.height/2.0f);
    
    
    self.avatarImageViewHolder.layer.masksToBounds = NO; */
    
    
    // set avatar image corner
    self.pic.layer.cornerRadius = 14;
    self.pic.layer.masksToBounds = YES;

    
    [self setFrameShadow];
    
    [self.pic layoutIfNeeded];
    
    /*
    UIImageView *gradient = [[UIImageView alloc] initWithFrame:self.pic.frame];
    [self.pic addSubview:gradient];
    gradient.center = CGPointMake(self.pic.frame.size.width/2.0f, self.pic.frame.size.height/2.0f);
    [gradient setImage:[UIImage imageNamed:@"Gradient_BG"]];
    gradient.contentMode = UIViewContentModeScaleAspectFill;
    gradient.layer.masksToBounds = YES;
    [gradient setAlpha:0.0]; */
    
    /*
     UIVisualEffect *blurEffect;
     blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
     
     self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
     
     self.blurView.frame = self.bounds;
     [self.pic addSubview:self.blurView];
     self.blurView.center = CGPointMake(self.pic.frame.size.width/2.0f, self.pic.frame.size.height/2.0f); */
    
    [self.pic addSubview:self.blurView];
    [self.pic addSubview:self.bottomView];
    
}


-(void)setFrameShadow
{
    /*
    self.avatarImageViewHolder.layer.shadowRadius = 2;
    [self.avatarImageViewHolder.layer setShadowOffset:CGSizeMake(-2, 2)];
    [self.avatarImageViewHolder.layer setShadowOpacity:0.8];
    [self.avatarImageViewHolder.layer setShadowColor:[self shadowColor].CGColor];
    self.avatarImageViewHolder.clipsToBounds = NO;
     
     let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)

     shadowView.layer.shadowRadius = 8.0
     shadowView.layer.shadowColor = UIColor.black.cgColor
     shadowView.layer.shadowOffset = CGSize(width: width, height: height)
     shadowView.layer.shadowOpacity = 0.35
     shadowView.layer.shadowPath = shadowPath.cgPath
     */
    /*
    self.avatarImageViewHolder.layer.shadowRadius = 8;
    [self.avatarImageViewHolder.layer setShadowOffset:CGSizeMake(-2, 2)];
    [self.avatarImageViewHolder.layer setShadowOpacity:0.8];
    [self.avatarImageViewHolder.layer setShadowColor:[self shadowColor].CGColor];
    self.avatarImageViewHolder.clipsToBounds = NO;
     
     
     self.shadowView?.removeFromSuperview()
     let shadowView = UIView(frame: CGRect(x: BaseRoundedCardCell.kInnerMargin,
     y: BaseRoundedCardCell.kInnerMargin,
     width: bounds.width - (2 * BaseRoundedCardCell.kInnerMargin),
     height: bounds.height - (2 * BaseRoundedCardCell.kInnerMargin)))
     insertSubview(shadowView, at: 0)
     self.shadowView = shadowView
     
     let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)
     shadowView.layer.masksToBounds = false
     shadowView.layer.shadowRadius = 8.0
     shadowView.layer.shadowColor = UIColor.black.cgColor
     shadowView.layer.shadowOffset = CGSize(width: width, height: height)
     shadowView.layer.shadowOpacity = 0.35
     shadowView.layer.shadowPath = shadowPath.cgPath
     */
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.x, self.bounds.size.width - (2 * self.bounds.origin.x), self.bounds.size.height - (2 * self.bounds.origin.y))];
    [self insertSubview:shadowView atIndex:0];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:shadowView.bounds cornerRadius:14.0];
    shadowView.layer.masksToBounds = NO;
    shadowView.layer.shadowRadius = 12.0;
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    [shadowView.layer setShadowOffset:CGSizeMake(-1, 1)];
    [shadowView.layer setShadowOpacity:0.08];
    shadowView.layer.shadowPath = shadowPath.CGPath;
    
}

-(void)unsetFrameShadow
{
    self.avatarImageViewHolder.layer.shadowRadius = 0;
    [self.avatarImageViewHolder.layer setShadowOffset:CGSizeZero];
    [self.avatarImageViewHolder.layer setShadowOpacity:0];
    [self.avatarImageViewHolder.layer setShadowColor:[UIColor clearColor].CGColor];
    self.avatarImageViewHolder.clipsToBounds = NO;
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
    [UIView animateWithDuration:0.1
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
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self cardResult:YES];
                         [self removeFromSuperview];
                         id<NextCardProtocol> strongDelegate = self.nextCardDelegate;
                         [strongDelegate nextCardAction];
                     }];
    
    
    
    [delegate cardSwipedRight:self];
    
}

//%%% called when a swip exceeds the ACTION_MARGIN to the left
-(void)leftAction
{
    CGPoint finishPoint = CGPointMake(-500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self cardResult:NO];
                         [self removeFromSuperview];
                         id<NextCardProtocol> strongDelegate = self.nextCardDelegate;
                         [strongDelegate nextCardAction];
                     }];
    
    [delegate cardSwipedLeft:self];
    
}


-(void)cardResult:(int)result
{
    
    NSString *uid = [NSString stringWithFormat:@"%ld", (long)self.user.user_id];
    [DAServer swipe:uid liked:result completion:^(NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error)
        {
            
        }
        else
        {
            // update UI to indicate error or take remedial action
        }
        [delegate checkEmpty];
        
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
                         [self cardResult:YES];
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
                         [self cardResult:NO];
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
    [self goToProfile];
}

-(void)goToProfile
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
    [self.bottomView setHidden:YES];
    [self unsetFrameShadow];
}

-(void)updateUnmatch
{
    [self.blurView setHidden:YES];
    [self.lock setHidden:YES];
    [self.matchedLabel setHidden:YES];
    [self.matchedSubLabel setHidden:YES];
    [self.bottomView setHidden:NO];
    [self setFrameShadow];
}


-(void)removeBlur
{
    [self.blurView setHidden:YES];
}

-(void)showBlur
{
    [self.blurView setHidden:NO];
}



-(UIColor*)shadowColor
{
    return [[UIColor blackColor] colorWithAlphaComponent:0.3];
}


#pragma long press gesture recognizer

-(void)configureLongPress
{
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    press.minimumPressDuration = 0.1;
    [self addGestureRecognizer:press];
}

-(void)handleLongPressGesture:(UILongPressGestureRecognizer*)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [self handleLongPressBegan];
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateCancelled ||
            gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self handleLongPressEnded];
    }
  
}


-(void)handleLongPressBegan
{
    if (isPressed)
    {
        return;
    }
    
    isPressed = true;
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{self.transform = CGAffineTransformMakeScale(0.95, 0.95);} completion:nil];
}

-(void)handleLongPressEnded
{
    if (!isPressed)
    {
        return;
    }
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:0.2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{self.transform = CGAffineTransformIdentity;} completion:^(BOOL finished)
     {
         isPressed = false;
     }];
    
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
