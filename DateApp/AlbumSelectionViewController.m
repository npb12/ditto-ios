//
//  AlbumSelectionViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/20/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "AlbumSelectionViewController.h"

@interface AlbumSelectionViewController ()<UIImagePickerControllerDelegate>

@end

@implementation AlbumSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"fbAlbumsSegue"])
    {
        FBAlbumsViewController *vc = segue.destinationViewController;
        vc.selectedIndex = self.selectedIndex;
        vc.photos = self.user.pics;
    }

}

-(IBAction)gotoFB
{
    [self performSegueWithIdentifier:@"fbAlbumsSegue" sender:self];
}



-(IBAction)gotoCamRoll
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = info[UIImagePickerControllerEditedImage];
    if (!image)
        image = info[UIImagePickerControllerOriginalImage];
    
    
    [DAServer addFoto:image index:self.selectedIndex completion:^(NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                               [self dismissViewControllerAnimated:NO completion:nil];
                           });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                               [self dismissViewControllerAnimated:NO completion:nil];

                           });
            NSLog(@"An error occured with the server!");
        }
    }];

    
    
}

- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
