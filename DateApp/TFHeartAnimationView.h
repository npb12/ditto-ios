//
//  TFHeartAnimationView.h
//  TIFF
//
//  Created by Rhonda DeVore on 6/15/16.
//  Copyright © 2016 Silverpine Software. All rights reserved.
//

#import "Includes.h"

@interface TFHeartAnimationView : UIView
+ (instancetype) sharedInstance;
- (void) showWithAnchorPoint:(CGPoint)anchorPoint completion:(void(^)())completionHandler;
@end
