//
//  AppDelegate.m
//  DateApp
//
//  Created by Neil Ballard on 9/30/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "AppDelegate.h"

#import "NSUserDefaults+DemoSettings.h"


@interface AppDelegate ()

@property (nonatomic, strong) RootViewController *rootVC;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    
    
    [NSUserDefaults saveIncomingAvatarSetting:YES];
    [NSUserDefaults saveOutgoingAvatarSetting:YES];
    
    
    if ([self.window.rootViewController isKindOfClass:[RootViewController class]])
    {
        self.rootVC = (RootViewController*)self.window.rootViewController;
    }
    

    return YES;
}


- (void)registerForRemoteNotifications {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [[DataAccess singletonInstance] setaskedForNotifications:YES];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
        if(!error){
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }];
    
}

//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)

notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info foreground: %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    
    NSDictionary *notif = [notification.request.content.userInfo objectForKey:@"aps"];
    
    NSString *type = [notif objectForKey:@"type"];
    
    NSLog(@"The type of notification is::: %@", type);
    
    if ([type isEqualToString:@"match"])
    {
        [DAServer getMatchesData:NO completion:^(NSError *error) {
            // here, update the UI to say "Not busy anymore"
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ///  [self.chatBtn setImage:[UIImage imageNamed:@"chat_full_message"] forState:UIControlStateNormal];
                });
            } else {
                // update UI to indicate error or take remedial action
            }
        }];
    }
    else if([type isEqualToString:@"altmatch"])
    {
        [DAServer getMatchesData:YES completion:^(NSError *error) {
            // here, update the UI to say "Not busy anymore"
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ///  [self.chatBtn setImage:[UIImage imageNamed:@"chat_full_message"] forState:UIControlStateNormal];
                });
            } else {
                // update UI to indicate error or take remedial action
            }
        }];
    }
    else if([type isEqualToString:@"message"])
    {
        if (self.rootVC)
        {
            [self.rootVC.chatBtn setImage:[UIImage imageNamed:@"chat_full_message"] forState:UIControlStateNormal];
        }
    }
    else if([type isEqualToString:@"drop"])
    {
        [MatchUser removeCurrentMatch];
        if (self.rootVC)
        {
            [self.rootVC updateUnmatch];
        }

    }
    
    

}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"User Info background: %@",response.notification.request.content.userInfo);
    completionHandler();
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenString = deviceToken.description;
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@"[< >]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, deviceTokenString.length)];
    NSLog(@" device token eeees %@", deviceTokenString.description);
    

    [DAServer postDeviceToken:deviceTokenString.description completion:^(NSMutableArray *result, NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {
            if ([result count] > 0) {

            }
        } else {
            // update UI to indicate error or take remedial action
        }
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}




@end