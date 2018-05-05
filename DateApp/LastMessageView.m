//
//  LastMessageView.m
//  DateApp
//
//  Created by Neil Ballard on 4/30/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

#import "LastMessageView.h"

@implementation LastMessageView


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.imgView.layer.cornerRadius = 20;
    self.imgView.layer.masksToBounds = YES;
    self.layer.cornerRadius = 14.0;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
