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

#import "Includes.h"
#import "OverlayView.h"
#import "UIImage+Scale.h"

@protocol HasMatchDelegate <NSObject>

-(void)noSwipingAlert;

@end

@protocol ProfileProtocol <NSObject>

-(void)profileSelected:(User*)user;

@end

@protocol NextCardProtocol <NSObject>

-(void)nextCardAction;

@end

@protocol DraggableViewDelegate <NSObject>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;
-(void)checkEmpty;
@end

@interface DraggableView : UIView<UIGestureRecognizerDelegate>

@property (weak) id <DraggableViewDelegate> delegate;
@property (nonatomic, weak) id<HasMatchDelegate> noswipe_delegate;
@property (nonatomic, weak) id<ProfileProtocol> profile_delegate;
@property (nonatomic, weak) id<NextCardProtocol> nextCardDelegate;

- (id)initWithUser:(User*)user viewFrame:(CGRect)frame;

@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic)CGPoint originalPoint;
@property (nonatomic,strong)OverlayView* overlayView;


@property (strong, nonatomic) IBOutlet UIImageView *pic;

@property (strong, nonatomic) IBOutlet UIView *pickbackground;

@property (strong, nonatomic) IBOutlet UIImageView *lock;
@property (strong, nonatomic) IBOutlet UILabel *matchedLabel;
@property (strong, nonatomic) IBOutlet UILabel *matchedSubLabel;
@property (strong, nonatomic) UIImageView *gradientView;

@property (strong, nonatomic) UIView *avatarImageViewHolder;


@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (strong, nonatomic) User *user;


@property (strong, nonatomic) IBOutlet UIVisualEffectView *blurView;


@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *fadeBottom1;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *fadeBottom_height;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollWidth;

-(void)leftClickAction;
-(void)rightClickAction;
@property (strong, nonatomic) IBOutlet UILabel *nextLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottom;

@property (strong, nonatomic) IBOutlet UILabel *edu_label;
@property (strong, nonatomic) IBOutlet UILabel *job_label;
@property (strong, nonatomic) IBOutlet UILabel *name_age;
@property (strong, nonatomic) IBOutlet UILabel *edu;
@property (strong, nonatomic) IBOutlet UILabel *job;

@property (nonatomic, assign) BOOL isExpanded;




-(void)updateMatch;
-(void)updateUnmatch;
-(void)setFrameShadow;
-(void)removeBlur;
-(void)showBlur;

@end
