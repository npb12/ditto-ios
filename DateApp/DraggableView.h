//
//  DraggableView.h
//  portal
//
//  Created by Neil Ballard on 10/9/15.
//  Copyright © 2015 Neil_appworld. All rights reserved.


/*
 
 Copyright (c) 2014 Choong-Won Richard Kim <cwrichardkim@gmail.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import <UIKit/UIKit.h>
#import "OverlayView.h"
#import "DataAccess.h"


@protocol DraggableViewDelegate <NSObject>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;


@end

@interface DraggableView : UIView<UIScrollViewDelegate>

@property (weak) id <DraggableViewDelegate> delegate;



@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic)CGPoint originalPoint;
@property (nonatomic,strong)OverlayView* overlayView;


@property (strong, nonatomic) IBOutlet UIImageView *pic;
@property (strong, nonatomic) IBOutlet UIImageView *pic2;
@property (strong, nonatomic) IBOutlet UIImageView *pic3;
@property (strong, nonatomic) IBOutlet UIImageView *pic4;
@property (strong, nonatomic) IBOutlet UIImageView *pic5;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


@property (strong, nonatomic) IBOutlet UIView *pickbackground;

@property (strong, nonatomic) UIView *tempView;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;



@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *fadeBottom1;
@property (strong, nonatomic) IBOutlet UIScrollView *bottomScrollView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *fadeBottom_height;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollWidth;

-(void)leftClickAction;
-(void)rightClickAction;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) IBOutlet UILabel *edu_label;
@property (strong, nonatomic) IBOutlet UILabel *name_age;
@property (strong, nonatomic) IBOutlet UILabel *edu_job;

@property (nonatomic, assign) BOOL isExpanded;


@end
