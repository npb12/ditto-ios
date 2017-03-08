//
//  PhotoManager.h
//  portal
//
//  Created by Neil Ballard on 10/10/15.
//  Copyright © 2015 Neil_appworld. All rights reserved.
//

#import "Includes.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface PhotoManager : NSObject

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *album_id;
@property (nonatomic, strong) NSString *album_name;
@property (nonatomic, strong) NSString *photo_id;
@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) UIImage *fullSizePhoto;

@property (nonatomic) NSInteger boxID;





+ (id)singletonInstance;
//+ (PhotoManager *)sharedInstance;
-(void)getFacebookProfileInfos:(int)type completion:(void (^)(void))completionBlock;

@end
