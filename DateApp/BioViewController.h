//
//  BioViewController.h
//  DateApp
//
//  Created by Neil Ballard on 11/22/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface BioViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *bioLabel;
@property (strong, nonatomic) IBOutlet UILabel *userBioLabel;
@property (strong, nonatomic) IBOutlet UITextView *bioTextField;

@end
