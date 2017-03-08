//
//  CERangeSlider.h
//  pairedUP
//
//  Created by Neil Ballard on 2/1/16.
//  Copyright © 2016 Neil_appworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERangeSliderKnobLayer.h"

@interface CERangeSlider : UIControl

@property (nonatomic) float maximumValue;

@property (nonatomic) float minimumValue;

@property (nonatomic) float upperValue;

@property (nonatomic) float lowerValue;

@property (nonatomic) float curvatiousness;

@property (nonatomic) UIColor* trackColour;

@property (nonatomic) UIColor* trackHighlightColour;

@property (nonatomic) UIColor* knobColour;

- (float) positionForValue:(float)value;

@end
