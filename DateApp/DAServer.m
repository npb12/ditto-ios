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
    return @"http://dev.portaldevservices.com/api";

}

+(NSDictionary*)AuthHeader
{
    NSString *token = [NSString stringWithFormat:@"Token %@", [[DataAccess singletonInstance] getSessionToken]];
    
    return@{ @"content-type": @"application/json",
            @"cache-control": @"no-cache",
            @"Authorization" : token
        };
}

+ (void)facebookAuth:(UIViewController*)vc
           completion:(void (^)(NSError *))completion {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorNative;
    [login
     logInWithReadPermissions: @[@"email", @"public_profile",  @"user_photos", @"user_birthday",
                                 @"user_education_history", @"user_work_history"]
     fromViewController:vc
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error %@", error);
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             if ([result.grantedPermissions containsObject:@"email"] && [result.grantedPermissions containsObject:@"public_profile"]){ //&& [result.grantedPermissions containsObject:@"user_photos"]) {
                 
                 
                 
                 if ([FBSDKAccessToken currentAccessToken])
                 {
                     NSString *access_token = [[FBSDKAccessToken currentAccessToken] tokenString];
                     
                     NSLog(@"token::: %@", access_token);
                     
                     NSDictionary *headers = @{ @"content-type": @"application/json",
                                                @"cache-control": @"no-cache" };
                    
                     
                     NSString *urlStr = [NSString stringWithFormat:@"%@/login/?sl_token=%@", [DAServer baseURL], access_token];
                     
                     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                        timeoutInterval:10.0];
                     [request setHTTPMethod:@"GET"];
                     [request setAllHTTPHeaderFields:headers];
                     
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
                                                                         
                                                                         NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                                                         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         
                                                                       [DAParser myprofile:json];
                                                                         
                                                                         
                                                                         NSLog(@"%@", jsonString);
                                                                         
                                                                         
                                                                         NSString *user_id = [json objectForKey:@"id"];
                                                                         
                                                                         
                                                                         NSString *long_token = [json objectForKey:@"ll_token"];
                                                                         NSString *first_name = [json objectForKey:@"name"];
                                                                         
                                                                         NSString *gender = [json objectForKey:@"gender"];
                                                                         
                                                                         
                                                                         NSString *sessionToken = [json objectForKey:@"token"];
                                                                         
                                                                         
                                                                         [[DataAccess singletonInstance] setToken:long_token];
                                                                         [[DataAccess singletonInstance] setUserID:user_id];
                                                                         
                                                                         [[DataAccess singletonInstance] setSessionToken:sessionToken];
                                                                         
                                                                         [[DataAccess singletonInstance] setName:first_name];
                                                                         
                                                                         
                                                                         //   [[DataAccess singletonInstance] setProfileImage:picture];
                                                                         
                                                                         [[DataAccess singletonInstance] setGender:gender];
                                                                         
                                                                         [[DataAccess singletonInstance] setUserLoginStatus:YES];
                                                                         
                                                                         
                                                                         completion(nil);
                                                                         
                                                                     }
                                                                 }];
                     [dataTask resume];
                     
                 }
                 
                 
                 
             }
             
             
         }
         
         
     }];
     
     
     }


+ (void)facebookLogin:(UIViewController*)vc
           completion:(void (^)(NSMutableArray *, NSError *))completion {

    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorNative;
    [login
     logInWithReadPermissions: @[@"email", @"public_profile",  @"user_photos", @"user_birthday",
                                 @"user_education_history", @"user_work_history"]
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
                                                                     
                                                                     if (error)
                                                                     {
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
       completion:(void (^)(NSError *))completion {
    
    
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
                                                        completion(error);
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        
                                                        
                                                        completion(nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
    
    
}


+ (void)postLocation:(CLLocationCoordinate2D)location
           completion:(void (^)(NSMutableArray *, NSError *))completion {
    
    __block NSMutableArray *users = [NSMutableArray new];
    
    
    NSDictionary *headers = [DAServer AuthHeader];
    
    NSString *urlStr = [NSString stringWithFormat:@"/latest/?lat=%@&lon=%@",
                        @(location.latitude), @(location.longitude)];
    
    NSString *url = [[DAServer baseURL] stringByAppendingString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
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
                                                        
                                                        NSLog(@"jsonnnn %@", jsonString);
                                                        
                                                        NSData *ns = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                                        id json = [NSJSONSerialization JSONObjectWithData:ns options:0 error:nil];
                                                        
                                                        NSDictionary *temp_users=[[NSDictionary alloc]init];
                                                        temp_users=[json objectForKey:@"nearby"];
                                                        
                                                        NSDictionary *matches=[[NSDictionary alloc]init];
                                                        matches=[json objectForKey:@"alternates"];
                                                        
                                                        NSDictionary *currentMatch=[[NSDictionary alloc]init];
                                                        currentMatch=[json objectForKey:@"match"];
                                                        
                                                        
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

                                                        
                                                        if ([matches count] > 0)
                                                        {
                                                            [DAParser alternateMatches:matches];
                                                        }

                                                        
                                                        completion(users, nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
    
    
}

+ (void)swipe:(NSString*)likedID liked:(BOOL)like
             completion:(void (^)(NSError *))completion {
    
    NSString *swipeAction;
    
    if (like)
    {
        swipeAction = @"swipe-right";
    }
    else
    {
        swipeAction = @"swipe-left";
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/", [DAServer baseURL], swipeAction, likedID];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                        cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[DAServer AuthHeader]];
    
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
    
    
    NSDictionary *headers = [DAServer AuthHeader];
    
    NSDictionary *parameters = @{
                                    @"reason": message,
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSString *url = [[DAServer baseURL] stringByAppendingString:@"/drop-match/"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
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

//bio, occupation, education, d_token
+ (void)updateProfile:(NSString*)requestType data:(NSDictionary*)dict
           completion:(void (^)(NSError *))completion {
    
    
    NSDictionary *headers = [DAServer AuthHeader];
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];

        NSString *urlStr = [NSString stringWithFormat:@"%@/profiles/%@/", [DAServer baseURL], uid];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:requestType];
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
                                                        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                                        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        
                                                        [DAParser myprofile:json];
                                                        completion(nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
    
    
}

//delete a photo
+ (void)deletePhoto:(NSString*)position
           completion:(void (^)(NSError *))completion {
    
    
    NSDictionary *headers = [DAServer AuthHeader];
    
    ///api/pictures/delete/:position/
    NSString *urlStr = [NSString stringWithFormat:@"%@/pictures/delete/%@/", [DAServer baseURL], position];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                        cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    
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
                                                        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                                        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                                                        completion(nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
    
    
}

+(void)uploadPhoto:(UIImage*)image index:(NSInteger)index completion:(void (^)(NSError *))completion
{
    NSString *url = [NSString stringWithFormat:@"%@/pictures/", [DAServer baseURL]];
    
    NSInteger serverInt = index + 1;
    NSDictionary* args = @{ @"position" : @(serverInt) }; //event[picture]
    NSString* boundary = [[NSProcessInfo processInfo] globallyUniqueString];
    NSData* imageData = [DAServer createFormDataForImage:image args:args boundary:boundary objectName:@"pic"];
    
    
    NSString* content_type = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];

        NSString *token = [NSString stringWithFormat:@"Token %@", [[DataAccess singletonInstance] getSessionToken]];
    
    NSDictionary *headers = @{ @"content-type": content_type,
                               @"cache-control": @"no-cache",
                               @"Authorization" : token
                               };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:imageData];
    
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

+ (void)addFoto:(UIImage*)image index:(NSInteger)index completion:(void (^)(NSError *))completion
{
    
    
    NSString *token = [NSString stringWithFormat:@"Token %@", [[DataAccess singletonInstance] getSessionToken]];
    
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",
                               @"cache-control": @"no-cache",
                               @"Authorization" : token
                               };
    

    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    NSString *encodedString = [[self base64forData:imageData] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSDictionary *dict = @{
                           @"position": @(index),
                           @"pic": encodedString,
                           };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    NSString *url = [NSString stringWithFormat:@"%@/pictures/", [DAServer baseURL]];

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
  //  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    

    
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


+ (void)getProfile:(void (^)(User *, NSError *))completion {
    
    NSDictionary *headers = [DAServer AuthHeader];
    
    NSString *args = [NSString stringWithFormat:@"/profiles/%@/", [[DataAccess singletonInstance] getUserID]];
    
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
                                                        NSLog(@"json response: %@", jsonString);

                                                        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                                        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        
                                                        User *user = [DAParser myprofile:json];
                                                        
                                                        if ([user.profilePic containsString:@"fbcdn"])
                                                        {
                                                            //upload facebook profile photo
                                                                if (user.profilePic)
                                                                {
                                                                    [PhotoDownloader downloadImage:user.profilePic completion:^(UIImage *image, NSError *error)
                                                                     {
                                                                         if (image && !error)
                                                                         {
                                                                             [DAServer uploadPhoto:image index:1 completion:^(NSError *error) {
                                                                                 
                                                                             }];
                                                                         }
                                                                         
                                                                     }];
                                                                }
                                                            
                                                        }
                                                        
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
                                                        
                                //                        User *settings = [DAParser mysettings:dict];
                                                        
                                                        completion(nil, nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
}

+ (void)getMessages:(void (^)(NSArray *, NSError *))completion {
    
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
                                                        
                                                        NSLog(@"json:: %@", jsonString);
                                                        
                                                        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                                        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        
                                                        NSDictionary *dict = [json objectForKey:@"messages"];

                                                        NSArray *messages =  [DAParser messages:dict];
                                                        
                                                        
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
