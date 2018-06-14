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

enum PartingType {
    INAPPROPRIATE=1,
    CHEMISTRY,
    RESPONSE_TIME,
    INTEREST,
    NO_REASON,
};

@property (nonatomic,assign) enum PartingType currentType;

@property (nonatomic, weak) id<PartingMessageDelegate> delegate;

@property (nonatomic, assign) NSInteger alternate_id;
@property (strong, nonatomic) IBOutlet UIImageView *inapropriateCheck;
@property (strong, nonatomic) IBOutlet UIImageView *chemistryCheck;
@property (strong, nonatomic) IBOutlet UIImageView *responseCheck;
@property (strong, nonatomic) IBOutlet UIImageView *interestCheck;
@property (strong, nonatomic) IBOutlet UIImageView *noReasonCheck;


@end
