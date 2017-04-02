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
                     
                     //           NSLog(@" access token:: %@", access_token);
                     
                     
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
                     
                     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.portaldevservices.com/api/facebook/API/dtloc.php"]
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
                                                                         
                                                                         
                                                                         NSLog(@"%@", json);
                                                                         
                                                                         NSDictionary *getdata=[[NSDictionary alloc]init];
                                                                         getdata=[json objectForKey:@"user"];
                                                                         
                                                                         NSString *user_id = [getdata objectForKey:@"id"];
                                                                         NSString *long_token = [getdata objectForKey:@"long_live_token"];
                                                                         NSString *first_name = [getdata objectForKey:@"first_name"];
                                                                         
                                                                         NSString *gender = [getdata objectForKey:@"setGender"];
                                                                         
                                                                         NSString *distance = [getdata objectForKey:@"setGender"];
                                                                         
                                                                         NSString *age = [getdata objectForKey:@"setAge"];
                                                                         
                                                                         NSString *picture = [getdata objectForKey:@"picture"];
                                                                         
                                                                         
                                                                         
                                                                         [[DataAccess singletonInstance] setToken:long_token];
                                                                         [[DataAccess singletonInstance] setUserID:user_id];
                                                                         
                                                                         [[DataAccess singletonInstance] setName:first_name];
                                                                         
                                                                         
                                                                         [[DataAccess singletonInstance] setProfileImage:picture];
                                                                         
                                                                         [[DataAccess singletonInstance] setGender:gender];
                                                                         
                                                                         [[DataAccess singletonInstance] setUserLoginStatus:YES];
                                                                         
                                                                         
                                                                         completion(nil, nil);

                                                                     }
                                                                 }];
                     [dataTask resume];
                     
                     
                     
                 }
                 
             }
         }
         
     }];
    
}

+ (void)postDeviceToken:(NSString*)token
       completion:(void (^)(NSMutableArray *, NSError *))completion {
    
    __block NSMutableArray *temp_users = [NSMutableArray new];
    
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    
    
    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"id": uid,
                                         @"post": @"token",
                                         @"token": token
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.portaldevservices.com/api/facebook/API/dtloc.php"]
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
                                                        
                                                        NSLog(@"json response: %@", jsonString);
                                                        
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
    
    
    
    double longitude = 7.361647;
    double latitude = 48.741333;
    
    
    
    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"id": @25,
                                         @"post": @"location",
                                         @"locations": @[
                                                 @{
                                                     @"timestamp": @"1",
                                                     @"lon": @(7.258613),
                                                     @"lat": @(48.767453)
                                                     }
                                                 ]
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.portaldevservices.com/api/facebook/API/dtloc.php"]
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
                                                        
                                                        [DAParser alternateMatches:matches];
                                                       users = [DAParser nearbyUsers:temp_users];
                                                        
                                                        [DAParser currentMatch:currentMatch];
                                                        
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
    
    
    
    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"post": @"like",
                                         @"id": uid,
                                         @"like_id": likedID,
                                         @"like": @(like)
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.portaldevservices.com/api/facebook/API/dtloc.php"]
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

+ (void)dropMatch:(NSString*)matchID
            completion:(void (^)(NSError *))completion {
    
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    
    
    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"post": @"drop",
                                         @"id": uid,
                                         @"drop": matchID
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.portaldevservices.com/api/facebook/API/dtloc.php"]
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

+ (void)dropSwapMatch:(NSString*)likedID
       completion:(void (^)(NSError *))completion {
    
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    
    
    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"uid": uid,
                                         @"post": @"confirm",
                                         @"confirm": likedID
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.portaldevservices.com/api/facebook/API/dtloc.php"]
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
+ (void)updateProfile:(NSString*)type description:(NSString*)text
           completion:(void (^)(NSError *))completion {
    
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"id": uid,
                                         @"post": @"profile",
                                         type: text
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.portaldevservices.com/api/facebook/API/dtloc.php"]
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

//bio, occupation
+ (void)updateSettings:(NSString*)type setting:(NSString*)edit
           completion:(void (^)(NSError *))completion {
    
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    NSString *uid = [[DataAccess singletonInstance] getUserID];
    
    
    NSDictionary *parameters = @{
                                 @"request": @{
                                         @"id": uid,
                                         @"post": @"settings",
                                         @"settings": type,
                                         @"value": edit
                                         }
                                 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.portaldevservices.com/api/facebook/API/dtloc.php"]
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

#pragma GET Requests


+ (void)getProfile:(NSString *)param
        completion:(void (^)(User *, NSError *))completion {
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache" };
    
    
    NSString *url_string = [NSString stringWithFormat:@"https://www.portaldevservices.com/api/facebook/API/dtloc.php?uid=%@&get=profile", [[DataAccess singletonInstance] getUserID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url_string]
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
                                                        
                                                        NSLog(@"%@", json);
                                                        
                                                        
                                                       // completion(user, nil);
                                                        
                                                    }
                                                }];
    [dataTask resume];
}

@end
