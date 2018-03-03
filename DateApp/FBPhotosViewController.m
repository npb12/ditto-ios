//
//  FBPhotosViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/23/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "FBPhotosViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <DateApp-Swift.h>



@interface FBPhotosViewController ()<UIImageCropperProtocol>

@property (nonatomic, assign) BOOL didLoad;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UIView *gradientView;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;

@property (strong, nonatomic) UIImageCropper *cropper;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) UIImage *selectedImage;


@end

@implementation FBPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cropper = [UIImageCropper new];
    self.picker = [UIImagePickerController new];
    self.cropper.picker = self.picker;
    self.cropper.delegate = self;
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
    
    
    [PhotoManager getFacebookProfilePhotos:self.album completion:^(NSMutableArray *photos, NSError *error)
    {
    
        // here, update the UI to say "Not busy anymore"
        if (!error)
        {
            self.photos = photos;
            [self.collectionView reloadData];
        }
        else
        {
            
        }
        [self.activityIndicator stopAnimating];
    }];

    
    /*
        PhotoManager *albums = [PhotoManager singletonInstance];
        [albums getFacebookProfileInfos:2 completion:^{
            
                dispatch_async(dispatch_get_main_queue(), ^{
            
            self.didLoad = true;
            [self.collectionView reloadData];
                    
                        });
        }]; */

    
    CGFloat dimen = [[UIScreen mainScreen] bounds].size.width - 20;

    
    self.collectionViewWidth.constant = dimen;

    self.headerLabel.text = self.albumName;
    
    [self.headerLabel layoutIfNeeded];
    
    self.headerLabel.textColor = [DAGradientColor gradientFromColor:self.headerLabel.frame.size.width];
    
    UIColor *color1 = [UIColor colorWithRed:0.09 green:0.92 blue:0.85 alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:0.08 green:0.77 blue:0.90 alpha:1.0];
    UIColor *color3 = [UIColor colorWithRed:0.08 green:0.67 blue:0.94 alpha:1.0];
    
    [self.gradientView layoutIfNeeded];
    
    
    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.frame = self.gradientView.bounds;
    grad.colors = [NSArray arrayWithObjects:(id)([color1 colorWithAlphaComponent:1].CGColor),(id)([color2 colorWithAlphaComponent:1].CGColor),(id)([color3 colorWithAlphaComponent:1].CGColor),nil];
    grad.startPoint = CGPointMake(0.0,0.5);
    grad.endPoint = CGPointMake(1.0,0.5);
    [self.gradientView.layer insertSublayer:grad atIndex:0];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    //   UIImage *image = [self.photo_arary objectAtIndex:sourceIndexPath.item];
    
    //   [self.photo_arary removeObjectAtIndex:sourceIndexPath.item];
    
    //   [self.photo_arary setObject:image atIndexedSubscript:destinationIndexPath.item];
    
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (PhotosCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotosCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    

        PhotoManager *album = (PhotoManager*)[self.photos objectAtIndex:indexPath.row];
        CGFloat dimen = [[UIScreen mainScreen] bounds].size.width - 40;
        CGFloat size = dimen / 3;
   // cell.containerView.layer.cornerRadius = size / 2;
  //  cell.layer.masksToBounds = NO;
  //  cell.layer.cornerRadius = size / 2;
  //  cell.photo.layer.cornerRadius = size / 2;
        NSURL *Url = [NSURL URLWithString:album.photo];
        SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
        [manager downloadImageWithURL:Url
                              options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {  } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             if (image && finished && !error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     UIImage *resizedImage =  [image scaleImageToSize:CGSizeMake(size, size)];
                     cell.photo.image = resizedImage;
                 });
             }
         }];

    
        [cell setBackgroundColor:[UIColor lightGrayColor]];
        
    
    return cell;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}


- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat dimen = [[UIScreen mainScreen] bounds].size.width - 40;
    
    CGFloat size = dimen / 3;
    
    return CGSizeMake(size, size);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     CGFloat dimen = [[UIScreen mainScreen] bounds].size.width - 40;
     CGFloat size = dimen / 3;
     NSURL *Url = [NSURL URLWithString:album.photo];
     SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
     [manager downloadImageWithURL:Url
     options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {  } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
     if (image && finished && !error)
     {
     UIImage *resizedImage =  [image scaleImageToSize:CGSizeMake(size, size)];
     cell.photo.image = resizedImage;
     }
     }]; */
    
    PhotoManager *album = (PhotoManager*)[self.photos objectAtIndex:indexPath.row];
    NSURL *Url = [NSURL URLWithString:album.fullSizePhoto];
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    [manager downloadImageWithURL:Url
                          options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {  } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished && !error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.cropper.image = image;
                 [self presentViewController:self.cropper animated:YES completion:nil];
             });
         }
     }];
    

}

     

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didCropImageWithOriginalImage:(UIImage * _Nullable)originalImage croppedImage:(UIImage * _Nullable)croppedImage
{
    NSLog(@"didCropImageWithOriginalImage");
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
    
    [DAServer addFoto:croppedImage index:self.selectedIndex completion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            [self performSegueWithIdentifier:@"unwindToEdit" sender:self];
        });
    }];
    
}

-(void)didCancel
{
    [self.picker dismissViewControllerAnimated:YES completion:nil];
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
