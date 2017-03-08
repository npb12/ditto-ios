//
//  TFStyle.h
//  TIFF
//
//  Created by Rhonda DeVore on 4/12/16.
//  Copyright © 2016 Silverpine Software. All rights reserved.
//

#import "Includes.h"

@interface TFStyle : NSObject

+ (UIColor*) colorWhite;
+ (UIColor*) colorBlack;
+ (UIColor*) colorLightGray;
+ (UIColor*) colorDarkGray;
+ (UIColor*) colorOrange;

+ (UIFont*) fontStyleWSM22;
+ (UIFont*) fontStyleWSM20;
+ (UIFont*) fontStyleWSM18;
+ (UIFont*) fontStyleWSM16;
+ (UIFont*) fontStyleWSM14;
+ (UIFont*) fontStyleWSM12;
+ (UIFont*) fontStyleWSM36;

+ (UIFont*) fontStyleWSR36;
+ (UIFont*) fontStyleWSR24;
+ (UIFont*) fontStyleWSR22;
+ (UIFont*) fontStyleWSR18;
+ (UIFont*) fontStyleWSR14;
+ (UIFont*) fontStyleWSR12;
+ (UIFont*) fontStyleWSR10;

+ (UIFont*) fontStyleWSB12;



+ (UIColor*) randomDailyColor;
@end
