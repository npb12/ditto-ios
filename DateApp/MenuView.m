//
//  MenuView.m
//  DateApp
//
//  Created by Neil Ballard on 3/10/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

#import "MenuView.h"
#import "DAGradientColor.h"
#define ACTION_MARGIN 120

@implementation MenuView{
    CGFloat xFromCenter;
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
    panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:panGestureRecognizer];
    
    self.topViewHeight.constant = [UIScreen mainScreen].bounds.size.height * 0.25;
    
    self.frameHeight.constant = self.topViewHeight.constant * 0.45;
    self.frameWidth.constant = self.frameHeight.constant;
    
    [self.imgFrame layoutIfNeeded];
    
    UIView *avatarImageViewHolder = [[UIView alloc] initWithFrame:self.imgFrame.frame];
    avatarImageViewHolder.backgroundColor = [UIColor clearColor];
    [self.imgFrame.superview addSubview:avatarImageViewHolder];
    
    [avatarImageViewHolder addSubview:self.imgFrame];
    self.center = CGPointMake(avatarImageViewHolder.frame.size.width/2.0f, avatarImageViewHolder.frame.size.height/2.0f);
    
    
    self.imgFrame.layer.masksToBounds = YES;
    avatarImageViewHolder.layer.masksToBounds = NO;
    
        self.imgFrame.layer.cornerRadius = self.frameWidth.constant / 2;
    
    [avatarImageViewHolder.layer setShadowOffset:CGSizeZero];
    [avatarImageViewHolder.layer setShadowOpacity:0.15];
    [avatarImageViewHolder.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    avatarImageViewHolder.clipsToBounds = NO;
    self.imgFrame.clipsToBounds = YES;
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"MenuTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"menuCell"];
    
    self.tableView.sectionHeaderHeight = 0.0;
    self.tableView.sectionFooterHeight = 0.0;
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToprofile)];
    [self.proImage addGestureRecognizer:tapGesture2];
    
    self.statusLabel.textColor = [UIColor lightGrayColor];


    if ([[DataAccess singletonInstance] UserHasMatch])
    {
        self.statusLabel.text = @"MATCHED";
    }
    else
    {
        self.statusLabel.text = @"DISCOVERING";
    }
}

-(void)displayData
{
    self.user = [User currentUser];
    
    if (!self.user)
    {
        [DAServer getProfile:^(User *settings, NSError *error) {
            // here, update the UI to say "Not busy anymore"
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadPhoto];
                    [self setNameLabel];
                    if ([[DataAccess singletonInstance] UserHasMatch])
                    {
                        self.statusLabel.text = @"MATCHED";
                    }
                    else
                    {
                        self.statusLabel.text = @"DISCOVERING";
                    }
                });
            } else {
                // update UI to indicate error or take remedial action
            }
        }];
    }
    else
    {
        [self loadPhoto];
        [self setNameLabel];
    }
}

-(void)goToprofile
{
    User *user = [User currentUser];
    [self.parentVC profileAction:user];
}

-(void)setNameLabel
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@, %@", self.user.name, self.user.age];
}

-(void)loadPhoto
{
    [PhotoDownloader downloadImage:[self.user.pics objectAtIndex:0] completion:^(UIImage *image, NSError *error)
     {
         if (image && !error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.user.profileImage = image;
                 CGSize size = CGSizeMake(self.frameHeight.constant, self.frameHeight.constant);
                 UIImage *scaledImage = [image scaleImageToSize:size];
                 self.proImage.image = scaledImage;
             });
         }
         
     }];
}

#pragma tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0)
    {
        return 2;
    }
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    /*    ConnectionsTableViewCell *cell = (ConnectionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier]; */
    
    
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.settingLabel.text = @"Edit Profile";
        }
        else if (indexPath.row == 1)
        {
            cell.settingLabel.text = @"Settings";
            cell.icn.image = [UIImage imageNamed:@"drawer_settings_icon"];
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            cell.settingLabel.text = @"In App Purchases";
            cell.icn.image = [UIImage imageNamed:@"drawer_inapp_icon"];
        }
        else if (indexPath.row == 1)
        {
            cell.settingLabel.text = @"Privacy Policy";
            cell.icn.image = [UIImage imageNamed:@"drawer_privacy_icon"];
        }
        else if (indexPath.row == 2)
        {
            cell.settingLabel.text = @"Terms of Service";
        }
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            //go to profile
            User *user = [User currentUser];
            [self.parentVC editProfile:user];
        }
        else
        {
            //go to settings
            [self.parentVC settingsAction];
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            //in app purchases
            [self.parentVC goToInAppPurchaes];
        }
        else if(indexPath.row == 1)
        {
            //privacy policy
            NSURL *url = [NSURL URLWithString:@"https://www.dittoapp.io/privacy/"];
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:url options:@{} completionHandler:nil];
        }
        else
        {
            //terms of service
            NSURL *url = [NSURL URLWithString:@"https://www.dittoapp.io/new-page/"];
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:url options:@{} completionHandler:nil];
        }
    }
    
}
/*
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 2.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0)
    {
        UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
        [footer setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
        return footer;
    }
    
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
    [footer setBackgroundColor:[UIColor clearColor]];

    return footer;
} */

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
       return 35.0;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass: [UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView* castView = (UITableViewHeaderFooterView*) view;
        castView.contentView.backgroundColor = [UIColor whiteColor];
       // [castView.textLabel setTextColor:[UIColor grayColor]];
    }
}


-(void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    //%%% this extracts the coordinate data from your swipe movement. (i.e. How much did you move?)
    xFromCenter = [gestureRecognizer translationInView:self].x; //%%% positive for right swipe, negative for left
    
    //%%% checks what state the gesture is in. (are you just starting, letting go, or in the middle of a swipe?)
    switch (gestureRecognizer.state) {
            //%%% just started swiping
        case UIGestureRecognizerStateBegan:{
            NSLog(@"printing x from began: %f", xFromCenter);
            break;
        };
            //%%% in the middle of a swipe
        case UIGestureRecognizerStateChanged:{
            
            NSLog(@"printing x from changed: %f", xFromCenter);
            
            break;
        };
            //%%% let go of the card
        case UIGestureRecognizerStateEnded: {
         //   [self afterSwipeAction];
            NSLog(@"printing x from changed: %f", xFromCenter);
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}


/*
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
} */


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
