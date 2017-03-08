//
//  TFHorizontalCollectionLayout.m
//  TIFF
//
//  Created by Ryan DeVore on 8/9/16.
//  Copyright © 2016 Silverpine Software. All rights reserved.
//

#import "Includes.h"

@implementation TFHorizontalCollectionLayout

- (CGFloat) sectionOffset
{
    return 0.0f;
}

- (CGFloat) cellWidth
{
    return self.collectionView.bounds.size.width - [self sectionOffset] - 10;
}





- (CGSize)collectionViewContentSize
{
    return CGSizeMake([self cellWidth]*[self.collectionView numberOfItemsInSection:0] + [self sectionOffset] + 20, self.collectionView.bounds.size.height);
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    
    NSArray *indexPaths = [self indexPathsForItemsInRect:rect];
    NSMutableArray *attrElements = [NSMutableArray new];
    for (NSIndexPath *indexPath in indexPaths)
    {
        [attrElements addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    

    
    //here
    return attrElements;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat offsetX = indexPath.item * [self cellWidth];//self.collectionView.bounds.size.width;
    CGRect frame;
    frame.origin.x = offsetX+[self sectionOffset];
    frame.origin.y = 0;
    frame.size = self.collectionView.bounds.size;
    frame.size.width = [self cellWidth];
    attr.frame = frame;
    
    //Sliding
    CGAffineTransform tryOne = CGAffineTransformIdentity;
    float shift = 0;
   
    if (offsetX > self.collectionView.contentOffset.x)
    {
        shift = -(offsetX-self.collectionView.contentOffset.x)/3;
        tryOne = CGAffineTransformTranslate(tryOne, shift, 0);
    }

    attr.transform = tryOne;
    attr.zIndex = -indexPath.item;
    //here
    return attr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray *)indexPathsForItemsInRect:(CGRect)rect
{
    float cellWidth = [self cellWidth];
    int startIndex = MAX(rect.origin.x / cellWidth, 0);
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (int i = startIndex; i < [self.collectionView numberOfItemsInSection:0] && ((i - 1) * cellWidth) < (self.collectionView.contentOffset.x+20); i++)
    {
        //here
        [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    
    
    return indexPaths;
}


- (CGPoint) targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGPoint finalContentOffset = proposedContentOffset;
    
    float cellWidth = [self cellWidth];
    float targetPage = (proposedContentOffset.x)/cellWidth;
    float currentPage = self.collectionView.contentOffset.x / cellWidth;
    
    
    if (velocity.x >= 0)
    {
        targetPage = ceil(targetPage);
        if (targetPage - currentPage > 1) {
            targetPage = targetPage - 1;
        }
        
        
    }
    else
    {
        targetPage = floor(targetPage);
    }
    
    //int pageScrollMax = 2;
    int pagesToAdjust = (int)(targetPage - currentPage);
//    if (pagesToAdjust < -pageScrollMax)
//    {
//        pagesToAdjust = -pageScrollMax;
//    }
//    else if (pagesToAdjust > pageScrollMax)
//    {
//        pagesToAdjust = pageScrollMax;
//    }
    
    float proposedOffsetDelta = proposedContentOffset.x - self.collectionView.contentOffset.x;
    
    finalContentOffset.x = targetPage * (cellWidth);
    
    float finalOffsetDelta = finalContentOffset.x - self.collectionView.contentOffset.x;
    
    TFDebugLog(@"%@ - contentSize.width: %@, currentPage: %@, proposedContentOffset.x: %@, proposedOffsetDelta: %@, finalOffsetDelta: %@, velocity: %@, cellWidth: %@, targetPage: %@, pagesToAdjust: %@, targetOffset.x: %@",
               [self class], @(self.collectionView.contentSize.width), @(currentPage),  @(proposedContentOffset.x),
               @(proposedOffsetDelta), @(finalOffsetDelta), @(velocity.x), @(cellWidth),
               @(targetPage), @(pagesToAdjust), @(finalContentOffset.x));
    
    return finalContentOffset;
}

@end
