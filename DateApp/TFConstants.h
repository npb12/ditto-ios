//
//  TFConstants.h
//  TIFF
//
//  Created by Rhonda DeVore on 3/11/16.
//  Copyright © 2016 Silverpine Software. All rights reserved.
//


#ifndef UUDebugLog
#ifdef DEBUG
#define UUDebugLog(fmt, ...)
#else
#define UUDebugLog(fmt, ...)
#endif
#endif



#ifndef TFDebugLog
#ifdef DEBUG
#define TFDebugLog(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
#else
#define TFDebugLog(fmt, ...)
#endif
#endif



#ifndef TFConstants_h
#define TFConstants_h


#define commaString @", "
#define newLineString @"\n"

#define genreSectionTitle @"Genre + Interests"
#define countrySectionTitle @"Country"
#define programmeSectionTitle @"Programme"




#define filmShowingIdKey @"filmShowingId"

typedef NS_OPTIONS(NSUInteger, TFFilmShowingOptions) {
    TFFilmShowingOptionsNone    = 0,        //0
    TFFilmShowingOptionsCC      = 1 << 0,   //1
    TFFilmShowingOptionsIMAX    = 1 << 1,   //2
    TFFilmShowingOptions3D      = 1 << 2,   //4
    TFFilmShowingOptions35MM    = 1 << 3,   //8
    TFFilmShowingOptionsPress   = 1 << 4,   //16
    TFFilmShowingOptionsAll     = 1 << 5    //32
};


typedef NS_ENUM(NSUInteger, MPAARating) {
    MPAARatingG    = 0,
    MPAARatingPG   = 1,
    MPAARatingPG13 = 2,
    MPAARatingR    = 4,
    MPAARatingNC17 = 8
};


#define MPAARatingToString(rating) [@[@"G",@"PG",@"PG-13", @"R", @"NC 17"] objectAtIndex:rating]
#define MPAARatingFromString(rating) [[@{@"G":@(0),@"PG":@(1),@"PG-13":@(2),@"R":@(4),@"NC 17":@(8)} valueForKey:rating] integerValue]











#define TFCellClassNameFromCellType(celltype) [@[@"TFFilmListTableCell",@"TFFilmListTableCell",@"TFCategoryTableCell",@"TFCategoryCollectionCell",@"TFDayHeaderTableCell",@"TFDayTableCell",@"TFDateCollectionCell",@"TFDateCollectionCell",@"TFDateCollectionCell",@"TFDateCollectionCell",@"TFDateCollectionCell",@"TFDailyTableCell",@"TFDailyCollectionCell",@"TFFilterHeader",@"TFFilterCell"] objectAtIndex:celltype]

#define TFCellTypeAsString(celltype) [@[@"TFCT_ListStandard_TC",@"TFCT_ListPlanner_TC",@"TFCT_Category_TC",@"TFCT_Category_CC",@"TFCT_ByDayHeader_TC",@"TFCT_ByDayCell_TC",@"TFCT_ByDayStyleDate_CC",@"TFCT_PlannerStyleDisabledDate_CC",@"TFCT_MapStyleDate_CC",@"TFCT_PlannerStyleDate_CC",@"TFCT_DetailStyleDate_CC",@"TFCT_Daily_TC",@"TFCT_Daily_CC",@"TFCT_Filter_TH",@"TFCT_Filter_TH"] objectAtIndex:celltype]
#endif /* TFConstants_h */
