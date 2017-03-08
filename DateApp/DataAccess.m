//
//  DataAccess.m
//  portal
//
//  Created by Neil Ballard on 10/9/15.
//  Copyright © 2015 Neil_appworld. All rights reserved.
//

#import "DataAccess.h"


static NSString * const kSettingIncomingAvatar = @"kSettingIncomingAvatar";
static NSString * const kSettingOutgoingAvatar = @"kSettingOutgoingAvatar";

@implementation DataAccess

#pragma mark - Current URL Methods

/*
+ (NSString*)url {
    DataAccess *data = [DataAccess singletonInstance];
    return data.currentURLforAPI;
}

+ (NSString*)uri {
    DataAccess *data = [DataAccess singletonInstance];
    return data.baseURIforAPI;
}

- (NSString*)apiBaseURI {
    DataAccess *data = [DataAccess singletonInstance];
    return data.baseURIforAPI;
}

- (NSString*)apiCurrentURL {
    DataAccess *data = [DataAccess singletonInstance];
    return data.currentURLforAPI;
}

- (void)setAPICurrentURL:(NSString*)api {
    NSURL *url = [NSURL URLWithString:api];
    DataAccess *data = [DataAccess singletonInstance];
    
    data.currentURLforAPI = [url absoluteString];
    data.baseURIforAPI = [NSString stringWithFormat:@"%@://%@", url.scheme, url.host];
    
    [data persistToUserDefaults];
}

#pragma mark - Access Token methods

- (OAuthToken*)retrieveOAuthAccessToken {
    DataAccess *data = [DataAccess singletonInstance];
    return data.accessToken;
}

- (void)setOAuthAccessToken:(OAuthToken *)token {
    DataAccess *data = [DataAccess singletonInstance];
    [data setAccessToken:token];
    [data persistToUserDefaults];
}

- (BOOL)oAuthAccessTokenExists {
    DataAccess *data = [DataAccess singletonInstance];
    
    if(nil != data.accessToken) {
        return YES;
    } else {
        return NO;
    }
}
*/
#pragma mark - Account Methods

- (BOOL)UserIsLoggedIn {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"]) {
        return YES;
    }
    return NO;
}

- (void)setUserLoginStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"isLoggedIn"];
}

- (BOOL)IsInitialUser {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isInitialUser"]) {
        return YES;
    }
    return NO;
}

- (void)setInitialUserStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"isInitialUser"];
}


//match data
- (BOOL)UserHasMatch {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"hasMatch"]) {
        return YES;
    }
    return NO;
}

- (void)setUserMatchStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"hasMatch"];
}


- (void)setMatchProfileImageStatus:(BOOL)status {
    DataAccess *Data = [DataAccess singletonInstance];
    Data.isMatchImageSet = status;
    [Data persistToUserDefaults];
}

- (BOOL)matchImageIsSet {
    DataAccess *Data = [DataAccess singletonInstance];
    return Data.isMatchImageSet;
}

-(void)setMatchProfileImage:(UIImage*)image{
    
    DataAccess *Data = [DataAccess singletonInstance];
    Data.matchProfileImage = image;
    [Data persistToUserDefaults];
    
    
}

-(UIImage*)getMatchImage{
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"matchImage"];
    UIImage* image = [UIImage imageWithData:imageData];
    return image;
    
}


-(void)setMatchName:(NSString*)name{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"matchName"];
    
}

-(NSString*)getMatchName{
    
    NSString *name = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"matchName"];
    
    return name;
}


//User Data

-(void)saveOutgoingAvatarSetting:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kSettingOutgoingAvatar];
}

- (BOOL)outgoingAvatarSetting
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingOutgoingAvatar];
}

- (void)saveIncomingAvatarSetting:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kSettingIncomingAvatar];
}

- (BOOL)incomingAvatarSetting
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingIncomingAvatar];
}


- (void)setProfileImageStatus:(BOOL)status {
    DataAccess *Data = [DataAccess singletonInstance];
    Data.isProfileImageSet = status;
    [Data persistToUserDefaults];
}

- (BOOL)ProfileImageIsSet {
    DataAccess *Data = [DataAccess singletonInstance];
    return Data.isProfileImageSet;
}

- (void)setProfileImageStatus2:(BOOL)status {
    DataAccess *Data = [DataAccess singletonInstance];
    Data.isProfileImageSet = status;
    [Data persistToUserDefaults];
}

- (BOOL)ProfileImageIsSet2 {
    DataAccess *Data = [DataAccess singletonInstance];
    return Data.isProfileImageSet;
}

- (void)setProfileImageStatus3:(BOOL)status {
    DataAccess *Data = [DataAccess singletonInstance];
    Data.isProfileImageSet = status;
    [Data persistToUserDefaults];
}

- (BOOL)ProfileImageIsSet3 {
    DataAccess *Data = [DataAccess singletonInstance];
    return Data.isProfileImageSet;
}

- (void)setProfileImageStatus4:(BOOL)status {
    DataAccess *Data = [DataAccess singletonInstance];
    Data.isProfileImageSet = status;
    [Data persistToUserDefaults];
}

- (BOOL)ProfileImageIsSet4 {
    DataAccess *Data = [DataAccess singletonInstance];
    return Data.isProfileImageSet;
}


- (void)setisLoggedInWithFB:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"LoggedInWithFB"];
}

- (BOOL)LoggedInWithFB {
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"LoggedInWithFB"]) {
        return YES;
    }
    
    return NO;
}





-(UIImage*)getProfileImage{
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileImage"];
    UIImage* image = [UIImage imageWithData:imageData];
    return image;
    
}


-(UIImage*)getProfileImage2{
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileImage2"];
    UIImage* image = [UIImage imageWithData:imageData];
    return image;
    
}



-(UIImage*)getProfileImage3{
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileImage3"];
    UIImage* image = [UIImage imageWithData:imageData];
    return image;
    
}


-(UIImage*)getProfileImage4{
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileImage4"];
    UIImage* image = [UIImage imageWithData:imageData];
    return image;
    
}

-(UIImage*)getProfileImage5{
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileImage5"];
    UIImage* image = [UIImage imageWithData:imageData];
    return image;
    
}

#pragma - user info

-(void)setName:(NSString*)name{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"username"];
    
}

-(NSString*)getName{
    
    NSString *name = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"username"];
    
    return name;
}

-(void)setBio:(NSString*)bio{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:bio forKey:@"bio"];
    
}

-(NSString*)getBio{
    
    NSString *bio = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"bio"];
    
    return bio;
}

-(void)setToken:(NSString*)token{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"access_token"];
    
}

-(NSString*)getToken{
    
    NSString *token = [[NSUserDefaults standardUserDefaults]
                     stringForKey:@"access_token"];
    
    return token;
}

-(void)setGender:(NSString*)gender{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:gender forKey:@"gender"];
    
}

-(NSString*)getGender{
    
    NSString *gender = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"gender"];
    
    return gender;
}

-(void)setBirthday:(NSString*)bday{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:bday forKey:@"bday"];
    
}

-(NSString*)getBirthday{
    
    NSString *bday = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"bday"];
    
    return bday;
}


-(void)setAge:(NSString*)age{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:age forKey:@"age"];
    
}

-(NSString*)getAge{
    
    NSString *age = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"age"];
    
    return age;
}

#pragma - social networks

-(void)setFacebook:(NSString*)network{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:network forKey:@"facebook_id"];
    
}

-(NSString*)getFacebook{
    
    NSString *network = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"facebook_id"];
    
    return network;
}


#pragma mark - User Status Methods

- (BOOL)UserIsTaken {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isTaken"]) {
        return YES;
    }
    return NO;
}

- (void)setUserTakenStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"isTaken"];
}




#pragma mark - NSCoding serialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    DataAccess *singletonInstance = [DataAccess singletonInstance];
    
 //   OAuthToken *token = [aDecoder decodeObjectForKey:@"oauthToken"];
 //   [singletonInstance setOAuthAccessToken:token];
    
 //   NSString *url = [aDecoder decodeObjectForKey:@"apiURLCurrent"];
//    [singletonInstance setCurrentURLforAPI:url];
    
    [singletonInstance persistToUserDefaults];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    DataAccess *singletonInstance = [DataAccess singletonInstance];
    
    
  //  [aCoder encodeObject:[singletonInstance accessToken] forKey:@"oauthToken"];
    
   // [aCoder encodeObject:[singletonInstance currentURLforAPI] forKey:@"apiURLCurrent"];
}


- (void)persistToUserDefaults {
    if(!self){
        return;
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"DataAccess"];
    
}


- (void)initUserDefaults {
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"DataAccess"];
    
    [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma mark - Singleton Methods
+ (id)singletonInstance {
    
    static DataAccess *sharedDataAccess = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataAccess = [[self alloc] init];
    });
    
    return sharedDataAccess;
    
}

@end
