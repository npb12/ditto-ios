//
//  DASocket.h
//  DateApp
//
//  Created by Neil Ballard on 4/2/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataAccess.h"
@import SocketIO;
#import "Messages.h"

@interface DASocket : NSObject

@property (strong, nonatomic) SocketIOClient *socket;


+ (instancetype)sharedInstance;
-(void)disconnectSocket;
-(void)sendMessage:(NSString*)message;
@end
