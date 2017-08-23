//
//  LocationManager.h
//  DateApp
//
//  Created by Neil Ballard on 2/1/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "Includes.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic) CLLocationCoordinate2D location;

- (void)getUsersInLocation;

+ (instancetype)sharedInstance;

@end
