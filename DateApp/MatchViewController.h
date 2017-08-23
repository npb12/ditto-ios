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
#import "DADateFormatter.h"
#import "MessageModelData.h"
#import "User.h"
#import <SDWebImage/UIImageView+WebCache.h>


@protocol GoToProfileProtocol <NSObject>

-(void)selectedProfile:(User*)user matched:(BOOL)match;

@end

@protocol GoDiscoverProtocol <NSObject>

-(void)discoverSelected;

@end



@protocol DraggableViewDelegate <NSObject>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;


@end

@protocol SegueProtocol <NSObject>
-(void)gotoMessage;
-(void)unmatchUser;
@end


@interface MatchViewController : UIViewController


- (IBAction)imageTap:(id)sender;


@property NSUInteger pageIndex;

-(void)UnmatchSelected:(UIButton*)parentBtn;

@property (nonatomic, weak) id<SegueProtocol> delegate;

@property (nonatomic, weak) id<GoDiscoverProtocol> discoverDelegate;



@property (strong, nonatomic) IBOutlet UIImageView *profilePic;


@property (strong, nonatomic) MessageModelData *demoData;


@property (nonatomic, weak) id<GoToProfileProtocol> profile_delegate;

-(void)updateUnmatch;
-(void)updateMatch;

@end


