//
//  LastMessageView.h
//  DateApp
//
//  Created by Neil Ballard on 4/30/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchUser.h"
#import "User.h"
#import "Message.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import "MatchMessages.h"
#import "MatchViewController.h"
#import "DADateFormatter.h"

@interface LastMessageView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) Message *message;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) MatchViewController *parentVC;

-(void)setData;
@property (strong, nonatomic) IBOutlet UILabel *unreadLabel;

@end
