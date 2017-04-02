//
//  SinglePhotoViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/23/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface SinglePhotoViewController : UIViewController


@property (nonatomic, strong) NSString *photo;


+ (id)singletonInstance;


@end
