//
//  DAGradientColor.m
//  DateApp
//
//  Created by Neil Ballard on 6/27/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "DAGradientColor.h"

@implementation DAGradientColor

+ (UIColor*) gradientFromColor:(int)width
{
    
    UIColor *color1 = [UIColor colorWithRed:0.98 green:0.78 blue:0.60 alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:0.84 green:0.24 blue:0.41 alpha:1.0];
    
    CGSize size = CGSizeMake(width, 1);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray* colors = [NSArray arrayWithObjects:(id)color1.CGColor, (id)color2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, NULL);
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(size.width, 0), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

@end
