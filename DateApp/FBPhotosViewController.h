//
//  FBPhotosViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/23/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "PhotoManager.h"
#import "PhotosCollectionViewCell.h"

@interface FBPhotosViewController : UIViewController
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidth;

@property (strong, nonatomic) PhotoManager *album;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSMutableArray *userPhotos;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (strong, nonatomic) NSString *selectedPhoto;


@property (nonatomic, assign) NSString *albumName;

@end
