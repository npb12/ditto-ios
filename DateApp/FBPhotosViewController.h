//
//  FBPhotosViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/23/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface FBPhotosViewController : UIViewController
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidth;

@property (strong, nonatomic) NSMutableArray *photos;
@property (nonatomic, assign) NSInteger selectedIndex;

@end
