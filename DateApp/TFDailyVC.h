//
//  HomeViewController.h
//  DateApp
//
//  Created by Neil Ballard on 10/2/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"
#import "TFDailyTableCell.h"

@interface TFDailyVC : UIViewController<ProfileSegueProtocol, MatchSegueProtocol>

- (CGSize) safeScreenSize;

-(void)goToProfileSegue:(id)sender obj:(TFDailyItem*)object;
-(void)goToMatchedSegue:(id)sender obj:(TFDailyItem*)object;


@property NSUInteger pageIndex;


@end
