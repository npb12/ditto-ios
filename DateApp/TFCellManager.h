//
//  TFCellManager.h
//  TIFF
//
//  Created by Rhonda DeVore on 4/10/16.
//  Copyright © 2016 Silverpine Software. All rights reserved.
//

#import "Includes.h"
#import "TFCellData.h"
@class TFCellData,TFSectionData;



@protocol TFCollectionCellFactory <NSObject>

+ (NSString*) reuseIdentifier;
+ (CGSize) sizeWithCellData:(TFCellData*)cellData;
- (void) updateFromCellData:(TFCellData*)cellData;

@end



@interface TFCellManager : NSObject






#pragma mark - COLLECTION CELLS
+ (UICollectionViewCell*) collectionViewCellWithObject:(TFCellData*)cellData delegate:(id)delegate collectionView:(UICollectionView*)collectionView atIndexPath:(NSIndexPath*)indexPath;

+ (CGSize) sizeForCollectionViewCellWithObject:(TFCellData*)cellData collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

+ (UIEdgeInsets) edgeInsetsForCollectionViewCellWithObject:(TFCellData*)cellData collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

+ (CGFloat) minimumLineSpacingForCollectionViewCellWithObject:(TFCellData*)cellData collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;


+ (CGFloat) minimumInteritemSpaceingWithObject:(TFCellData*)cellData collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

+ (CGSize) referenceSizeForHeaderWithObject:(TFCellData*)cellData collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;

+ (CGSize) referenceSizeForFooterWithObject:(TFCellData*)cellData collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

@end

