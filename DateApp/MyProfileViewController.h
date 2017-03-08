//
//  MyProfileViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/12/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "MyProfileTableViewCell.h"

@interface MyProfileViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *bio_label;
- (IBAction)edit_images:(id)sender;
- (IBAction)edit_info:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)go_back:(id)sender;
@end
