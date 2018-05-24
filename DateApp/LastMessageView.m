//
//  LastMessageView.m
//  DateApp
//
//  Created by Neil Ballard on 4/30/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

#import "LastMessageView.h"

@implementation LastMessageView


-(void)awakeFromNib
{
    [super awakeFromNib];
    
 //   self.imgView.layer.cornerRadius = 20;
  //  self.imgView.layer.masksToBounds = YES;
    self.layer.cornerRadius = 14.0;
    
    [self.imgView layoutIfNeeded];
    
    UIView *avatarImageViewHolder = [[UIView alloc] initWithFrame:self.imgView.frame];
    avatarImageViewHolder.backgroundColor = [UIColor clearColor];
    [self.imgView.superview addSubview:avatarImageViewHolder];
    
    [avatarImageViewHolder addSubview:self.imgView];
    self.imgView.center = CGPointMake(avatarImageViewHolder.frame.size.width/2.0f, avatarImageViewHolder.frame.size.height/2.0f);
    
    
    self.imgView.layer.masksToBounds = YES;
    avatarImageViewHolder.layer.masksToBounds = NO;
    
    
    // set avatar image corner
    self.imgView.layer.cornerRadius = self.imgView.frame.size.height / 2;
    // set avatar image border
    //  [self.avatarImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    //  [self.avatarImageView.layer setBorderWidth: 2.0];
    
    // set holder shadow
    
    [avatarImageViewHolder.layer setShadowOffset:CGSizeZero];
    [avatarImageViewHolder.layer setShadowOpacity:0.5];
    [avatarImageViewHolder.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    //  avatarImageViewHolder.layer.shouldRasterize = YES;
    avatarImageViewHolder.clipsToBounds = NO;

   // [self setData];
}

-(void)setData
{
    self.message = [MatchMessages lastMessage].lastMessage;
    
    self.messageLabel.text = self.message.message;
    self.timeLabel.text = [self timeAgo:self.message.timestamp];
    
    NSURL *url;
    
    if (self.message.type == SENT_MESSAGE)
    {
        self.nameLabel.text = [[DataAccess singletonInstance] getName];
        User *user = [User currentUser];
        NSString *str = [user.pics objectAtIndex:0];
        url = [NSURL URLWithString:str];
    }
    else
    {
        self.nameLabel.text = [MatchUser currentUser].name;
        NSString *str = [self.parentVC.user.pics objectAtIndex:0];
        url = [NSURL URLWithString:str];
    }
    
    if (self.message.unread)
    {
        [self.unreadLabel setHidden:NO];
    }
    else
    {
        [self.unreadLabel setHidden:YES];
    }
    
    [self profilePicFrame:url];
}

-(void)profilePicFrame:(NSURL*)url
{

    
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    [manager downloadImageWithURL:url
                          options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {  } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished && !error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.user.profileImage = image;
                 CGSize size = CGSizeMake(self.imgView.frame.size.height, self.imgView.frame.size.height);
                 UIImage *resizedImage =  [image scaleImageToSize:size];
                 [UIView animateWithDuration:0.1
                                  animations:^{
                                      [self.imgView setImage:resizedImage];
                                  }completion:^(BOOL complete){

                                  }];
             });
             
         }
     }];
}

-(NSString*)timeAgo:(long)stamp
{
    long diff = [[NSDate date] timeIntervalSince1970] - stamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
    
    if (diff > 86400)
    {
        return [DADateFormatter timeAgoFromDate:date];
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone localTimeZone];
        [formatter setDateFormat:@"h:mm a"];
        NSString *str = [formatter stringFromDate:date];
        return [formatter stringFromDate:[[formatter dateFromString:str] dateByAddingTimeInterval:formatter.timeZone.secondsFromGMT]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
