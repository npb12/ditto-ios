//
//  DAServer.h
//  DateApp
//
//  Created by Neil Ballard on 3/30/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "Includes.h"
#import "Message.h"


@interface DAServer : NSObject

enum RequestType {
    GET=1,
    PUT,
    POST,
};


@property (nonatomic,assign) enum RequestType requestType;


#pragma POST requests

+ (void)facebookLogin:(UIViewController*)vc
           completion:(void (^)(NSMutableArray *, NSError *))completion;

+ (void)postDeviceToken:(NSString*)token
             completion:(void (^)(NSError *))completion;

+ (void)postLocation:(CLLocationCoordinate2D)location
          completion:(void (^)(NSMutableArray *, NSError *))completion;

+ (void)swipe:(NSString*)likedID liked:(BOOL)like
   completion:(void (^)(NSError *))completion;

+ (void)dropMatch:(NSString*)message
       completion:(void (^)(NSError *))completion;

+ (void)updateProfile:(NSString*)requestType data:(NSDictionary*)dict
           completion:(void (^)(NSError *))completion;

+ (void)updateSettings:(NSString*)type setting:(NSString*)edit
            completion:(void (^)(NSError *))completion;

+ (void)dropSwapMatch:(NSString*)likedID
           completion:(void (^)(NSError *))completion;

+ (void)dismissAlternateMatch:(NSString*)likedID
                   completion:(void (^)(NSError *))completion;

+ (void)facebookLogout;

+(void)uploadPhoto:(UIImage*)image index:(NSInteger)index completion:(void (^)(NSError *))completion;

+ (void)deletePhoto:(NSString*)position
         completion:(void (^)(NSError *))completion;
#pragma GET requests

+ (void)facebookAuth:(UIViewController*)vc
          completion:(void (^)(NSError *))completion;

+ (void)getProfile:(void (^)(User *, NSError *))completion;

+ (void)getSettings:(NSString *)param
         completion:(void (^)(User *, NSError *))completion;

+ (void)getMessages:(void (^)(NSArray *, NSError *))completion;

+ (void)LastMessageNew:(NSString *)param
            completion:(void (^)(bool, NSError *))completion;

+ (void)getMatchesData:(BOOL)alt
            completion:(void (^)(NSError *))completion;

@end
