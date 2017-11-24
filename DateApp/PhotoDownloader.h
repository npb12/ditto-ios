//
//  PhotoDownloader.h
//  DateApp
//
//  Created by Neil Ballard on 11/18/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface PhotoDownloader : NSObject

+ (void)downloadImage:(NSString*)url
           completion:(void (^)(UIImage *, NSError *))completion;

@end
