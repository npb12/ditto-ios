//
//  LoginViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/25/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UIButton *LoginButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [self setLoginBtn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLoginBtn{
    
    self.LoginButton = [[UIButton alloc] init];
    self.LoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.LoginButton.backgroundColor = [self facebookBlue];
    [self.LoginButton setTitle: @"Login With Facebook" forState: UIControlStateNormal];
    // Handle clicks on the button
    [self.LoginButton
     addTarget:self
     action:@selector(LoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.LoginButton.alpha = 1.0;
    self.LoginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    
    self.LoginButton.layer.cornerRadius = 3.0;
    
    self.LoginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.LoginButton invalidateIntrinsicContentSize];
    
    CGFloat buttonWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) - 30;
    
    [self.LoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.LoginButton.titleEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
    
    
    
    [self.view addSubview:self.LoginButton];
    
    NSDictionary *viewsDictionary = @{@"fbButton" : self.LoginButton};
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.LoginButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[fbButton]-pad-|" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:20]} views:viewsDictionary];
    [self.view addConstraint:constraint1];
    [self.view addConstraints:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.LoginButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50];
    [self.view addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.LoginButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:buttonWidth];
    [self.view addConstraint:constraint4];
    

}

-(void)LoginButtonClicked{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorNative;
    [login
     logInWithReadPermissions: @[@"email", @"public_profile",  @"user_photos", @"user_birthday"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error %@", error);
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             if ([result.grantedPermissions containsObject:@"email"] && [result.grantedPermissions containsObject:@"user_photos"]) {

                 
                 if ([FBSDKAccessToken currentAccessToken]) {
                     
                     
                     NSString *access_token = [[FBSDKAccessToken currentAccessToken] tokenString];
                     
                     [[DataAccess singletonInstance] setUserLoginStatus:YES];
                     
                  [self dismissViewControllerAnimated:NO completion:nil];
                     
                     /*
                     NSString *dob = @"1990-12-12";
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
                     
                     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.portaldevservices.com/api/facebook/API/token_dob.php"]
                                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                        timeoutInterval:10.0];
                     [request setHTTPMethod:@"POST"];
                     [request setAllHTTPHeaderFields:headers];
                     [request setHTTPBody:postData];
                     
                     NSURLSession *session = [NSURLSession sharedSession];
                     NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                     if (error) {
                                                                         NSLog(@"%@", error);
                                                                     } else {

                                                                         
                                                                         NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         
                                                                         NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                                                         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         
                                                                         
                                                                         NSDictionary *getdata=[[NSDictionary alloc]init];
                                                                         getdata=[json objectForKey:@"user"];
      
                                                                         NSString *long_token = [getdata objectForKey:@"long_live_token"];
                                                                     
                                                                         [[DataAccess singletonInstance] setToken:long_token];

                                                                         [[DataAccess singletonInstance] setUserLoginStatus:YES];
                                                                         [self dismissViewControllerAnimated:NO completion:nil];
                                                                     }
                                                                 }];
                     [dataTask resume]; */
          
                     /*
                     
                     NSString *userid = [FBSDKAccessToken currentAccessToken].userID;
                     
                     NSURL *url = [NSURL URLWithString:@"https://www.portaldevservices.com/api/facebook/API/token_dob.php"];
                     NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                     NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
                     
                     // 2
                     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
                     request.HTTPMethod = @"POST";
                     [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                     [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
                     
                     NSString *access_token = [[FBSDKAccessToken currentAccessToken] tokenString];
                     
                     NSLog(@" access token:: %@", access_token);

                     
                     // 3
                     NSArray *dictionary = @[@{@"token": access_token, @"DATE_OF_BIRTH": @"5-10-2015",
                                                  @"gender": @"male", @"firstname": @"neil", @"images": @"kndfosi", @"index": @"1"}];
                     
                     
                     
                     NSError *error = nil;
                     NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                                    options:kNilOptions error:&error];
                     
        
                     if (!error) {
                         // 4
                         NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                                    fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                                        
                                                        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                                                                        
                                                        if(statusCode == 200){
                                                            NSError *error = nil;
                                                            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                            
                                                            if (error != nil) {
                                                                NSLog(@"Error parsing JSON.");
                                                            }
                                                            else {
                                                                NSLog(@"Array: %@", jsonArray);
                                                            [[DataAccess singletonInstance] setToken:[FBSDKAccessToken currentAccessToken].tokenString];
                                                                [[DataAccess singletonInstance] setUserLoginStatus:YES];
                                                                 [self dismissViewControllerAnimated:NO completion:nil];


                                                            }

                                                        }


                                                                        
                                                                                        
                                                                                        
                                                                                    }];
                         
                         // 5
                         [uploadTask resume];
                     } */

                     
                 }else{
                     [self viewDidLoad];
                 }
                 
             }
         }
         
     }];
}


- (UIColor *) facebookBlue
{
    return [UIColor colorWithRed:0.23 green:0.35 blue:0.60 alpha:1.0];
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
