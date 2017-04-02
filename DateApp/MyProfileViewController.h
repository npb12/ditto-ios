//
//  MyProfileViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/12/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "MyProfileTableViewCell.h"

@interface MyProfileViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *bio_label;
- (IBAction)edit_images:(id)sender;
- (IBAction)edit_info:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *name_label;
@property (strong, nonatomic) IBOutlet UIView *colorView;

- (IBAction)go_back:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *pc1;
@property (strong, nonatomic) IBOutlet UIView *pc2;
@property (strong, nonatomic) IBOutlet UIView *pc3;
@property (strong, nonatomic) IBOutlet UIView *pc4;
@property (strong, nonatomic) IBOutlet UIView *pc5;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerConstraint;
@end
