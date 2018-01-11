//
//  PhotoManager.m
//  portal
//
//  Created by Neil Ballard on 10/10/15.
//  Copyright © 2015 Neil_appworld. All rights reserved.
//

#import "PhotoManager.h"

@implementation PhotoManager

+(void)getFacebookProfileAlbums:(void (^)(NSMutableArray *, NSError *))completionBlock{
    
    NSString *token = [[DataAccess singletonInstance] getToken];
    
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id, first_name"} tokenString:token version:nil HTTPMethod:@"GET"];
        
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if(result)
        {
            
            NSString *userid = [result objectForKey:@"id"];
            
                NSString *aurl = @"/%@/albums";
                
                NSString *url = [NSString stringWithFormat:aurl, userid];
                
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                              initWithGraphPath:url
                                              parameters:@{@"fields": @"name"}
                                              tokenString:token version:nil
                                              HTTPMethod:@"GET"];
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                      id result,
                                                      NSError *error) {
        
                    NSArray *data =  result[@"data"];
                    NSDictionary *albums_id;
                    NSMutableArray *albumArray = [NSMutableArray new];
                    
                    for(albums_id in data) {
                        FBAlbumObject *albumObject = [FBAlbumObject new];
                        albumObject.userid = userid;
                        albumObject.album_id = (NSString*)[albums_id objectForKey:@"id"];
                        albumObject.album_name = (NSString*)[albums_id objectForKey:@"name"];
                        if (albumObject)
                        {
                            [albumArray addObject:albumObject];
                        }
                    }
                    
                    completionBlock(albumArray, error);
                    
                }];
            
        }else{
            completionBlock(nil, error);
            NSLog(@"%@", error);
        }
        
    }];
    
    [connection start];
}


+(void)getFacebookProfilePhotos:(PhotoManager*)albumObject completion:(void (^)(NSMutableArray *, NSError *))completionBlock{
    
    NSString *token = [[DataAccess singletonInstance] getToken];
    
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id, first_name"} tokenString:token version:nil HTTPMethod:@"GET"];
    
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if(result)
        {
            
            albumObject.userid = [result objectForKey:@"id"];
            
                
                NSString *aurl = @"/%@/photos";
                
                NSString *url = [NSString stringWithFormat:aurl, albumObject.album_id];
                
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                              initWithGraphPath:url
                                              parameters:@{@"fields": @"images"}
                                              tokenString:token version:nil
                                              HTTPMethod:@"GET"];
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                      id result,
                                                      NSError *error) {
                    
                    //   NSLog(@"%@", result);
                    
                    
                    
                    NSArray *data =  result[@"data"];
                    
                    NSLog(@"%@", data);
                    NSMutableArray *photos = [NSMutableArray new];
                    
                    NSDictionary *albums_id;
                    for(albums_id in data) {
                        PhotoManager *albumObject = [[PhotoManager alloc] init];
                        albumObject.photo_id = (NSString*)[albums_id objectForKey:@"id"];
                        NSArray *images = [albums_id objectForKey:@"images"];
                        
                        // (NSString*)[albums_id objectForKey:@"source"]
                        
                        NSDictionary *dict;
                        //           NSLog(@"%@", albumObject.photo);
                        int largest = 0, smallest = 300;
                        for(dict in images){
                            //    NSLog(@"%@", dict);
                            NSString *photo = [dict valueForKey:@"height"];
                            
                            int height = [photo intValue];
                            
                            //get the smallest photo for the icon
                            if (height < smallest) {
                                albumObject.photo = [dict valueForKey:@"source"];
                                smallest = height;
                                
                            }
                            //get the largest photo for the full screen photos
                            if (height > largest) {
                                albumObject.fullSizePhoto = [dict valueForKey:@"source"];
                                largest = height;
                            }
                            
                        }
                        //         NSLog(@"%@", albumObject.photo_id);
                        //            NSLog(@"%@", albumObject.photo);
                        [photos addObject:albumObject];
                    }
                    completionBlock(photos, error);
                }];
            
            
        }else{
            NSLog(@"%@", error);
            completionBlock(nil, error);
        }
        
    }];
    
    [connection start];
}


+(void)getPhoto:(NSString*)photo_id completion:(void (^)(void))completionBlock
{
    
    NSString *token = [[DataAccess singletonInstance] getToken];
    
    NSString *url = [@"/" stringByAppendingString:photo_id];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:url
                                  parameters:@{@"fields": @"link"}
                                  tokenString:token version:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        
    }];
    
}


+(void)getPhotos:(NSString*)album_id completion:(void (^)(void))completionBlock
{
    NSString *token = [[DataAccess singletonInstance] getToken];
    NSString *aurl = @"/%@/photos";
    
    NSString *url = [NSString stringWithFormat:aurl, album_id];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:url
                                  parameters:@{@"fields": @"images"}
                                  tokenString:token version:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        NSLog(@"%@", result);
        
    }];
    
}

@end
