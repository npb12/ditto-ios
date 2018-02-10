//
//  SecondChanceCell.m
//  DateApp
//
//  Created by Neil Ballard on 2/6/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

#import "SecondChanceCell.h"

@implementation SecondChanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius =  self.imgWH.constant / 2;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self setHighlighted:NO];
    
    self.imgView.image = nil;
    self.nameLabel.text = @"";
}

@end
