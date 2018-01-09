//
//  ProfileViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/3/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"
#import "User.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MessageViewController.h"
#import "UIImage+Scale.h"

@protocol LikedProfileProtocol <NSObject>
-(void)likeCurrent:(BOOL)option;
@end

@interface ProfileViewController : UIViewController<UIScrollViewDelegate>

@property (nonnull, strong, nonatomic) User *user;
@property (nonatomic, assign) BOOL match;
@property (nonatomic, assign) BOOL isMine;


@property (nonatomic, weak) id<LikedProfileProtocol> delegate;


@property (nonnull,strong, nonatomic) IBOutlet NSLayoutConstraint *jobLabelHeight;
@property (nonnull,strong, nonatomic) IBOutlet NSLayoutConstraint *eduLabelHeight;
@property (nonnull,strong, nonatomic) IBOutlet NSLayoutConstraint *jobLabelTop;
@property (nonnull,strong, nonatomic) IBOutlet NSLayoutConstraint *eduLabelTop;

@property (strong, nonatomic) IBOutlet UIImageView *pc1;
@property (strong, nonatomic) IBOutlet UIImageView *pc2;
@property (strong, nonatomic) IBOutlet UIImageView *pc3;
@property (strong, nonatomic) IBOutlet UIImageView *pc4;
@property (strong, nonatomic) IBOutlet UIImageView *pc5;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerConstraint;


@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;


@end
