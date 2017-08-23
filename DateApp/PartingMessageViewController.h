//
//  PartingMessageViewController.h
//  DateApp
//
//  Created by Neil Ballard on 3/17/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PartingMessageDelegate <NSObject>
- (void)sendMessageBack:(NSString *)message;
@end

@interface PartingMessageViewController : UIViewController


typedef NS_ENUM(NSUInteger, parting_type) {
    DROP_CURRENT                = 0,
    DROP_SWAP                 = 1
};

@property (nonatomic, weak) id<PartingMessageDelegate> delegate;

@property (nonatomic, assign) NSInteger alternate_id;


@end
