//
//  PhotoManager.h
//  portal
//
//  Created by Neil Ballard on 10/10/15.
//  Copyright © 2015 Neil_appworld. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FBAlbumObject.h"
#import "DataAccess.h"

@interface PhotoManager : NSObject

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *album_id;
@property (nonatomic, strong) NSString *album_name;
@property (nonatomic, strong) NSString *photo_id;
@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, strong) NSMutableArray *photos;
//@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSString *fullSizePhoto;
@property (nonatomic, strong) NSString *photo;

@property (nonatomic) NSInteger boxID;

+(void)getFacebookProfileAlbums:(void (^)(NSMutableArray *, NSError *))completionBlock;
+(void)getFacebookProfilePhotos:(PhotoManager*)albumObject completion:(void (^)(NSMutableArray *, NSError *))completionBlock;
+(void)getPhoto:(NSString*)photo_id completion:(void (^)(void))completionBlock;
+(void)getPhotos:(NSString*)album_id completion:(void (^)(void))completionBlock;

@end
