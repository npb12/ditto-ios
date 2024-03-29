//
//  AppDelegate.h
//  DateApp
//
//  Created by Neil Ballard on 9/30/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)registerForRemoteNotifications;

@end

