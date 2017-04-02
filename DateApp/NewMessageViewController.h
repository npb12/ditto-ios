//
//  NewMessageViewController.h
//  DateApp
//
//  Created by Neil Ballard on 3/18/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegueProtocol <NSObject>
-(void)gotoMessage;
@end

@interface NewMessageViewController : UIViewController

@property (nonatomic, weak) id<SegueProtocol> delegate;


@end
