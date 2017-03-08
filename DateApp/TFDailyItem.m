//
//  TFDailyItem.m
//  LocationBasedApplication
//
//  Created by Neil Ballard on 9/24/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@implementation TFDailyItem


+ (NSMutableArray*) allDailyItemsWithContext
{
    NSMutableArray *allDaily = [NSMutableArray new];
    
    
    TFDailyItem *day1 = [[TFDailyItem alloc] init];
    TFDailyItem *day2 = [[TFDailyItem alloc] init];
    TFDailyItem *day3 = [[TFDailyItem alloc] init];

    
    day1.identifier = @"id1";
    day2.identifier = @"id1";
    day3.identifier = @"id1";

    
    day1.photos = [[NSMutableArray alloc] init];
    day2.photos = [[NSMutableArray alloc] init];
    day3.photos = [[NSMutableArray alloc] init];

    
    [day1.photos addObject:[UIImage imageNamed:@"girl1"]];
    [day1.photos addObject:[UIImage imageNamed:@"cover_photo"]];
    [day1.photos addObject:[UIImage imageNamed:@"photo3"]];
    
    [day2.photos addObject:[UIImage imageNamed:@"girl2"]];
    [day2.photos addObject:[UIImage imageNamed:@"girl1"]];
    [day2.photos addObject:[UIImage imageNamed:@"girl3"]];
    
    [day3.photos addObject:[UIImage imageNamed:@"girl3"]];
    [day3.photos addObject:[UIImage imageNamed:@"girl2"]];
    [day3.photos addObject:[UIImage imageNamed:@"girl1"]];



    
    //2016-05-30T12:01-04:00
    
    NSString *slug = @"";
    day1.websiteUrl = [NSString stringWithFormat:@"http://tiff.net/the-review/%@", slug];
    day1.name = @"Elana";
    day1.subtitle = @"shortPitch";
    day1.age = @"23";
    day1.education = @"New York University";
    day1.occupation = @"Sales Representative at Belk";
    day1.liked = NO;
    day1.imageRemoteUrl = @"https://www.ucar.edu/communications/staffnotes/0801/images/laidlaw.jpg";
    day1.bio = @"I love to ride bikes and....";
    
    day2.websiteUrl = [NSString stringWithFormat:@"http://tiff.net/the-review/%@", slug];
    day2.name = @"Sarah";
    day2.subtitle = @"shortPitch";
    day2.age = @"24";
    day2.imageRemoteUrl = @"https://www.ucar.edu/communications/staffnotes/0801/images/laidlaw.jpg";
    day2.education = @"Cal State University";
    day2.liked = NO;
    day2.bio = @"I'm so unique.........";
    
    day3.websiteUrl = [NSString stringWithFormat:@"http://tiff.net/the-review/%@", slug];
    day3.name = @"Allie";
    day3.subtitle = @"shortPitch";
    day3.age = @"26";
    day3.occupation = @"Starbucks Barista";
    day3.liked = NO;
    day3.bio = @"Tell me how attractive I am";


    day3.imageRemoteUrl = @"https://www.ucar.edu/communications/staffnotes/0801/images/laidlaw.jpg";

    
    [allDaily addObject:day1];
    [allDaily addObject:day2];
    [allDaily addObject:day3];
 //   [allDaily addObject:day4];
 //   [allDaily addObject:day5];

    
    
    return allDaily;
}


@end
