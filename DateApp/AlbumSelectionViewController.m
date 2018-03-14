//
//  AlbumSelectionViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/20/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "AlbumSelectionViewController.h"
#import <DateApp-Swift.h>

@interface AlbumSelectionViewController ()<UIImageCropperProtocol>

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIImageCropper *cropper;
@property (strong, nonatomic) UIImagePickerController *picker;
@end

@implementation AlbumSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.activityIndicator.hidden = YES;

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
    /*
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } */
    
    self.cropper = [UIImageCropper new];
    self.picker = [UIImagePickerController new];
    self.cropper.picker = self.picker;
    self.cropper.delegate = self;
    

    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.picker animated:YES completion:nil];
    

    
    /*
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
   // imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    UIPopoverPresentationController *presentationController = imagePickerController.popoverPresentationController;
    presentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    _imagePickerController = imagePickerController; // we need this for later
    
    [self presentViewController:self.imagePickerController animated:YES completion:^{
        //.. done presenting
    }]; */
    /*
    dispatch_async(dispatch_get_main_queue(), ^
                   {

                       
                   }); */
    
}

- (void)didCropImageWithOriginalImage:(UIImage * _Nullable)originalImage croppedImage:(UIImage * _Nullable)croppedImage
{
    NSLog(@"didCropImageWithOriginalImage");

    
    [DAServer uploadPhoto:croppedImage index:self.selectedIndex completion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
}

-(void)didCancel
{
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}

/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [DAServer addFoto:image index:self.selectedIndex completion:^(NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^
                           {

                           });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                              
                               
                           });
            NSLog(@"An error occured with the server!");
        }
    }];
    
    _imagePickerController = nil;

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        //.. done dismissing
    }];
} */

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
