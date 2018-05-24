//
//  Messages.h
//  DateApp
//
//  Created by Neil Ballard on 4/10/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

typedef NS_ENUM(NSUInteger, message_type) {
    RECEIVED_MESSAGE                = 0,
    SENT_MESSAGE                 = 1,
};

@property (nonatomic, assign) NSInteger type;
@property (nullable, nonatomic, retain) NSString *message;
@property (nonatomic, assign) long timestamp;
@property (nonatomic, assign) BOOL unread;

@end
