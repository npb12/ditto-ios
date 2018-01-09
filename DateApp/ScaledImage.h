//
//  ScaledImage.h
//  DateApp
//
//  Created by Neil Ballard on 12/15/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaledImage : UIImage
+ (UIImage *)imageByScalingProportionallyToSize:(UIImage*)sourceImage size:(CGSize)targetSize;
@end
