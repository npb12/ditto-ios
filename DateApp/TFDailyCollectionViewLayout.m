//
//  TFDailyCollectionViewLayout.m
//  TIFF
//
//  Created by Rhonda DeVore on 5/21/16.
//  Copyright © 2016 Silverpine Software. All rights reserved.
//

#import "Includes.h"

@implementation TFDailyCollectionViewLayout

- (CGSize)collectionViewContentSize
{
    return CGSizeMake([self cellWidth]*[self.collectionView numberOfItemsInSection:0] + [self sectionOffset] + 10, self.collectionView.bounds.size.height);
}



@end
