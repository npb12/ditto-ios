//
//  HomeViewController.m
//  DateApp
//
//  Created by Neil Ballard on 10/2/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface TFDailyVC ()

@property (nonatomic, strong) NSArray *dailyFilmShowings; //same as all film showings but doesn't have multple showings of the same film per day



@property (strong, nonatomic) IBOutlet UIButton *like_button;

@property (strong, nonatomic) IBOutlet TFDailyTableCell *tfView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottom_space;

@property (strong, nonatomic) IBOutlet UIButton *dislike_button;

@property (strong, nonatomic) IBOutlet UIView *parent_view;
@end

@implementation TFDailyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    
    self.tfView.delegate = self;
    self.tfView.matched_delegate = self;
    self.bottom_space.constant = self.view.frame.size.height / 6.5;
    
    
    self.like_button.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.like_button.layer.shadowOffset = CGSizeZero;
    self.like_button.layer.shadowOpacity = 1.0;
    self.like_button.layer.shadowRadius = 10.0;
    
    self.dislike_button.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.dislike_button.layer.shadowOffset = CGSizeZero;
    self.dislike_button.layer.shadowOpacity = 1.0;
    self.dislike_button.layer.shadowRadius = 10.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liked:) name:@"heartCurrentUser" object:nil];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)liked:(id)sender {
    
    [self.tfView likedUser];
    
    
    
}


- (IBAction)dislike:(id)sender {
    
    [self.tfView dislikedUser];
    
}




- (CGSize) safeScreenSize
{
  //  if (self.dailyRootVC)
 //   {
        return self.view.bounds.size;
//    }
//    else
 //   {
    //    return [UIScreen mainScreen].bounds.size;
  //  }
}

-(void)goToProfileSegue:(id)sender obj:(TFDailyItem*)object{
    [self performSegueWithIdentifier:@"goToAlbum" sender:object];
}

-(void)goToMatchedSegue:(id)sender obj:(TFDailyItem *)object{
    
    /*
    if (user currently has match) {
        [self performSegueWithIdentifier:@"goToMatchedConflict" sender:object];
    }else{
        [self performSegueWithIdentifier:@"goToMatched" sender:object];
    } */
    
    [self performSegueWithIdentifier:@"goToMatchedConflict" sender:object];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToAlbum"]) {
        
    //    ProfileViewController *profileVC = (ProfileViewController *)segue.destinationViewController;
    //    profileVC.user_data = sender;
        
    }else if ([[segue identifier] isEqualToString:@"goToMatchedConflict"]) {
        
        
     //   self.definesPresentationContext = YES;
        
        
        NewMatchConflictViewController *matchVC = (NewMatchConflictViewController *)segue.destinationViewController;
        matchVC.matched_user = sender;
        matchVC.view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        matchVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }else if ([[segue identifier] isEqualToString:@"goToMatched"]) {
        
        
        //   self.definesPresentationContext = YES;
        
        
        NewMatchViewController *matchVC = (NewMatchViewController *)segue.destinationViewController;
        matchVC.matched_user = sender;
        matchVC.view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        matchVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
}

-(UIColor*)greyblueColor{
    
    return [UIColor colorWithRed:0.47 green:0.53 blue:0.60 alpha:1.0];
}


-(UIColor*)purpleColor{
    return [UIColor colorWithRed:0.43 green:0.40 blue:0.77 alpha:1.0];
}

-(UIColor*)redShadow{
    return [UIColor colorWithRed:0.75 green:0.22 blue:0.17 alpha:1.0];
}

-(UIColor*)blueShadow{
    return [UIColor colorWithRed:0.19 green:0.84 blue:0.78 alpha:1.0];
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
