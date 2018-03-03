//
//  PhotosCollectionViewCell.h
//  DateApp
//
//  Created by Neil Ballard on 11/12/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface PhotosCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UIView *borderView;
@property (strong, nonatomic) IBOutlet UIImageView *actionIcon;
@property (strong, nonatomic) UIImage *fullSizePhoto;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end
