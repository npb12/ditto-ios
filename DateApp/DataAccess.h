//
//  DataAccess.h
//  portal
//
//  Created by Neil Ballard on 10/9/15.
//  Copyright © 2015 Neil_appworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface DataAccess : NSObject <NSCoding>


@property (nonatomic, unsafe_unretained) BOOL IsLoggedIn;
@property (nonatomic, unsafe_unretained) BOOL isProfileImageSet;
@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic, unsafe_unretained) BOOL isProfileImageSet2;
@property (nonatomic, strong) UIImage *profileImage2;
@property (nonatomic, unsafe_unretained) BOOL isProfileImageSet3;
@property (nonatomic, strong) UIImage *profileImage3;
@property (nonatomic, unsafe_unretained) BOOL isProfileImageSet4;
@property (nonatomic, strong) UIImage *profileImage4;

@property (nonatomic, unsafe_unretained) BOOL isMatchImageSet;
@property (nonatomic, strong) UIImage *matchProfileImage;

@property (nonatomic, unsafe_unretained) BOOL isTaken;
/*
@property (nonatomic, strong) OAuthToken *accessToken;
@property (nonatomic, strong) NSString *currentURLforAPI;
@property (nonatomic, strong) NSString *baseURIforAPI;

//OAuth
-(OAuthToken*)retrieveOAuthAccessToken;
-(void)setOAuthAccessToken:(OAuthToken*)token;
-(BOOL)oAuthAccessTokenExists; */

//URL
+(NSString*)url;
+(NSString*)uri;
-(NSString*)apiCurrentURL;
- (void)setAPICurrentURL:(NSString*)url;

// User status
- (BOOL)UserIsTaken;
- (void)setUserTakenStatus:(BOOL)status;



- (BOOL)UserIsLoggedIn;
- (void)setUserLoginStatus:(BOOL)status;
+ (id)singletonInstance;
- (void)persistToUserDefaults;
- (void)initUserDefaults;
-(void)setProfileImage:(UIImage*)image;
- (void)setProfileImageStatus:(BOOL)status;
- (BOOL)ProfileImageIsSet;
-(UIImage*)getProfileImage;



-(void)setProfileImage2:(UIImage*)image;
- (void)setProfileImageStatus2:(BOOL)status;
- (BOOL)ProfileImageIsSet2;
-(UIImage*)getProfileImage2;

-(void)setProfileImage3:(UIImage*)image;
- (void)setProfileImageStatus3:(BOOL)status;
- (BOOL)ProfileImageIsSet3;
-(UIImage*)getProfileImage3;

-(void)setProfileImage4:(UIImage*)image;
- (void)setProfileImageStatus4:(BOOL)status;
- (BOOL)ProfileImageIsSet4;
-(UIImage*)getProfileImage4;

-(UIImage*)getProfileImage5;

- (BOOL)LoggedInWithFB;

- (void)setisLoggedInWithFB:(BOOL)status;

-(void)setFacebook:(NSString*)network;
-(NSString*)getFacebook;


-(void)setName:(NSString*)name;
-(NSString*)getName;

-(void)setBirthday:(NSString*)bday;
-(NSString*)getBirthday;

-(void)setAge:(NSString*)age;
-(NSString*)getAge;

-(void)setGender:(NSString*)gender;
-(NSString*)getGender;

//Matches data
- (BOOL)UserHasMatch;
- (void)setUserMatchStatus:(BOOL)status;

-(void)setMatchName:(NSString*)name;
-(NSString*)getMatchName;

- (void)setMatchProfileImageStatus:(BOOL)status;
- (BOOL)matchImageIsSet;
-(UIImage*)getMatchImage;
-(void)setMatchProfileImage:(UIImage*)image;

- (void)saveOutgoingAvatarSetting:(BOOL)value;
- (BOOL)outgoingAvatarSetting;

- (void)saveIncomingAvatarSetting:(BOOL)value;
- (BOOL)incomingAvatarSetting;




-(void)setBio:(NSString*)bio;

-(NSString*)getBio;

-(void)setToken:(NSString*)token;

-(NSString*)getToken;


- (BOOL)IsInitialUser;
- (void)setInitialUserStatus:(BOOL)status;


@end
