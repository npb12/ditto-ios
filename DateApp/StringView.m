//
//  StringView.m
//  DateApp
//
//  Created by Neil Ballard on 1/7/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "StringView.h"

@implementation StringView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 100, 100);
    CGContextAddCurveToPoint(context,125,150,175,150,200,100);
    CGContextAddCurveToPoint(context,225,50,275,75,300,200);
    CGContextStrokePath(context);
}



@end
