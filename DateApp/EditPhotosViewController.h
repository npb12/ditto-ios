//
//  EditPhotosViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/20/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface EditPhotosViewController : UIViewController
                <UICollectionViewDelegate,UICollectionViewDataSource, UIGestureRecognizerDelegate>


@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidth;

@property (strong, nonatomic) IBOutlet UITextView *bio_textview;

@property (strong, nonatomic) IBOutlet UITextView *edu_textview;

@property (strong, nonatomic) IBOutlet UITextView *occu_textview;

- (IBAction)go_back:(id)sender;
- (IBAction)delete_photos:(id)sender;
- (IBAction)goto_albums:(id)sender;

@end
