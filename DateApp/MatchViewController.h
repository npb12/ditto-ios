//
//  MatchViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/7/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"
#import <JSQMessagesViewController/JSQMessages.h>
#import "MatchTableViewCell.h"


@interface MatchViewController : UIViewController<UIScrollViewDelegate>


- (IBAction)imageTap:(id)sender;


@property NSUInteger pageIndex;

@end


