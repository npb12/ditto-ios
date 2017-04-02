//
//  MatchViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/7/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"
#import <JSQMessagesViewController/JSQMessages.h>
#import "MatchTableViewCell.h"

@protocol DraggableViewDelegate <NSObject>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;


@end

@protocol SegueProtocol <NSObject>
-(void)gotoMessage;
@end


@interface MatchViewController : UIViewController<UIScrollViewDelegate>


- (IBAction)imageTap:(id)sender;


@property NSUInteger pageIndex;

-(void)UnmatchSelected:(UIButton*)parentBtn;

@property (nonatomic, weak) id<SegueProtocol> delegate;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *jobLabelHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *eduLabelHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *jobLabelTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *eduLabelTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bioLabelHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bioLabelTop;



@property (strong, nonatomic) IBOutlet UIView *pc1;
@property (strong, nonatomic) IBOutlet UIView *pc2;
@property (strong, nonatomic) IBOutlet UIView *pc3;
@property (strong, nonatomic) IBOutlet UIView *pc4;
@property (strong, nonatomic) IBOutlet UIView *pc5;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerConstraint;

@end


