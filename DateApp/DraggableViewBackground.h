//
//  DraggableViewBackground.h
//  portal
//
//  Created by Neil Ballard on 10/9/15.
//  Copyright © 2015 Neil_appworld. All rights reserved.
//

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

#import "DraggableView.h"
@protocol MatchSegueProtocol;

@protocol NoSwipeProtocol <NSObject>

-(void)noSwipingAlert;

@end

@protocol SelectedProfileProtocol <NSObject>

-(void)selectedProfile:(User*)user;

@end


@interface DraggableViewBackground : UIView <DraggableViewDelegate, UITextFieldDelegate>


-(void)createViewWithUsers:(NSMutableArray*)users;

//methods called in DraggableView
-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;

-(void)likedCurrent:(BOOL)option;

@property (retain,nonatomic)NSMutableArray* userCards; //%%% the labels the cards
@property (retain,nonatomic)NSMutableArray* allCards; //%%% the labels the cards

@property (nonatomic, weak) id<MatchSegueProtocol> matched_delegate;
@property (nonatomic, weak) id<NoSwipeProtocol> noswipe_delegate;
@property (nonatomic, weak) id<SelectedProfileProtocol> profile_delegate;

@property (strong, nonatomic) IBOutlet UILabel *emptyLabel;
@property (strong, nonatomic) IBOutlet UILabel *emptyLabel2;

-(void)updateUnmatch;

-(void)updateMatch;

@end

@protocol MatchSegueProtocol <NSObject>

-(void)goToMatchedSegue:(id)sender obj:(User*)object;

@end
