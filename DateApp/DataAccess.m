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

- (BOOL)IsReturningUser {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isInitialUser"]) {
        return YES;
    }
    return NO;
}

- (void)setReturningUserStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"isInitialUser"];
}


- (BOOL)askedForNotifications
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"askedNotifications"]) {
        return YES;
    }
    return NO;
}

- (void)setaskedForNotifications:(BOOL)status
{
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"askedNotifications"];
}

//match data
- (BOOL)UserHasMatch {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"hasMatch"]) {
        return YES;
    }
    return NO;
}

- (void)setUserHasMatch:(BOOL)status {
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



- (void)setisLoggedInWithFB:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"LoggedInWithFB"];
}

- (BOOL)LoggedInWithFB {
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"LoggedInWithFB"]) {
        return YES;
    }
    
    return NO;
}





-(NSString*)getProfileImage{
    
    NSString* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileImage"];
    return imageData;
    
}


-(NSString*)getProfileImage2{
    
    NSString* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileImage2"];
    return imageData;
    
}



-(NSString*)getProfileImage3{
    
    NSString* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileImage3"];
    return imageData;
    
}


-(NSString*)getProfileImage4{
    
    NSString* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileImage4"];
    return imageData;
    
}

-(NSString*)getProfileImage5{
    
    NSString* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileImage5"];
    return imageData;
    
}


-(void)setProfileImage:(NSString*)image{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:image forKey:@"ProfileImage"];
    
}

-(void)setProfileImage2:(NSString*)image{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:image forKey:@"ProfileImage2"];
    
}


-(void)setProfileImage3:(NSString*)image{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:image forKey:@"ProfileImage3"];
    
}

-(void)setProfileImage4:(NSString*)image{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:image forKey:@"ProfileImage4"];
    
}

-(void)setProfileImage5:(NSString*)image{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:image forKey:@"ProfileImage5"];
    
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

-(void)setSessionToken:(NSString*)token{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"session_token"];
    
}

-(NSString*)getSessionToken{
    
    NSString *token = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"session_token"];
    
    return token;
}

-(void)setLastMessage:(long)timestamp
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong: timestamp] forKey:@"timestamp"];
}
-(long)getLastMessage
{
    NSNumber *timestamp = [[NSUserDefaults standardUserDefaults]
                            objectForKey:@"timestamp"];
    self.lastMessageTime = [timestamp longValue];
    
    return self.lastMessageTime;
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

- (BOOL)UserGrantedLocationPermission {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"location_permission"]) {
        return YES;
    }
    return NO;
}

- (void)setUserGrantedLocationPermission:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"location_permission"];
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

-(void)setUserLocation:(CLLocationCoordinate2D)location{
    
    NSNumber *lat = [NSNumber numberWithDouble:location.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:location.longitude];
    NSDictionary *userLocation=@{@"lat":lat,@"long":lon};
    [[NSUserDefaults standardUserDefaults] setObject:userLocation forKey:@"last_location"];
    
}

-(CLLocationCoordinate2D)getUserLocation{
    
    
    NSDictionary *userLoc=[[NSUserDefaults standardUserDefaults] objectForKey:@"last_location"];
    CLLocationCoordinate2D location;
    location.latitude =  [[userLoc objectForKey:@"lat"] doubleValue];
    location.longitude = [[userLoc objectForKey:@"long"] doubleValue];
    
    return location;
}

-(void)setUserID:(id)uid{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"user_id"];
    
}

-(NSString*)getUserID{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]
                     stringForKey:@"user_id"];
    
    return uid;
}



#pragma mark - NSCoding serialization

#pragma mark - NSCoding serialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    DataAccess *singletonInstance = [DataAccess singletonInstance];
    
    BOOL loggedInStatus = [aDecoder decodeBoolForKey:@"LoggedInStatus"];
    [singletonInstance setUserLoginStatus:loggedInStatus];
    
    
    
    NSString *token = [aDecoder decodeObjectForKey:@"access_token"];
    [singletonInstance setToken:token];
    
    
    NSString *userID = [aDecoder decodeObjectForKey:@"user_id"];
    [singletonInstance setUserID:userID];
    
    NSString *first_name = [aDecoder decodeObjectForKey:@"first_name"];
    [singletonInstance setName:first_name];


    
    
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    DataAccess *singletonInstance = [DataAccess singletonInstance];
    
    [aCoder encodeBool:[singletonInstance UserIsLoggedIn] forKey:@"LoggedInStatus"];
    
    
    
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
