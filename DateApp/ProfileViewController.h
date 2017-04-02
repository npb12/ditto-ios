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

@protocol LikedProfileProtocol <NSObject>
-(void)likeCurrent;
@end

@interface ProfileViewController : UIViewController<UIScrollViewDelegate>

@property (nonnull, strong, nonatomic) User *user;

@property (nonatomic, weak) id<LikedProfileProtocol> delegate;


@property (nonnull,strong, nonatomic) IBOutlet NSLayoutConstraint *jobLabelHeight;
@property (nonnull,strong, nonatomic) IBOutlet NSLayoutConstraint *eduLabelHeight;
@property (nonnull,strong, nonatomic) IBOutlet NSLayoutConstraint *jobLabelTop;
@property (nonnull,strong, nonatomic) IBOutlet NSLayoutConstraint *eduLabelTop;

@property (strong, nonatomic) IBOutlet UIView *pc1;
@property (strong, nonatomic) IBOutlet UIView *pc2;
@property (strong, nonatomic) IBOutlet UIView *pc3;
@property (strong, nonatomic) IBOutlet UIView *pc4;
@property (strong, nonatomic) IBOutlet UIView *pc5;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerConstraint;

@end
