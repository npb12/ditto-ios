//
//  TFCellData.h
//  TIFF
//
//  Created by Rhonda DeVore on 4/26/16.
//  Copyright © 2016 Silverpine Software. All rights reserved.
//

#import "Includes.h"
@class TFDailyItem;

typedef NS_ENUM(NSUInteger, TFCellType) {

    TFCT_Daily_CC                       = 13,
    TFCT_Daily_Quote_CC                 = 14,

};




@interface TFCellData : NSObject
@property (nonatomic, strong) id dataObject;
@property (nonatomic, assign) NSUInteger cellType;
@property (nonatomic, strong) NSMutableArray *rowData;
@property (nonatomic, assign) CGPoint preservedOffset;

//+ (instancetype) createWithObject:(id)object type:(TFCellType)type rows:(NSMutableArray *)rowDataObjects rowType:(TFCellType)rowCellType;

+ (instancetype) createWithObject:(id)object type:(TFCellType)type;



- (BOOL) containsImageURL:(NSString*)imageURL;




//+ (void) refreshVisibleTableRows:(NSString*)imagePath inTable:(UITableView*)tableView withData:(NSArray*)tableData;
//+ (void) refreshVisibleTableRowsCollectionChildren:(NSString*)imagePath inTable:(UITableView*)tableView withData:(NSArray*)tableData;

@end
