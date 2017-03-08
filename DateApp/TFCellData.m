//
//  TFCellData.m
//  TIFF
//
//  Created by Rhonda DeVore on 4/26/16.
//  Copyright © 2016 Silverpine Software. All rights reserved.
//

#import "Includes.h"

@interface TFCellData ()

@end

@implementation TFCellData

+ (instancetype) createObject:(id)object type:(TFCellType)type
{
    TFCellData *cellData = [TFCellData new];
    cellData.dataObject = object;
    cellData.cellType = type;
    cellData.preservedOffset = CGPointZero;
    return cellData;
}


+ (instancetype) createWithObject:(id)object type:(TFCellType)type
{
    TFCellData *cellData = [TFCellData createObject:object type:type];
    
    
    NSMutableArray *ma = [NSMutableArray new];

        
    @try {
        [ma addObject:[TFCellData createObject:object type:type]];
    } @catch (NSException *exception) {}
        
    
    if (ma.count < 1)
    {
        ma = nil;
    }
    
    
    
    cellData.rowData = ma;
    
    return cellData;
}


- (BOOL) containsImageURL:(NSString *)imageURL
{
    if (self.rowData)
    {
        for (TFCellData *cd in self.rowData)
        {
            if ([cd containsImageURL:imageURL])
            {
                return YES;
            }
        }
    }

    
    return NO;
}









@end
