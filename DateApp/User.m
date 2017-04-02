//
//  User.m
//  DateApp
//
//  Created by Neil Ballard on 3/11/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "User.h"

@implementation User

-(NSMutableArray*)genData{
    
    NSMutableArray *array = [NSMutableArray new];
    
    User *user1 = [User new];
    User *user2 = [User new];
    User *user3 = [User new];
    User *user4 = [User new];
    User *user5 = [User new];

    
    user1.user_id = 1;
    user2.user_id = 2;
    user3.user_id = 3;
    user4.user_id = 4;
    user5.user_id = 5;
    
    user1.name= @"Neil";
    user2.name = @"Steve";
    user3.name = @"Ally";
    user4.name = @"Jenna";
    user5.name = @"Tom";
    
    user1.age= @"25";
    user2.age = @"21";
    user3.age = @"32";
    user4.age = @"24";
    user5.age = @"25";

    user1.bio = @"Some text about me and all that I do";
    user2.bio = @"Some text about me and all that I do";
    user3.bio = @"Some text about me and all that I do";
    user4.bio = @"Some text about me and all that I do";
    user5.bio = @"Some text about me and all that I do";

    
    user1.edu = @"Florida State University";
    user3.edu = @"University of Central FLorida";
    user3.edu = @"University South FLorida";

    
    user1.job = @"Software Engineer";
    user5.job = @"Waste Management";

    
    user1.imageRemoteUrl = @"https://scontent.ftpa1-2.fna.fbcdn.net/v/t1.0-9/15078923_10206610339771834_4553024057016540900_n.jpg?oh=326d6c0396466df61831fd8d3368c45f&oe=59271E11";
    user2.imageRemoteUrl = @"https://scontent.xx.fbcdn.net/v/t1.0-1/16473252_397423153928780_1502714090830676351_n.jpg?oh=61aa200ceb5cc49759b658dfc50bd8d7&oe=5942288D";
    user3.imageRemoteUrl = @"https://scontent.xx.fbcdn.net/v/t1.0-1/16473252_397423153928780_1502714090830676351_n.jpg?oh=61aa200ceb5cc49759b658dfc50bd8d7&oe=5942288D";
    user4.imageRemoteUrl = @"https://scontent.xx.fbcdn.net/v/t1.0-1/16473252_397423153928780_1502714090830676351_n.jpg?oh=61aa200ceb5cc49759b658dfc50bd8d7&oe=5942288D";
    user5.imageRemoteUrl = @"https://scontent.xx.fbcdn.net/v/t1.0-1/16473252_397423153928780_1502714090830676351_n.jpg?oh=61aa200ceb5cc49759b658dfc50bd8d7&oe=5942288D";
    
    user1.pics = [NSMutableArray new];
    user2.pics = [NSMutableArray new];
    user3.pics = [NSMutableArray new];
    user4.pics = [NSMutableArray new];
    user5.pics = [NSMutableArray new];
    
    [user1.pics addObject:user1.imageRemoteUrl];
    [user1.pics addObject:user1.imageRemoteUrl];
    [user2.pics addObject:user2.imageRemoteUrl];
    [user2.pics addObject:user2.imageRemoteUrl];
    [user2.pics addObject:user2.imageRemoteUrl];
    [user3.pics addObject:user3.imageRemoteUrl];
    [user4.pics addObject:user3.imageRemoteUrl];
    [user5.pics addObject:user3.imageRemoteUrl];

    [array addObject:user1];
    [array addObject:user2];
    [array addObject:user3];
    [array addObject:user4];
    [array addObject:user5];

    
    return array;
    
}

@end
