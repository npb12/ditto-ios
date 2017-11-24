//
//  PhotoDownloader.m
//  DateApp
//
//  Created by Neil Ballard on 11/18/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "PhotoDownloader.h"

@implementation PhotoDownloader

+ (void)downloadImage:(NSString*)url
           completion:(void (^)(UIImage *, NSError *))completion
{
    NSURL *imgURL = [NSURL URLWithString:url];
    
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    [manager downloadImageWithURL:imgURL
                          options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {  } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished && !error)
         {
             completion(image, nil);
         }
         else
         {
             completion(nil, error);
         }
     }];
    
}

@end
