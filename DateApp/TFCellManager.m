//
//  TFCellManager.m
//  TIFF
//
//  Created by Rhonda DeVore on 4/10/16.
//  Copyright © 2016 Silverpine Software. All rights reserved.
//

#import "Includes.h"

@implementation TFCellManager

#pragma mark - TABLE CELLS


+ (CGFloat) heightForCellWithObject:(TFCellData*)cellData
{

    return ([UIScreen mainScreen].bounds.size.height - 70 - 90);

}



#pragma mark - COLLECTION CELLS
+ (UICollectionViewCell*) collectionViewCellWithObject:(TFCellData *)cellData delegate:(id)delegate collectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath
{


            

            TFDailyCollectionCell *cell = (TFDailyCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[TFDailyCollectionCell reuseIdentifier] forIndexPath:indexPath];
           // cell.delegate = delegate;
            [cell updateFromCellData:cellData];
            return cell;

    
}

+ (CGSize) sizeForCollectionViewCellWithObject:(TFCellData*)cellData collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return [TFDailyCollectionCell sizeWithCellData:cellData];


}

+ (UIEdgeInsets) edgeInsetsForCollectionViewCellWithObject:(TFCellData*)cellData collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    

            return UIEdgeInsetsZero;

}

+ (CGFloat) minimumLineSpacingForCollectionViewCellWithObject:(TFCellData*)cellData collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


+ (CGFloat) minimumInteritemSpaceingWithObject:(TFCellData*)cellData collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    switch (cellData.cellType)
    {

        case TFCT_Daily_CC:
        case TFCT_Daily_Quote_CC:
        {
            return 0;
            break;
        }
            
        default:
        {
            return 0;
            break;
        }
    }

}

+ (CGSize) referenceSizeForHeaderWithObject:(TFCellData*)cellData collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

+ (CGSize) referenceSizeForFooterWithObject:(TFCellData*)cellData collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}



@end
