//
//  MenuView.m
//  DateApp
//
//  Created by Neil Ballard on 3/10/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    
    
    self.topViewHeight.constant = [UIScreen mainScreen].bounds.size.height * 0.25;
    
    self.frameHeight.constant = self.topViewHeight.constant * 0.6;
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
    return 50.0;
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
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            cell.settingLabel.text = @"In App Purchases";
        }
        else if (indexPath.row == 1)
        {
            cell.settingLabel.text = @"Privacy Policy";
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
        }
        else if(indexPath.row == 1)
        {
            //privacy policy
        }
        else
        {
            //terms of service
        }
    }
    
}

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
}

/*
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}





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
