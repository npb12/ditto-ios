//
//  LoginViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/25/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"
@protocol SetupDelegate;

@interface LoginViewController : UIViewController
{
    NSMutableData *_responseData;
}

@property (nonatomic, weak) id<SetupDelegate> delegate;

@end
