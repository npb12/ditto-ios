//
//  DataAccess.h
//  portal
//
//  Created by Neil Ballard on 10/9/15.
//  Copyright © 2015 Neil_appworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DataAccess : NSObject <NSCoding>


@property (nonatomic, unsafe_unretained) BOOL IsLoggedIn;
@property (nonatomic, unsafe_unretained) BOOL isProfileImageSet;
@property (nonatomic, strong) NSString *profileImage;
@property (nonatomic, unsafe_unretained) BOOL isProfileImageSet2;
@property (nonatomic, strong) NSString *profileImage2;
@property (nonatomic, unsafe_unretained) BOOL isProfileImageSet3;
@property (nonatomic, strong) NSString *profileImage3;
@property (nonatomic, unsafe_unretained) BOOL isProfileImageSet4;
@property (nonatomic, strong) NSString *profileImage4;
@property (nonatomic, strong) NSString *profileImage5;

@property (nonatomic, unsafe_unretained) BOOL isMatchImageSet;
@property (nonatomic, strong) UIImage *matchProfileImage;

@property (nonatomic, unsafe_unretained) BOOL isTaken;

@property (nonatomic, unsafe_unretained) BOOL hasMatch;

@property (nonatomic, unsafe_unretained) BOOL firstLaunch;

@property (nonatomic, unsafe_unretained) BOOL askedNotifications;
@property (nonatomic, assign) long lastMessageTime;


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


-(void)setUserID:uid;
-(NSString*)getUserID;

-(void)setUserLocation:(CLLocationCoordinate2D)location;
-(CLLocationCoordinate2D)getUserLocation;

- (BOOL)UserIsLoggedIn;
- (void)setUserLoginStatus:(BOOL)status;
- (BOOL)askedForNotifications;
- (void)setaskedForNotifications:(BOOL)status;
+ (id)singletonInstance;
- (void)persistToUserDefaults;
- (void)initUserDefaults;
-(void)setProfileImage:(NSString*)image;
-(NSString*)getProfileImage;


-(void)setProfileImage2:(NSString*)image;
-(NSString*)getProfileImage2;

-(void)setProfileImage3:(NSString*)image;
-(NSString*)getProfileImage3;

-(void)setProfileImage4:(NSString*)image;
-(NSString*)getProfileImage4;


-(void)setProfileImage5:(NSString*)image;
-(NSString*)getProfileImage5;

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
- (void)setUserHasMatch:(BOOL)status;

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


-(void)setSessionToken:(NSString*)token;

-(NSString*)getSessionToken;

- (BOOL)UserGrantedLocationPermission;

- (void)setUserGrantedLocationPermission:(BOOL)status;

- (BOOL)IsReturningUser;
- (void)setReturningUserStatus:(BOOL)status;

-(void)setLastMessage:(long)timestamp;
-(long)getLastMessage;

@end
