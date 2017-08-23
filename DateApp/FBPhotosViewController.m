//
//  FBPhotosViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/23/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "FBPhotosViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@import TOCropViewController;


@interface FBPhotosViewController ()<TOCropViewControllerDelegate>

@property (nonatomic, assign) BOOL didLoad;

@property (nonatomic, assign) TOCropViewCroppingStyle croppingStyle; //The cropping style



@end

@implementation FBPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

        
        PhotoManager *albums = [PhotoManager singletonInstance];
        [albums getFacebookProfileInfos:2 completion:^{
            
                dispatch_async(dispatch_get_main_queue(), ^{
            
            self.didLoad = true;
            [self.collectionView reloadData];
                    
                        });
        }];

    
    CGFloat dimen = [[UIScreen mainScreen] bounds].size.width;

    
    self.collectionViewWidth.constant = dimen;

    
    
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
    
    
    
    if(self.didLoad){
        
        PhotoManager *album = (PhotoManager*)[[[PhotoManager singletonInstance] photos] objectAtIndex:indexPath.row];
        
        
        [cell.photo sd_setImageWithURL:[NSURL URLWithString:album.photo]
                    placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                             options:SDWebImageRefreshCached];
        
        
        [cell setBackgroundColor:[UIColor lightGrayColor]];
        
    }
    
    

    
    

    return cell;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    PhotoManager *album = [PhotoManager singletonInstance];
    
    if ([album.photos count] > 0) {
        return [album.photos count];
    }
    
    return 1;
}


- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CGFloat width = self.view.bounds.size.width / 3;
    CGFloat height = self.view.bounds.size.width / 3;
    
    
    return CGSizeMake(width, height);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    if ([[[PhotoManager singletonInstance] photos] count] > 0) {
        return 0;
    }
    
    return 0;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    PhotoManager *album = (PhotoManager*)[[[PhotoManager singletonInstance] photos] objectAtIndex:indexPath.row];
    
    SinglePhotoViewController *singleInstance = [SinglePhotoViewController singletonInstance];
    
    singleInstance.photo = album.fullSizePhoto;
    
    [self performSegueWithIdentifier:@"singlePhotoSegue" sender:self];
    
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
        vc.selectedIndex = self.selectedIndex;
        vc.photos = self.photos;
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
