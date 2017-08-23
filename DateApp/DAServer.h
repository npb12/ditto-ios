//
//  DAServer.h
//  DateApp
//
//  Created by Neil Ballard on 3/30/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "Includes.h"
#import "Messages.h"


@interface DAServer : NSObject

#pragma POST requests

+ (void)facebookLogin:(UIViewController*)vc
           completion:(void (^)(NSMutableArray *, NSError *))completion;

+ (void)postDeviceToken:(NSString*)token
             completion:(void (^)(NSMutableArray *, NSError *))completion;

+ (void)postLocation:(User*)param
          completion:(void (^)(NSMutableArray *, NSError *))completion;

+ (void)swipe:(NSString*)likedID liked:(int)like
   completion:(void (^)(NSError *))completion;

+ (void)dropMatch:(NSString*)message
       completion:(void (^)(NSError *))completion;

+ (void)updateProfile:(NSString*)type description:(NSString*)text
           completion:(void (^)(NSError *))completion;

+ (void)updateSettings:(NSString*)type setting:(NSString*)edit
            completion:(void (^)(NSError *))completion;

+ (void)dropSwapMatch:(NSString*)likedID
           completion:(void (^)(NSError *))completion;

+ (void)dismissAlternateMatch:(NSString*)likedID
                   completion:(void (^)(NSError *))completion;

+ (void)updateAlbum:(NSMutableArray*)array completion:(void (^)(NSError *))completion;

+ (void)addLocalPhoto:(UIImage*)image completion:(void (^)(NSError *))completion;

+ (void)facebookLogout;

#pragma GET requests

+ (void)getProfile:(NSString *)param
        completion:(void (^)(User *, NSError *))completion;

+ (void)getSettings:(NSString *)param
         completion:(void (^)(User *, NSError *))completion;

+ (void)getMessages:(NSString *)param
         completion:(void (^)(NSArray *, NSError *))completion;

+ (void)LastMessageNew:(NSString *)param
            completion:(void (^)(bool, NSError *))completion;

+ (void)getMatchesData:(BOOL)alt
            completion:(void (^)(NSError *))completion;

@end
