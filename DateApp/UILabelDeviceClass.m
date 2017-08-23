//
//  UILabelDeviceClass.m
//  DateApp
//
//  Created by Neil Ballard on 7/15/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "UILabelDeviceClass.h"

@implementation UILabelDeviceClass

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews
{
    [self overrideFontSize:self.font.pointSize];
}

-(void)overrideFontSize:(CGFloat)fontsize
{
    NSString *currentFontName = self.font.fontName;
    UIFont *calculatedFont;
    int height = [[UIScreen mainScreen] bounds].size.height;
    
    switch (height)
    {
        case 480:
            calculatedFont = [UIFont fontWithName:currentFontName size:fontsize * 0.7];
            self.font = calculatedFont;
            break;
        case 568:
            calculatedFont = [UIFont fontWithName:currentFontName size:fontsize * 0.8];
            self.font = calculatedFont;
            break;
        case 667:
            calculatedFont = [UIFont fontWithName:currentFontName size:fontsize * 0.9];
            self.font = calculatedFont;
            break;
        case 736:
            calculatedFont = [UIFont fontWithName:currentFontName size:fontsize];
            self.font = calculatedFont;
            break;
        default:
            NSLog(@"Not hotdog");
            break;
    }
}

@end
