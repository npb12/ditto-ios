//
//  MenuView.h
//  DateApp
//
//  Created by Neil Ballard on 3/10/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTableViewCell.h"
#import "RootViewController.h"
#import "DAServer.h"
#import "User.h"



@interface MenuView : UIView<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet UIView *imgFrame;
@property (strong, nonatomic) IBOutlet UIImageView *proImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *frameHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *frameWidth;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) RootViewController *parentVC;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic)CGPoint originalPoint;
-(void)displayData;
@end
