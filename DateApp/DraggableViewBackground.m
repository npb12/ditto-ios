//
//  DraggableViewBackground.m
//  Created by Neil Ballard on 10/9/15.
//  Copyright © 2015 Neil_appworld. All rights reserved.
//

#import "DraggableViewBackground.h"

@interface DraggableViewBackground()<HasMatchDelegate, ProfileProtocol>

@end

@implementation DraggableViewBackground{
    NSInteger cardsLoadedIndex;
    NSMutableArray *loadedCards;
    
 //   UIButton* menuButton;
 //   UIButton* messageButton;
    UIButton* checkButton;
    UIButton* xButton;
    CGFloat parentHeight;
    NSInteger totalCards;
}

static const int MAX_BUFFER_SIZE = 2;

@synthesize userCards;
@synthesize allCards;


-(void)createViewWithUsers:(NSMutableArray*)users withHeight:(CGFloat)height{
    userCards = users;
    totalCards = [users count];
    parentHeight = height;
  //  userCards = [[NSArray alloc]initWithObjects:@"first",@"second",@"third",@"fourth",@"last", nil]; //%%% placeholder for card-specific information
    loadedCards = [[NSMutableArray alloc] init];
    allCards = [[NSMutableArray alloc] init];
    cardsLoadedIndex = 0;
    [self loadCards];
    self.userInteractionEnabled = YES;
    
    if ([[DataAccess singletonInstance] UserHasMatch])
    {
        self.userInteractionEnabled = NO;
    }
    
    if ([userCards count] > 0)
    {
        self.labelTop.constant = parentHeight * 0.78;
        [self.stackLabels setHidden:NO];
    }
    
    [self setCardCount];
}


-(void)setCardCount
{
    NSInteger count = totalCards;
    
    if ([userCards count] > 0)
    {
        [self.stackLabels setAlpha:0.9];
        
        UIFont *countFont = [UIFont fontWithName:@"RooneySansLF-Medium" size:22.0];
        UIFont *labelFont = [UIFont fontWithName:@"RooneySansLF-Regular" size:16.0];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];

        NSString *countStr = [NSString stringWithFormat:@"%ld ", count];

        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:countStr attributes:@{NSFontAttributeName: countFont}]];
        
        if (count == 1)
        {
            [attrString appendAttributedString:[[NSAttributedString alloc] initWithString: @"card remaining" attributes:@{NSFontAttributeName: labelFont}]];
        }
        else
        {
            [attrString appendAttributedString:[[NSAttributedString alloc] initWithString: @"cards remaining" attributes:@{NSFontAttributeName: labelFont}]];
        }
        
        [UIView animateWithDuration:0.2
                         animations:^{
                                self.cardsLabel.attributedText = attrString;
                         }];
        
        self.cardsLabel.attributedText = attrString;
    }
    else
    {
        [self.stackLabels setAlpha:0.0];
    }
}


-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    
    CGFloat CARD_HEIGHT = 0; //%%% height of the draggable card
    CGFloat CARD_WIDTH = 0;
    
    CGFloat pad = 0, x_pad;

    
    NSLog(@"%ld", (long)index);
        pad = (parentHeight * 0.05) / 2;
        x_pad = 20;
    
    CARD_HEIGHT = parentHeight * 0.73;
    CARD_WIDTH = self.frame.size.width - 40;

    
    User *user = [userCards objectAtIndex:index];
    
    DraggableView *draggableView;
    
    if (index == 0)
    {
        draggableView = [[DraggableView alloc] initWithUser:user viewFrame:CGRectMake(x_pad, pad, CARD_WIDTH, CARD_HEIGHT)];
    }
    else
    {
        draggableView = [[DraggableView alloc] initWithUser:user viewFrame:CGRectMake(x_pad, parentHeight * 0.86, CARD_WIDTH, CARD_HEIGHT)];
      //  [draggableView showBlur];
        [draggableView setUserInteractionEnabled:NO];
    }
    

    draggableView.noswipe_delegate = self;
    draggableView.delegate = self;
    draggableView.profile_delegate = self;
    return draggableView;
}

//%%% loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards
{
    if([userCards count] > 0) {
        NSInteger numLoadedCardsCap =(([userCards count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[userCards count]);
        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen

        //%%% loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "userCards" with your own array of data
        for (int i = 0; i<[userCards count]; i++) {
            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allCards addObject:newCard];
            
            if (i<numLoadedCardsCap) {
                //%%% adds a small number of cards to be loaded
                [loadedCards addObject:newCard];
            }
        }
        
        //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
        // are showing at once and clogging a ton of data
        
        
        //this method here -- instead of "belowSubview", position the view Ybelow
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i>0) {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
               // [self addSubview:[loadedCards objectAtIndex:i -]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
        }
    }
}

#warning include own action here!
//%%% action called when the card goes to the left.
// This should be customized with your own action
-(void)cardSwipedLeft:(UIView *)card;
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    totalCards--;
    
    if ([loadedCards count] > 0)
    {
        [self bringNextCardUp];
    }
    else
    {
        [self.stackLabels setAlpha:0.0];
    }
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
}

//%%% action called when the card goes to the right.
// This should be customized with your own action
-(void)cardSwipedRight:(UIView *)card
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    totalCards--;
    
    if ([loadedCards count] > 0)
    {
        [self bringNextCardUp];
    }
    else
    {
        [self.stackLabels setAlpha:0.0];
    }
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    
  //  id<MatchSegueProtocol> strongDelegate = self.matched_delegate;
  //  [strongDelegate goToMatchedSegue:self obj:nil];

}


-(void)bringNextCardUp
{
    DraggableView *view = [loadedCards objectAtIndex:0];
 //   [view removeBlur];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         CGFloat pad = (parentHeight * 0.05) / 2;
         CGFloat x_pad = 20;
         
         CGFloat CARD_HEIGHT = parentHeight * 0.73;
         CGFloat CARD_WIDTH = self.frame.size.width - 40;
         
         view.frame = CGRectMake(x_pad, pad, CARD_WIDTH, CARD_HEIGHT);
         [self setCardCount];
         [view layoutIfNeeded];
         
     } completion:^(BOOL finished)
     {
         [view setUserInteractionEnabled:YES];
     }];
}

-(void)checkEmpty
{
    if (totalCards == 0)
    {
        [self cardsEmptyAction];
    }
}

-(void)cardsEmptyAction
{
   // [self.emptyLabel setAlpha:1.0];
   // [self.emptyLabel2 setAlpha:1.0];
    [self.stackLabels setAlpha:0.0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setLocationObserver" object:nil userInfo:nil];
}



//%%% when you hit the right button, this is called and substitutes the swipe
-(void)swipeRight
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
}

//%%% when you hit the left button, this is called and substitutes the swipe
-(void)swipeLeft
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(UIColor*)grayColor{
    
    return [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
}

-(UIColor*)titleColor{
    
    return [UIColor colorWithRed:0.20 green:0.80 blue:1.00 alpha:1.0];
}


-(UIColor*)backgroundColor{
    
    return [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
    
    
}

//

-(UIColor*)lineColor
{
    return [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];
}

-(void)likedCurrent:(BOOL)option{
    DraggableView *dragView = [loadedCards firstObject];
    if (option)
    {
        [dragView rightClickAction];
    }
    else
    {
        [dragView leftClickAction];
    }
}

-(void)noSwipingAlert{
    id<NoSwipeProtocol> strongDelegate = self.noswipe_delegate;
    [strongDelegate noSwipingAlert];
}

-(void)profileSelected:(User *)user{
    id<SelectedProfileProtocol> strongDelegate = self.profile_delegate;
    [strongDelegate selectedProfile:user];
}


-(void)updateUnmatch
{
    [self setUserInteractionEnabled:YES];
    
    for (int i = 0; i<[loadedCards count]; i++)
    {
        [[loadedCards objectAtIndex:i] updateUnmatch];
    }
}

-(void)updateMatch
{
    [self setUserInteractionEnabled:NO];
    
    for (int i = 0; i<[loadedCards count]; i++)
    {
        [[loadedCards objectAtIndex:i] updateMatch];
    }

}

-(NSInteger)getTotalCardsCount
{
    return totalCards;
}


@end
