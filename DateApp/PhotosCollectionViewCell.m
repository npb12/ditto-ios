//
//  PhotosCollectionViewCell.m
//  DateApp
//
//  Created by Neil Ballard on 11/12/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@implementation PhotosCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat size = [UIScreen mainScreen].bounds.size.width;
    
    CGRect frame = CGRectMake(0, 0, size, size);
    
    UIView *avatarImageViewHolder = [[UIView alloc] initWithFrame:frame];
    avatarImageViewHolder.backgroundColor = [UIColor clearColor];
    [self.containerView.superview addSubview:avatarImageViewHolder];

    [avatarImageViewHolder addSubview:self.containerView];
    self.center = CGPointMake(avatarImageViewHolder.frame.size.width/2.0f, avatarImageViewHolder.frame.size.height/2.0f);
    
    
    self.containerView.layer.masksToBounds = YES;
    avatarImageViewHolder.layer.masksToBounds = NO;
    
    
    // set avatar image corner
    self.containerView.layer.cornerRadius = size / 2;
    // set avatar image border
     // [self.containerView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
     // [self.containerView.layer setBorderWidth: 2.0];
    
    [avatarImageViewHolder.layer setShadowOffset:CGSizeZero];
    [avatarImageViewHolder.layer setShadowOpacity:0.15];
    [avatarImageViewHolder.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    avatarImageViewHolder.clipsToBounds = NO;
    self.containerView.clipsToBounds = NO;
    
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self setHighlighted:NO];
    
    self.photo.image = nil;
    self.actionIcon.image = nil;
}

@end
