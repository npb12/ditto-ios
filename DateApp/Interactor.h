//
//  Interactor.h
//  DateApp
//
//  Created by Neil Ballard on 5/25/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Interactor : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL hasStarted;
@property (nonatomic, assign) BOOL shouldFinish;

@end
