//
//  PhotoCropViewController.m
//  DateApp
//
//  Created by Neil Ballard on 1/11/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

#import "PhotoCropViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PhotoCropViewController ()

@end

@implementation PhotoCropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *Url = [NSURL URLWithString:self.selectedPhoto];
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    [manager downloadImageWithURL:Url
                          options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {  } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished && !error)
         {

             
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

@end
