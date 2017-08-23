//
//  FBAlbumsViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/26/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"
#import "AlbumTableViewCell.h"
#import "DAGradientColor.h"



@interface FBAlbumsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *photos;
@property (nonatomic, assign) NSInteger selectedIndex;


@end
