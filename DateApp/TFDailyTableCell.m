//
//  TFDailyTableCell.m
//  TIFF
//
//  Created by Rhonda DeVore on 4/18/16.
//  Copyright © 2016 Silverpine Software. All rights reserved.
//

#import "Includes.h"

@interface TFDailyTableCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>


@property (nonatomic, strong) TFCellData *cellData;
@property (nonatomic, strong) NSDate *day;
@property (nonatomic, strong) NSMutableArray *films;

@property (nonatomic, strong) UIScrollView *scrollview;

@property (nonatomic, strong) TFDailyCollectionCell *current_cell;


@property (nonatomic, strong) TFHorizontalCollectionLayout *layout;


@end

@implementation TFDailyTableCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.films = [self getDailyData];
    [self updateFromCellData];
    
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
 //   doubleTapGesture.delaysTouchesBegan = YES;
    [self.collectionView addGestureRecognizer:doubleTapGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processSingleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.collectionView addGestureRecognizer:tapGesture];
    
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];

    
}


- (NSMutableArray*) getDailyData {
    
    NSMutableArray *temp_array = [NSMutableArray new];
    
    temp_array = [TFDailyItem allDailyItemsWithContext];
    
    NSArray *allDaily = [NSArray arrayWithArray:temp_array];
    NSMutableArray *allDays = [NSMutableArray new];
    
    for (TFDailyItem *d in allDaily)
    {
        [allDays addObject:[TFCellData createWithObject:d type:TFCT_Daily_CC]];
    } 
    
    
    
    [allDays addObject:[TFCellData createWithObject:@"" type:TFCT_Daily_Quote_CC]];
    
    return allDays;
}



- (void) layoutSubviews {
    [super layoutSubviews];
}




- (void) reloadCellWithImagePath:(NSString *)imagePath {
    for (TFCellData *cellData in self.films)
    {
        if ([cellData containsImageURL:imagePath])
        {
            NSIndexPath *ip = [NSIndexPath indexPathForItem:[self.films indexOfObject:cellData] inSection:0];
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [self.collectionView reloadItemsAtIndexPaths:@[ip]];
                               TFDebugLog(@"reloaded daily cell at %@", @(ip.item));
                           });
        }
    }
}

#pragma mark - TFCellFactory

+ (NSString*) reuseIdentifier {
    return @"TFDailyCellReuseIdentifier";
}

+ (CGFloat) heightWithCellData:(TFCellData *)cellData {
    return ([UIScreen mainScreen].bounds.size.height - 70 - 90);
}



- (void) updateFromCellData {
    self.collectionView.decelerationRate = 0.6;

    
    CGRect lastVisibleRect = CGRectZero;
    lastVisibleRect.size = self.bounds.size;
    
    lastVisibleRect.origin = self.cellData.preservedOffset;
    [self.collectionView scrollRectToVisible:lastVisibleRect animated:NO];
    
//    if (self.cellData.preservedOffset.x == 0)
 //   {
 //       [self.collectionView reloadData];
 //   }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.films.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TFDailyCollectionCell *cell = (TFDailyCollectionCell*)[TFCellManager collectionViewCellWithObject:[self.films objectAtIndex:indexPath.item] delegate:self collectionView:collectionView atIndexPath:indexPath];
    
    self.current_cell = cell;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(expandView:)];
    
    [cell.bottomView  addGestureRecognizer:tapGesture];

    
    
 //   if (cell.authorLabel.hidden)
 //   {
        NSString *top = [NSString stringWithFormat:@"%@/%@", @(indexPath.item + 1), @(self.films.count-1) ];//[NSString stringWithFormat:@"%02ld\n",(indexPath.item + 1)];
    
        NSMutableParagraphStyle *ps = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        ps.lineHeightMultiple = 1;
        ps.alignment = NSTextAlignmentLeft;
  /*
        NSMutableAttributedString *topAttrib = [[NSMutableAttributedString alloc] initWithString:top attributes:@{NSFontAttributeName:[TFStyle fontStyleWSM14], NSForegroundColorAttributeName:[TFStyle colorWhite], NSParagraphStyleAttributeName:ps}];
    
        [topAttrib appendAttributedString:[NSAttributedString tfDailyLineSpaceStringOfSize:6]];
        [topAttrib appendAttributedString:[NSAttributedString tfDailyLineSpaceStringOfSize:6]];
*/
    //    [topAttrib appendAttributedString:cell.middleLabel.attributedText];
    
    //    cell.middleLabel.attributedText = topAttrib;

//    }
    
    
    //here
    [self updateVisualAppearenceForCell:cell withIndex:indexPath.item andCurrentOffset:collectionView.contentOffset.x];

    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TFDailyCollectionCell *cell = (TFDailyCollectionCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    id<ProfileSegueProtocol> strongDelegate = self.delegate;
    [strongDelegate goToProfileSegue:self obj:cell.dailyItem];
}




- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [TFDailyCollectionCell sizeWithCellData:nil];
}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    /*
    if (scrollView.contentOffset.x < 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
        self.collectionView.contentOffset = CGPointMake(0, 0);
        return;
    } */
    
    
    self.cellData.preservedOffset = scrollView.contentOffset;
    NSArray *visible = [[self.collectionView indexPathsForVisibleItems] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"item" ascending:YES]]];

    for (NSIndexPath *ip in visible)
    {
        TFDailyCollectionCell *cell = (TFDailyCollectionCell*)[self.collectionView cellForItemAtIndexPath:ip];
        [self updateVisualAppearenceForCell:cell withIndex:ip.item andCurrentOffset:scrollView.contentOffset.x];
    }

    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
    
    TFDailyCollectionCell *cell = (TFDailyCollectionCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
    
    
    
    if (scrollView == cell.scrollView) {
        
        CGFloat pageHeight = cell.frame.size.height;
        int page = floor((cell.scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
        [cell.pageControl setCurrentPage:page];
        
    }else{

    float cellWidth = self.collectionView.bounds.size.width  - 10;
    
    float currentPage = self.collectionView.contentOffset.x / cellWidth;
    
    
    if (currentPage == 1) {
        [self remove:0 withscroll:scrollView];
    }
        
    }


}


-(void)remove:(int)i withscroll:(UIScrollView *)scrollView{
    
    
    [UIView animateWithDuration:0 animations:^{
        [self.collectionView performBatchUpdates:^{
            [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            [self.films removeObjectAtIndex:0];
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [self.collectionView.collectionViewLayout invalidateLayout];
        } completion:nil];
    }];
    

}


-(void)likedUser{
    
    if ([self.films count] > 1) {
        
        BOOL match = NO;
        
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];

        TFDailyCollectionCell *cell = (TFDailyCollectionCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
        
        
        
        if (cell != nil) {
            [cell showHeart];
        }
        
        //later stub
        /*
         if (cell.dailyItem.isMatch) {
         send protocol
         }else{
         if disliked/new liked
         send to server
         }
         
         */
        
        match = YES;
        
        
        [UIView animateWithDuration:0.6 animations:^{

        
        [self.collectionView performBatchUpdates:^{
            [self.films removeObjectAtIndex:0];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [self.collectionView.collectionViewLayout invalidateLayout];
        } completion:nil];
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
            
            TFDailyCollectionCell *cell = (TFDailyCollectionCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
            cell.bottomView.alpha = 1.0f;
            if (match) {
                id<MatchSegueProtocol> strongDelegate = self.matched_delegate;
                [strongDelegate goToMatchedSegue:self obj:cell.dailyItem];
            }
        }];
    }else{
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];

        TFDailyCollectionCell *cell = (TFDailyCollectionCell*) [self.collectionView cellForItemAtIndexPath:indexPath];

        if (cell != nil) {
            [cell showHeart];
        }
        
    }
}

-(void)dislikedUser{
    
    if ([self.films count] > 1) {
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
        
        
        /*
        if (hcell != nil) {
            [hcell showHeart];
        } */
        
        
  //      [UIView animateWithDuration:0.6 animations:^{
            
            
            [self.collectionView performBatchUpdates:^{
                [self.films removeObjectAtIndex:0];
                [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                [self.collectionView.collectionViewLayout invalidateLayout];
            } completion:nil];
            NSIndexPath *Path =[NSIndexPath indexPathForRow:0 inSection:0];
            
            TFDailyCollectionCell *cell = (TFDailyCollectionCell*) [self.collectionView cellForItemAtIndexPath:Path];
            cell.bottomView.alpha = 1.0f;
    //    }];
    }
    

}

- (void) processDoubleTap:(UITapGestureRecognizer *)sender
{
    [self likedUser];
    /*
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point = [sender locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        if (indexPath)
        {
            
        }
        else
        {

        }
    } */
}

- (void) processSingleTap:(UITapGestureRecognizer *)sender
{
   // [self likedUser];
    
     if (sender.state == UIGestureRecognizerStateEnded)
     {
     CGPoint point = [sender locationInView:self.collectionView];
     NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
     if (indexPath)
     {
         TFDailyCollectionCell *cell = (TFDailyCollectionCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
         
         if (cell.isExpanded) {
             [cell retractView];
         }else{
             id<ProfileSegueProtocol> strongDelegate = self.delegate;
             [strongDelegate goToProfileSegue:self obj:cell.dailyItem];
         }
         
     
     }
    }
}




- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    

    
    
}


- (void) updateVisualAppearenceForCell:(TFDailyCollectionCell*)cell withIndex:(NSInteger)itemIndex andCurrentOffset:(CGFloat)offset
{
    
    
    //standard spot:
    CGFloat cellStandardOffset = roundf((itemIndex * cell.bounds.size.width)); //this is where the cell would normally start
    CGFloat cellCurrentOffset = roundf(cell.frame.origin.x); //this is where the cell currently sits

    
    
    if (cellCurrentOffset >= cellStandardOffset)
    {
        cell.bottomView.alpha = 1.0f;
        cell.fadeBottom1.alpha = 1.0f;
        cell.dimmerView.hidden = YES;
        cell.middleLabelCenterConstraint.constant = 0;
    }
    else
    {
        cell.dimmerView.hidden = NO;
        
        CGFloat textFadeInStartPercentage = 0.25f;
        
        
        CGFloat currentDiff = cellStandardOffset - cellCurrentOffset;
        CGFloat maxDiff = cell.bounds.size.width/3;
        CGFloat percentageDiff = currentDiff/maxDiff;
        
        CGFloat alpha = 0.0f;
        CGFloat dimmerAlpha = percentageDiff;
        CGFloat middleLabelShift = ((currentDiff/maxDiff)*50);
        
        
        
        if (dimmerAlpha > 0.5f)
        {
            dimmerAlpha = 0.5f; //cap at half
        }
        
        
        
        if (percentageDiff < textFadeInStartPercentage)
        {
            //at 25%, text alpha is 0, dimmer alpha is 0.5
            //at 0 %, text alpha is 1, dimmer alpha is 0.0
            alpha = 1-( percentageDiff/textFadeInStartPercentage);
        }
        
        
        //TFDebugLog(@" alp:%@  dal:%@  perc:%@", @(alpha), @(dimmerAlpha), @(percentageDiff));

        cell.dimmerView.alpha = dimmerAlpha;
        cell.bottomView.alpha = alpha;
        cell.fadeBottom1.alpha = alpha;
        cell.middleLabelCenterConstraint.constant = middleLabelShift;
        
    }
    


    [cell layoutIfNeeded];
}



@end
