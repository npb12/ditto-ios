//
//  CERangeSliderKnobLayer.h
//  pairedUP
//
//  Created by Neil Ballard on 2/2/16.
//  Copyright © 2016 Neil_appworld. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class CERangeSlider;


@interface CERangeSliderKnobLayer : CALayer

@property BOOL highlighted;
@property (weak) CERangeSlider* slider;

@end
