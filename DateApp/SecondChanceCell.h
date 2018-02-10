//
//  SecondChanceCell.h
//  DateApp
//
//  Created by Neil Ballard on 2/6/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondChanceCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgWH;

@end
