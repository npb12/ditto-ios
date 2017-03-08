//
//  DistanceRangeSlider.h
//  pairedUP
//
//  Created by Neil Ballard on 2/3/16.
//  Copyright © 2016 Neil_appworld. All rights reserved.
//

#import "CERangeSlider.h"
#import "CERangeSliderKnobLayer.h"

@interface DistanceRangeSlider : CERangeSlider


- (float) positionForValue:(float)value;

@end
