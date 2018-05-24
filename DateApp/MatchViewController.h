//
//  MatchViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/7/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"
#import "MatchTableViewCell.h"
#import "DADateFormatter.h"
#import "User.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MatchUser.h"


@protocol GoToProfileProtocol <NSObject>

-(void)selectedProfile:(User*)user matched:(BOOL)match;

@end

@protocol GoDiscoverProtocol <NSObject>

-(void)discoverSelected;

@end



@protocol DraggableViewDelegate <NSObject>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;
-(void)checkEmpty;

@end

@protocol SegueProtocol <NSObject>
-(void)gotoMessage;
-(void)unmatchUser;
@end


@interface MatchViewController : UIViewController


- (IBAction)imageTap:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *messageButton;

@property NSUInteger pageIndex;

-(void)UnmatchSelected:(UIButton*)parentBtn;

@property (nonatomic, weak) id<SegueProtocol> delegate;

@property (nonatomic, weak) id<GoDiscoverProtocol> discoverDelegate;

-(CGRect)profileFrame;

@property (strong, nonatomic) MatchUser *user;


@property (strong, nonatomic) IBOutlet UIImageView *profilePic;

@property (strong, nonatomic) IBOutlet UILabel *unmatchedHeader;
@property (strong, nonatomic) IBOutlet UILabel *unmatchedSub;

@property (nonatomic, weak) id<GoToProfileProtocol> profile_delegate;

-(void)setMessageUI;
-(void)updateUnmatch;
-(void)updateMatch;

@end


