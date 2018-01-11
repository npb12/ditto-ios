//
//  SinglePhotoViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/23/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "PhotoManager.h"
#import "DAServer.h"
#import "UIImage+Scale.h"

@interface SinglePhotoViewController : UIViewController


@property (nonatomic, strong) NSString *photo;
@property (strong, nonatomic) NSMutableArray *photos;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (strong, nonatomic) NSString *selectedPhoto;



@end
