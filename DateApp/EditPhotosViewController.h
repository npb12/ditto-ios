//
//  EditPhotosViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/20/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"
#import "FBAlbumsViewController.h"
#import "AlbumSelectionViewController.h"
#import "UserInfoTableViewCell.h"

@interface EditPhotosViewController : UIViewController
                <UICollectionViewDelegate,UICollectionViewDataSource, UIGestureRecognizerDelegate,
                UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidth;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nullable, strong, nonatomic)  NSMutableArray *pics;


- (IBAction)go_back:(id)sender;
- (IBAction)delete_photos:(id)sender;
- (IBAction)goto_albums:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *gradientView;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;

@property (strong, nonatomic) User *user;

@end
