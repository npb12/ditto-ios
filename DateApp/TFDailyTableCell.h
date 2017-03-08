//
//  TFDailyTableCell.h
//  TIFF
//
//  Created by Rhonda DeVore on 4/18/16.
//  Copyright © 2016 Silverpine Software. All rights reserved.
//

#import "Includes.h"

@protocol ProfileSegueProtocol;
@protocol MatchSegueProtocol;



@interface TFDailyTableCell : UIView

- (void) reloadCellWithImagePath:(NSString*)imagePath;


-(void)likedUser;
-(void)dislikedUser;


@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, weak) id<ProfileSegueProtocol> delegate;
@property (nonatomic, weak) id<MatchSegueProtocol> matched_delegate;


@end

@protocol ProfileSegueProtocol <NSObject>

-(void)goToProfileSegue:(id)sender obj:(TFDailyItem*)object;

@end

@protocol MatchSegueProtocol <NSObject>

-(void)goToMatchedSegue:(id)sender obj:(TFDailyItem*)object;

@end
