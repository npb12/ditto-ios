//
//  MatchMessages.h
//  DateApp
//
//  Created by Neil Ballard on 5/18/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataAccess.h"
#import "Message.h"

@interface MatchMessages : NSObject

+ (MatchMessages*) fromDictionary:(NSDictionary*)dictionary;
+ (MatchMessages*) lastMessage;
- (NSDictionary*) toDictionary;
+ (void) saveAsLastMessage:(MatchMessages*)message;
+ (void) removeLastMessage;
@property (nonatomic, strong) Message *lastMessage;

@end
