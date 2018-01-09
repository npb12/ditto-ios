//
//  SinglePhotoViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/23/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "SinglePhotoViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SinglePhotoViewController ()
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) IBOutlet UIImageView *photoView;
- (IBAction)select:(id)sender;

- (IBAction)go_back:(id)sender;
@end

@implementation SinglePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SinglePhotoViewController *singletonInstance = [SinglePhotoViewController singletonInstance];
    
    self.photo = singletonInstance.photo;
    /*
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:singletonInstance.photo]
                placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                         options:SDWebImageRefreshCached]; */
    [self.photoView layoutIfNeeded];
    
    NSURL *Url = [NSURL URLWithString:self.photo];
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    [manager downloadImageWithURL:Url
                          options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {  } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished && !error)
         {
             
             UIImage *resizedImage =  [image scaleImageToSize:CGSizeMake(self.photoView.frame.size.width, self.photoView.frame.size.height)];
             self.photoView.image = resizedImage;
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

+ (id)singletonInstance {
    
    static SinglePhotoViewController *sharedDataAccess = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataAccess = [[self alloc] init];
    });
    
    return sharedDataAccess;
    
}

- (IBAction)select:(id)sender {
    
    if(self.selectedIndex <= self.photos.count - 1)
    {
        [self.photos setObject:self.photo atIndexedSubscript:self.selectedIndex];
    }
    else
    {
        [self.photos addObject:self.photo];
    }
    
    [[SDImageCache sharedImageCache]clearMemory];
    
    [DAServer updateAlbum:self.photos completion:^(NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [self dismissViewControllerAnimated:NO completion:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [self dismissViewControllerAnimated:NO completion:nil];
            });
            NSLog(@"An error occured with the server!");
        }
    }];
    
    /*PhotoManager *box = [PhotoManager singletonInstance];

    
    if (box.boxID == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(self.image) forKey:@"ProfileImage"];
    } else if(box.boxID == 2){
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(self.image) forKey:@"ProfileImage2"];
    }else if(box.boxID == 3){
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(self.image) forKey:@"ProfileImage3"];
    }else if(box.boxID == 4){
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(self.image) forKey:@"ProfileImage4"];
    }else if(box.boxID == 5){
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(self.image) forKey:@"ProfileImage5"];
    } */
    

}

- (IBAction)go_back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
