//
//  FBPhotosViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/23/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "FBPhotosViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface FBPhotosViewController ()

@property (nonatomic, assign) BOOL didLoad;


@property (strong, nonatomic) IBOutlet UIView *gradientView;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;


@end

@implementation FBPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    
    PhotoManager *photo = (PhotoManager*)[self.photos objectAtIndex:indexPath.row];
    self.selectedPhoto = photo.fullSizePhoto;
    [self performSegueWithIdentifier:@"singlePhotoSegue" sender:self];
    
    /*
    
    PhotoManager *album = (PhotoManager*)[self.photos objectAtIndex:indexPath.row];
    
    SinglePhotoViewController *singleInstance = [SinglePhotoViewController singletonInstance];
    
    singleInstance.photo = album.fullSizePhoto;
    
    [self performSegueWithIdentifier:@"singlePhotoSegue" sender:self]; */
    
    /*
    
    self.croppingStyle = TOCropViewCroppingStyleDefault;
    
    UIImage *image = [UIImage imageNamed:@"girl1"];
    
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:self.croppingStyle image:image];
    cropController.delegate = self;
    
    [self presentViewController:cropController animated:YES completion:nil]; */

}

     

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"singlePhotoSegue"])
    {
        SinglePhotoViewController *vc = segue.destinationViewController;
        vc.selectedPhoto = self.selectedPhoto;
        vc.selectedIndex = self.selectedIndex;
        vc.photos = self.userPhotos;
    }
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
