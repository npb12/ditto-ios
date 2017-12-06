//
//  DAServer.m
//  DateApp
//
//  Created by Neil Ballard on 3/30/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "DAServer.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@implementation DAServer

#pragma POST requests

+(NSString*)baseURL
{
    //production server
  //  return @"http://54.174.235.42/api/dtloc.php";
    
    return @"http://portaldevservices.com/dtloc.php";

}


+ (void)facebookLogin:(UIViewController*)vc
           completion:(void (^)(NSMutableArray *, NSError *))completion {

    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorNative;
    [login
     logInWithReadPermissions: @[@"email", @"public_profile",  @"user_photos", @"user_birthday"]
     fromViewController:vc
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error %@", error);
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             if ([result.grantedPermissions containsObject:@"email"] && [result.grantedPermissions containsObject:@"public_profile"]){ //&& [result.grantedPermissions containsObject:@"user_photos"]) {
                 
                 
                 
                 if ([FBSDKAccessToken currentAccessToken]) {
                     
                     
                     NSString *access_token = [[FBSDKAccessToken currentAccessToken] tokenString];
                     
                        NSLog(@" access token:: %@", access_token);
                     
                     
                     NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
                                                @"cache-control": @"no-cache"
                                                //  @"postman-token": @"f6c6a69a-799b-48ac-af5c-335d556c8f60"
                                                };
                     
                     
                     NSArray *parameters = @[ @{ @"name": @"token", @"value": access_token },
                                              ];
                     NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
                     
                     NSError *error;
                     NSMutableString *body = [NSMutableString string];
                     for (NSDictionary *param in parameters) {
                         [body appendFormat:@"--%@\r\n", boundary];
                         if (param[@"fileName"]) {
                             [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
                             [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
                             [body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
                             if (error) {
                                 NSLog(@"%@", error);
                             }
                         } else {
                             [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
                             [body appendFormat:@"%@", param[@"value"]];
                         }
                     }
                     [body appendFormat:@"\r\n--%@--\r\n", boundary];
                     NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
                     
                     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[DAServer baseURL]]
                                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                        timeoutInterval:10.0];
                     [request setHTTPMethod:@"POST"];
                     [request setAllHTTPHeaderFields:headers];
                     [request setHTTPBody:postData];
                     
                     NSURLSession *session = [NSURLSession sharedSession];
                     NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                     
                                                                     NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                                                                     NSInteger statusCode = [HTTPResponse statusCode];
                                                                     
                                                                     NSLog(@"%ld", (long)statusCode);
                                                                     
                                                                     if (error) {
                                                                         NSLog(@"%@", error);
                                                                     } else {
                                                                         
                                                                         
                                                                         NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         
                                                                         NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                                                         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         
                                                                         
                                                                         NSLog(@"%@", jsonString);
                                                                         
                                                                         NSDictionary *getdata=[[NSDictionary alloc]init];
                                                                         getdata=[json objectForKey:@"user"];
                                                                         
                                                                         NSString *user_id = [getdata objectForKey:@"id"];
                                                                         NSString *long_token = [getdata objectForKey:@"long_live_token"];
                                                                         NSString *first_name = [getdata objectForKey:@"first_name"];
                                                                         
                                                                         NSString *gender = [getdata objectForKey:@"setGender"];
                                                                         
                                                                         NSString *distance = [getdata objectForKey:@"setGender"];
                                                                         
                                                                         NSString *age = [getdata objectForKey:@"setAge"];
                                                                         
                                                                         NSString *sessionToken = [getdata objectForKey:@"sessionToken"];
                                                                         
                                                                         
                                                                         [[DataAccess singletonInstance] setToken:long_token];
                                                                         [[DataAccess singletonInstance] setUserID:user_id];
                                                                         
                                                                                                                                                  [[DataAccess singletonInstance] setSessionToken:sessionToken];
                                                                         
                                                                         [[DataAccess singletonInstance] setName:first_name];
                                                                         
                                                                         
                                                                      //   [[DataAccess singletonInstance] setProfileImage:picture];
                                                                         
                                                                         [[DataAccess singletonInstance] setGender:gender];
                                                                         
                                                                         [[DataAccess singletonInstance] setUserLoginStatus:YES];
                                                                         
                                                                         
                                                                         completion(nil, error);

                                                                     }
                                                                 }];
                     [dataTask resume];
                     
                     
                     
                 }
                 
             }
         }
         
     }];
    
}

+ (void)facebookLogout
{
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    [User removeCurrentUser];
  /*
    NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    
    
    for (NSString *key in [defaultsDictionary allKeys]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    } */
    [[DataAccess singletonInstance] setUserLoginStatus:NO];
}

+ (void)postDeviceToken:(NSString*)token
       completion:(void (^)(NSMutableArray *, NSError *))completion {
    
    __block NSMutableArray *temp_users = [NSMutableArray new];
    
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    NSString *sessionToken = [[DataAccess singletonInstance] getSessionToken];

    
    
    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"id": uid,
                                         @"sessionToken": sessionToken,
                                         @"post": @"token",
                                         @"token": token
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[DAServer baseURL]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                                                    NSInteger statusCode = [HTTPResponse statusCode];
                                                    
                                                    NSLog(@"response is %ld", (long)statusCode);
                                                    if (error) {
                                                        completion(nil, error);
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        
                                                    //    NSLog(@"json response: %@", jsonString);
                                                        
                                                        completion(temp_users, nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
    
    
}


+ (void)postLocation:(User*)param
           completion:(void (^)(NSMutableArray *, NSError *))completion {
    
    __block NSMutableArray *users = [NSMutableArray new];
    
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    double time_stamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *sessionToken = [[DataAccess singletonInstance] getSessionToken];

    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"id": uid,
                                         @"sessionToken": sessionToken,
                                         @"post": @"location",
                                         @"locations": @[
                                                 @{
                                                     @"timestamp": @(time_stamp),
                                                     @"lon": @([[LocationManager sharedInstance] location].longitude),
                                                     @"lat": @([[LocationManager sharedInstance] location].latitude)
                                                     }
                                                 ]
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[DAServer baseURL]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                                                    NSInteger statusCode = [HTTPResponse statusCode];
                                                    
                                                    NSLog(@"response is %ld", (long)statusCode);
                                                    if (error) {
                                                        completion(nil, error);
                                                        NSLog(@"%@", error);
                                                    } else {

                                                        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        
                                                        NSData *ns = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                                        id json = [NSJSONSerialization JSONObjectWithData:ns options:0 error:nil];
                                                        
                                                        
                                                        NSDictionary *temp_users=[[NSDictionary alloc]init];
                                                        temp_users=[json objectForKey:@"users"];
                                                        
                                                        NSDictionary *matches=[[NSDictionary alloc]init];
                                                        matches=[json objectForKey:@"alternateMatchs"];
                                                        
                                                        NSDictionary *currentMatch=[[NSDictionary alloc]init];
                                                        currentMatch=[json objectForKey:@"currentMatch"];
                                                        
                                                        
                                                        users = [DAParser nearbyUsers:temp_users];
                                                        if ([currentMatch count] > 0)
                                                        {
                                                            [DAParser currentMatch:currentMatch notif:NO];
                                                        }
                                                        else
                                                        {
                                                            [MatchUser removeCurrentMatch];
                                                            [[DataAccess singletonInstance] setUserHasMatch:NO];
                                                        }

                                                        
                                                        [DAParser alternateMatches:matches];


                                                        
                                                        completion(users, nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
    
    
}

+ (void)swipe:(NSString*)likedID liked:(int)like
             completion:(void (^)(NSError *))completion {
    
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    NSString *sessionToken = [[DataAccess singletonInstance] getSessionToken];
    
    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"post": @"like",
                                         @"id": uid,
                                         @"sessionToken": sessionToken,
                                         @"like_id": likedID,
                                         @"like": @(like)
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[DAServer baseURL]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                                                    NSInteger statusCode = [HTTPResponse statusCode];
                                                    
                                                    NSLog(@"response is %ld", (long)statusCode);
                                                    if (error) {
                                                        completion(error);
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        
                                                    //    NSLog(@"json response: %@", jsonString);
                                                        
                                                        completion(nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
    
    
}

+ (void)dropMatch:(NSString*)message
            completion:(void (^)(NSError *))completion {
    
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    NSString *sessionToken = [[DataAccess singletonInstance] getSessionToken];
    
    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"post": @"dropCurrent",
                                         @"id": uid,
                                         @"sessionToken": sessionToken,
                                         @"message": message
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[DAServer baseURL]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                                                    NSInteger statusCode = [HTTPResponse statusCode];
                                                    
                                                    NSLog(@"response is %ld", (long)statusCode);
                                                    if (error) {
                                                        completion(error);
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        
                                                    //    NSLog(@"json response: %@", jsonString);
                                                        
                                                        completion(nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
    
    
}

+ (void)dropSwapMatch:(NSString*)likedID
       completion:(void (^)(NSError *))completion {
    
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    
    NSString *sessionToken = [[DataAccess singletonInstance] getSessionToken];
    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"id": uid,
                                         @"sessionToken": sessionToken,
                                         @"post": @"confirm",
                                         @"confirm": likedID,
                                         @"message": @""
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[DAServer baseURL]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                                                    NSInteger statusCode = [HTTPResponse statusCode];
                                                    
                                                    NSLog(@"response is %ld", (long)statusCode);
                                                    if (error) {
                                                        completion(error);
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        
                                                    //    NSLog(@"json response: %@", jsonString);
                                                        
                                                        completion(nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
    
    
}

+ (void)dismissAlternateMatch:(NSString*)likedID
           completion:(void (^)(NSError *))completion {
    
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    NSString *sessionToken = [[DataAccess singletonInstance] getSessionToken];
    
    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"id": uid,
                                         @"sessionToken": sessionToken,
                                         @"post": @"dropMatch",
                                         @"drop": likedID
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[DAServer baseURL]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                                                    NSInteger statusCode = [HTTPResponse statusCode];
                                                    
                                                    NSLog(@"response is %ld", (long)statusCode);
                                                    if (error) {
                                                        completion(error);
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        
                                                        //    NSLog(@"json response: %@", jsonString);
                                                        
                                                        completion(nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
    
    
}

//bio, occupation
+ (void)updateProfile:(NSString*)type description:(NSString*)text
           completion:(void (^)(NSError *))completion {
    
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    NSString *sessionToken = [[DataAccess singletonInstance] getSessionToken];
    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"id": uid,
                                         @"sessionToken": sessionToken,
                                         @"post": @"profile",
                                         type: text
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[DAServer baseURL]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                                                    NSInteger statusCode = [HTTPResponse statusCode];
                                                    
                                                    NSLog(@"response is %ld", (long)statusCode);
                                                    if (error) {
                                                        completion(error);
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        
                                                        NSLog(@"json response: %@", jsonString);
                                                        completion(nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
    
    
}

//bio, occupation
+ (void)updateSettings:(NSString*)type setting:(NSString*)edit
           completion:(void (^)(NSError *))completion {
    
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    NSString *sessionToken = [[DataAccess singletonInstance] getSessionToken];

    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"id": uid,
                                         @"sessionToken": sessionToken,
                                         @"post": @"settings",
                                         @"settings": type,
                                         @"value": edit
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[DAServer baseURL]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                                                    NSInteger statusCode = [HTTPResponse statusCode];
                                                    
                                                    NSLog(@"response is %ld", (long)statusCode);
                                                    if (error) {
                                                        completion(error);
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        
                                                        completion(nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
    
    
}


+ (void)updateAlbum:(NSMutableArray*)array completion:(void (^)(NSError *))completion {
    
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    NSString *photo1 = @"";
    NSString *photo2 = @"";
    NSString *photo3 = @"";
    NSString *photo4 = @"";
    NSString *photo5 = @"";
    
    NSUInteger array_count = [array count];
    
    

    if (array_count > 0)
    {
        photo1 = array[0];
        
        if (array_count > 1)
        {
            photo2 = array[1];
            
            if (array_count > 2)
            {
                photo3 = array[2];
                
                if (array_count > 3)
                {
                    photo4 = array[3];
                    
                    if (array_count > 4)
                    {
                        photo5 = array[4];
                    }
                }
            }
            
        }
        

        

        

    }
    
    NSString *sessionToken = [[DataAccess singletonInstance] getSessionToken];

    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"id": uid,
                                         @"sessionToken": sessionToken,
                                         @"post": @"photos",
                                         @"photo1": photo1,
                                         @"photo2": photo2,
                                         @"photo3": photo3,
                                         @"photo4": photo4,
                                         @"photo5": photo5
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[DAServer baseURL]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                                                    NSInteger statusCode = [HTTPResponse statusCode];
                                                    
                                                    NSLog(@"response is %ld", (long)statusCode);
                                                    if (error) {
                                                        completion(error);
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        
                                                        NSLog(@"json response: %@", jsonString);
                                                        completion(nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
    
    
}

+ (void)addLocalPhoto:(UIImage*)image index:(NSInteger)index completion:(void (^)(NSError *))completion {
    
    
    
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",
                               @"cache-control": @"no-cache" };
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    
    NSString *sessionToken = [[DataAccess singletonInstance] getSessionToken];
    
    NSString *strIndex = [NSString stringWithFormat:@"%ld", index];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    NSString *encodedString = [[self base64forData:imageData] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"id": uid,
                                         @"sessionToken": sessionToken,
                                         @"post": @"addPic",
                                         @"image": encodedString,
                                         @"index": strIndex
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[DAServer baseURL]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                                                    NSInteger statusCode = [HTTPResponse statusCode];
                                                    
                                                    NSLog(@"response is %ld", (long)statusCode);
                                                    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                    if (error) {
                                                        completion(error);
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        
                                                        completion(nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
    
    
}

+ (void)addFoto:(UIImage*)image index:(NSInteger)index completion:(void (^)(NSError *))completion {
    
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    
    NSString *sessionToken = [[DataAccess singletonInstance] getSessionToken];
    
    NSString *strIndex = [NSString stringWithFormat:@"%ld", index];

    NSString *url = @"http://portaldevservices.com/addFoto.php";
    //[DAServer baseURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    NSString *encodedString = [[self base64forData:imageData] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    
    
    NSString *dataToSend = [[NSString alloc] initWithFormat:@"post=%@&uid=%@&sessionToken=%@&index=%@&image=%@", @"addLocal", uid, sessionToken, strIndex,  encodedString];
    
    [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];

    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                                                    NSInteger statusCode = [HTTPResponse statusCode];
                                                    
                                                    NSLog(@"response is %ld", (long)statusCode);
                                                    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                    if (error) {
                                                        completion(error);
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        
                                                        completion(nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
    
    
}

+(NSString*)base64forData:(NSData*) theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+ (NSData*) createFormDataForImage:(UIImage*)image args:(NSDictionary*)args boundary:(NSString*)boundary objectName:(NSString*)objectName
{
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    
    NSMutableData* d = [NSMutableData data];
    
    for (NSString* k in [args allKeys]) {
        NSString* val = [args objectForKey:k];
        [d appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [d appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", k] dataUsingEncoding:NSUTF8StringEncoding]];
        [d appendData:[[NSString stringWithFormat:@"%@\r\n", val] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (imageData) {
        [d appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [d appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=cat-pic.jpg\r\n", objectName] dataUsingEncoding:NSUTF8StringEncoding]];
        [d appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [d appendData:imageData];
        [d appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [d appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return d;
}


#pragma GET Requests


+ (void)getProfile:(NSString *)param
        completion:(void (^)(User *, NSError *))completion {
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    NSString *args = [NSString stringWithFormat:@"?uid=%@&get=profile&sessionToken=%@", [[DataAccess singletonInstance] getUserID], [[DataAccess singletonInstance] getSessionToken]];
    
    NSString *URL = [[DAServer baseURL] stringByAppendingString:args];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        completion(nil, error);
                                                    } else {
                                                        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        
                                                        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                                        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                                                        NSDictionary *dict = [json objectForKey:@"infos"];
                                                        
                                                        User *user = [DAParser myprofile:dict];
                                                        
                                                        completion(user, nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
}


+ (void)getSettings:(NSString *)param
        completion:(void (^)(User *, NSError *))completion {
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    
    NSString *args = [NSString stringWithFormat:@"?uid=%@&get=profile&sessionToken=%@", [[DataAccess singletonInstance] getUserID], [[DataAccess singletonInstance] getSessionToken]];
    
    NSString *URL = [[DAServer baseURL] stringByAppendingString:args];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        completion(nil, error);
                                                    } else {
                                                        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        
                                                        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                                        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        
                                                        NSDictionary *dict = [json objectForKey:@"infos"];
                                                        
                                                        User *settings = [DAParser mysettings:dict];
                                                        
                                                        completion(settings, nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
}

+ (void)getMessages:(NSString *)param
         completion:(void (^)(NSArray *, NSError *))completion {
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    
    NSString *args = [NSString stringWithFormat:@"?uid=%@&get=message&sessionToken=%@", [[DataAccess singletonInstance] getUserID], [[DataAccess singletonInstance] getSessionToken]];
    
    NSString *URL = [[DAServer baseURL] stringByAppendingString:args];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];

    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        completion(nil, error);
                                                    } else {
                                                        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        
                                                        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                                        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        
                                                        
                                                        NSDictionary *recieved = [json objectForKey:@"recieved"];

                                                        NSDictionary *sent = [json objectForKey:@"sent"];

                                                        
                                                       NSArray *messages =  [DAParser messages:recieved sent:sent];
                                                        
                                                        
                                                        completion(messages, nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
}

+ (void)LastMessageNew:(NSString *)param
         completion:(void (^)(bool, NSError *))completion {
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    
    NSString *args = [NSString stringWithFormat:@"?uid=%@&get=message&sessionToken=%@", [[DataAccess singletonInstance] getUserID], [[DataAccess singletonInstance] getSessionToken]];
    
    NSString *URL = [[DAServer baseURL] stringByAppendingString:args];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        completion(nil, error);
                                                    } else {
                                                        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        
                                                        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                                        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        
                                                        
                                                        NSDictionary *recieved = [json objectForKey:@"recieved"];
                                                        
                                                        NSDictionary *sent = [json objectForKey:@"sent"];
                                                        
                                                        bool messageNew =  [DAParser messageNew:recieved sent:sent];
                                                        
                                                        completion(messageNew, nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
}

+ (void)getMatchesData:(BOOL)alt
         completion:(void (^)(NSError *))completion {
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    NSString *args = [NSString stringWithFormat:@"?uid=%@&get=location&sessionToken=%@", [[DataAccess singletonInstance] getUserID], [[DataAccess singletonInstance] getSessionToken]];
    
    NSString *URL = [[DAServer baseURL] stringByAppendingString:args];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];

    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
//                                                        completion(nil, error);
                                                    } else {
                                                        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        
                                                        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                                        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        
                                                        NSLog(@"%@", jsonString);
                                                        
                                                        
                                                        NSDictionary *matches=[[NSDictionary alloc]init];
                                                        matches=[json objectForKey:@"alternateMatchs"];
                                                        
                                                        NSDictionary *currentMatch=[[NSDictionary alloc]init];
                                                        currentMatch=[json objectForKey:@"currentMatch"];
                                                        
                                                        
                                                        if (!alt)
                                                        {
                                                            if ([currentMatch count] > 0)
                                                            {
                                                                [DAParser currentMatch:currentMatch notif:YES];
                                                            }
                                                            else
                                                            {
                                                                [MatchUser removeCurrentMatch];
                                                                [[DataAccess singletonInstance] setUserHasMatch:NO];
                                                            }
                                                        }
                                                        else
                                                        {
                                                            [DAParser alternateMatches:matches];
                                                        }
                                                        
                                                        
                                                        
                                                      //  NSDictionary *dict = [json objectForKey:@"infos"];
                                                        
                                                        //User *settings = [DAParser mysettings:dict];
                                                        
                                                 //       completion(nil, nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
}



@end
