//
//  BalloonAnimation.m
//  DateApp
//
//  Created by Neil Ballard on 1/7/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "BalloonAnimation.h"

@interface BalloonAnimation ()

@property (nonatomic, copy) void (^blocksCompletionHandler)(void);

@end

@implementation BalloonAnimation

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
    }
    return self;
}
+ (instancetype) sharedInstance
{
    TFHeartAnimationView *fv = [[[NSBundle mainBundle] loadNibNamed:@"TFHeartAnimationView" owner:nil options:nil] lastObject];
    
    if (![fv isKindOfClass:[TFHeartAnimationView class]])
    {
        return nil;
    }
    
    CGRect windowFrame = [UIScreen mainScreen].bounds;
    fv.frame = windowFrame;
    [fv layoutIfNeeded];
    
    return fv;
}


- (CGFloat) animationDuration
{
    return 6.0;
}

- (CGFloat) verticalStop
{
    return [UIScreen mainScreen].bounds.size.height - 49;
}

- (CGFloat) amplitude
{
    return 20;
}

- (void) showWithAnchorPoint:(CGPoint)anchorPoint completion:(void (^)())completionHandler
{
    self.blocksCompletionHandler = completionHandler;
    
    self.hidden = NO;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    self.fixedHeart.alpha = 0.0f;
    self.heartOne.alpha = 0.0f;
    self.heartTwo.alpha = 0.0f;
    self.heartThree.alpha = 0.0f;
    
    self.fixedHeart.center = anchorPoint;
    self.heartOne.center = anchorPoint;
    self.heartTwo.center = anchorPoint;
    self.heartThree.center = anchorPoint;
    
    //[self setNeedsDisplay];
    self.heartOne.hidden = YES;
    self.heartTwo.hidden = YES;
    self.heartThree.hidden = YES;
    //self.hidden = NO;
    
    
    [UIView animateWithDuration:0.3f animations:^(void)
     {
         //self.fixedHeart.alpha = 1.0f;
         self.heartOne.alpha = 0.75;
         self.heartTwo.alpha = 0.75;
         self.heartThree.alpha = 0.75;
         
     }
                     completion:^(BOOL finished)
     {
         self.heartOne.hidden = NO;
         self.heartTwo.hidden = NO;
         self.heartThree.hidden = NO;
         
         
         //animate along paths
         
         CAKeyframeAnimation *heartOneAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
         heartOneAnim.path = [self makePathFrom:anchorPoint periodLength:100 amplitude:40 reverseCurve:NO].CGPath;
         heartOneAnim.repeatCount = 0;
         heartOneAnim.duration = [self animationDuration];
         
         CAKeyframeAnimation *heartTwoAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
         heartTwoAnim.path = [self makePathFrom:anchorPoint periodLength:50 amplitude:20 reverseCurve:YES].CGPath;
         heartTwoAnim.repeatCount = 0;
         heartTwoAnim.duration = [self animationDuration];
         
         CAKeyframeAnimation *heartThreeAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
         heartThreeAnim.path = [self makePathFrom:anchorPoint periodLength:75 amplitude:30 reverseCurve:NO].CGPath;
         heartThreeAnim.repeatCount = 0;
         heartThreeAnim.duration = [self animationDuration];
         
         [self.heartOne.layer addAnimation:heartOneAnim forKey:@"heartOneAnim"];
         [self.heartTwo.layer addAnimation:heartTwoAnim forKey:@"heartTwoAnim"];
         [self.heartThree.layer addAnimation:heartThreeAnim forKey:@"heartThreeAnim"];
         
         CGFloat ySpaceToTabBar = ([UIScreen mainScreen].bounds.size.height - 22) - anchorPoint.y;
         CGFloat totalVerticalFall = [self endY] - anchorPoint.y;
         CGFloat percentageFall = ySpaceToTabBar/totalVerticalFall;
         
         [self performSelector:@selector(dismiss) withObject:nil afterDelay:([self animationDuration]*percentageFall)];
         
         [UIView animateWithDuration:2.5 animations:^{
             self.heartOne.alpha = 0.0;
             self.heartTwo.alpha = 0.0;
             self.heartThree.alpha = 0.0;
         }];
     }];
    
    
    
    
    
    
}


- (void) dismiss
{
    
    //[(TFAppDelegate*)[UIApplication sharedApplication].delegate triggerFillPlannerTabIconIfNeeded];
    self.hidden = YES;
    [self removeFromSuperview];
    
    if (self.blocksCompletionHandler)
    {
        self.blocksCompletionHandler();
    }
}

- (CGFloat) endY
{
    return [self verticalStop]*2;
}

- (UIBezierPath*) makePathFrom:(CGPoint)start periodLength:(CGFloat)period amplitude:(CGFloat)curveAmp reverseCurve:(BOOL)reverse
{
    CGPoint endPoint = CGPointMake([UIScreen mainScreen].bounds.size.width -44, [self endY]);
    
    
    
    
    CGFloat ampToggle = curveAmp;
    if (reverse)
    {
        ampToggle = -ampToggle;
    }
    
    CGFloat currentControlY = start.y + period;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:start];
    
    CGPoint lastPoint = start;
    CGPoint nextPoint = CGPointMake(start.x, currentControlY);
    
    
    while (currentControlY <= endPoint.y)
    {
        CGPoint control = CGPointMake(start.x + ampToggle, (lastPoint.y+(period/2)));
        [path addQuadCurveToPoint:nextPoint controlPoint:control];
        ampToggle = -ampToggle;
        currentControlY += period;
        lastPoint = nextPoint;
        nextPoint.y = currentControlY;
    }
    
    
    CGPoint control = CGPointMake(start.x + ampToggle, ((lastPoint.y-nextPoint.y)/2));
    [path addQuadCurveToPoint:nextPoint controlPoint:control];
    return path;
}

@end
