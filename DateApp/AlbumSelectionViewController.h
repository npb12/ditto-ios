//
//  AlbumSelectionViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/20/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBAlbumsViewController.h"
#import "User.h"
#import "DAServer.h"


@interface AlbumSelectionViewController : UIViewController

@property (nonatomic, assign) NSInteger selectedIndex;
@property (strong, nonatomic) User *user;


@end
