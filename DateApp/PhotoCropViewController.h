//
//  PhotoCropViewController.h
//  DateApp
//
//  Created by Neil Ballard on 1/11/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCropViewController : UIViewController

@property (nonatomic, strong) NSString *photo;
@property (strong, nonatomic) NSMutableArray *photos;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (strong, nonatomic) NSString *selectedPhoto;

@end
