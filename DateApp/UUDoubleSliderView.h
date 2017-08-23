//
//  UUDoubleSliderView.h
//  DateApp
//
//  Created by Neil Ballard on 7/11/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UUDoubleSliderView;

@protocol UUDoubleSliderViewDelegate <NSObject>
@optional
- (void) minSliderValuesChanged:(UUDoubleSliderView*)slider value:(float)value;
- (void) maxSliderValuesChanged:(UUDoubleSliderView*)slider value:(float)value;
@end

IB_DESIGNABLE
// UUDoubleSliderView supports layout and preview in Interface Builder. You can create it by hand with
//		initWithFrame, but it's much easier to do it in IB.
//		The only thing not supported directly in IB is setting the delegate which currently isn't supported
//		by Xcode. Perhaps in the future that will, but for now, make sure you set the delegate.
@interface UUDoubleSliderView : UIView

- (id) initWithFrame:(CGRect)frame sliderColor:(UIColor*)sliderColor
     backgroundColor:(UIColor*)backgroundColor
          leftSlider:(UIImage*)leftSlider
         rightSlider:(UIImage*)rightSlider;

// Default values are 0.0 and 100.0
@property (nonatomic, assign) IBInspectable float minimumValue;
@property (nonatomic, assign) IBInspectable float maximumValue;
@property (nonatomic, assign) IBInspectable float minimumSliderValue;
@property (nonatomic, assign) IBInspectable float maximumSliderValue;

//Customization of the slider bar
@property (nonatomic, assign) IBInspectable float sliderHeight;
@property (nonatomic, assign) IBInspectable UIColor* sliderColor;
@property (nonatomic, assign) IBInspectable UIColor* sliderBackgroundColor;
@property (nonatomic, assign) IBInspectable UIImage* leftSliderImage;
@property (nonatomic, assign) IBInspectable UIImage* rightSliderImage;


// Delegate for slider notifications
@property (nonatomic, assign) IBOutlet NSObject<UUDoubleSliderViewDelegate>* delegate;

@end
