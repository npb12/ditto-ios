//
//  FBPhotosViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/23/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "FBPhotosViewController.h"

@interface FBPhotosViewController ()

@property (nonatomic, assign) BOOL didLoad;


@end

@implementation FBPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    /*
    [self.photo_arary addObject:[UIImage imageNamed:@"girl1"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl2"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl3"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl2"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl1"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl1"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl2"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl3"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl2"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl1"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl1"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl2"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl3"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl2"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl1"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl1"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl2"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl3"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl2"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl1"]]; */
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PhotoManager *albums = [PhotoManager singletonInstance];
        [albums getFacebookProfileInfos:2 completion:^{
            
            self.didLoad = true;
            [self.collectionView reloadData];
        }];
    });
    
    
    self.collectionViewWidth.constant = self.view.frame.size.width / 1.1;

    
    
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
        
        cell.photo.image = album.photo;
        
        
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
    
    
    CGFloat width = self.view.bounds.size.width / 3.4;
    CGFloat height = self.view.bounds.size.width / 3.4;
    
    
    return CGSizeMake(width, height);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 3;
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
