//
//  BalloonAnimation.h
//  DateApp
//
//  Created by Neil Ballard on 1/7/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalloonAnimation : UIView
+ (instancetype) sharedInstance;
- (void) showWithAnchorPoint:(CGPoint)anchorPoint view:(UIView*)balloonView completion:(void(^)())completionHandler;
@end