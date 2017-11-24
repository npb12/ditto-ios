//
//  EditPhotosViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/20/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "EditPhotosViewController.h"
#import "DAGradientColor.h"

@interface EditPhotosViewController ()<UIImagePickerControllerDelegate>{
    CGPoint p;
  //  UIImageView *x_image;
    BOOL adding;
    CGFloat cellWidth, cellHeight;
    NSInteger selectedIndex;
    BOOL tvDidChange;
}

@property (strong,nonatomic) NSMutableArray *photo_arary;
@property (nonatomic) BOOL didChange;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (strong, nonatomic) IBOutlet UILabel *workLabel;
@property (strong, nonatomic) IBOutlet UILabel *eduLabel;
@property (strong, nonatomic) IBOutlet UITextView *bioTV;


@end

@implementation EditPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
/*    CAGradientLayer *gradient = [CAGradientLayer layer];
    [self.view.layer insertSublayer:gradient atIndex:0];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)([UIColor whiteColor].CGColor),(id)([UIColor colorWithRed:0.95 green:0.95 blue:0.98 alpha:1.0].CGColor),nil];
    gradient.startPoint = CGPointMake(0.25,0.0);
    gradient.endPoint = CGPointMake(0.25,1.0);
    self.view.layer.masksToBounds = YES; */
    
    self.didChange = NO;
    
    self.photo_arary = [[NSMutableArray alloc] init];
    
    adding = NO;

    CGFloat commonWidth = self.view.frame.size.width / 1.1;
    
    self.collectionViewWidth.constant = commonWidth;
    
        
    cellWidth = self.view.bounds.size.width / 3.6;
    cellHeight = self.view.bounds.size.width / 3.6;
    
    self.collectionViewHeight.constant = cellHeight * 2.1;
    
    if (self.user.bio)
    {
        self.bioTV.text = self.user.bio;
    }
    
    if (self.user.edu)
    {
        self.eduLabel.text = self.user.edu;
    }
    
    if (self.user.job)
    {
        self.workLabel.text = self.user.job;
    }

    [self getProfile];

    
/*
    UILongPressGestureRecognizer *lpgr
    = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = .1; // To detect after how many seconds you want shake the cells
    lpgr.delegate = self;
    [self.collectionView addGestureRecognizer:lpgr]; */
    [self.collectionView setClipsToBounds:NO];
    
 //   lpgr.delaysTouchesBegan = YES;
    
    /// This will be helpful to restore the animation when clicked outside the cell
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handleTap:)];
    //lpgr.minimumPressDuration = .3; //seconds
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    if (adding) {
        [self.photo_arary removeAllObjects];
        [self getProfile];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    if (self.didChange) {
        [self syncOrder];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getProfile{

    [DAServer getProfile:@"" completion:^(User *user, NSError *error) {
    // here, update the UI to say "Not busy anymore"
    if (!error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //self.photo_arary = user.pics;
            if (user.bio)
            {
                self.bioTV.text = user.bio;
            }
            
            if (user.edu)
            {
                self.eduLabel.text = user.edu;
            }
            
            if (user.job)
            {
                self.workLabel.text = user.job;
            }
        });
        
        if ([self.user.pics count] > 0)
        {
            dispatch_group_t group = dispatch_group_create();
            
            
            for (int i = 0; i < [self.user.pics count]; i++)
            {
                dispatch_group_enter(group);
                
                [self downloadImage:[self.user.pics objectAtIndex:i] completion:^(UIImage *image, NSError *error)
                 {
                     if (image && !error)
                     {
                        // [self.photo_arary setObject:image atIndexedSubscript:i];
                         [self.photo_arary addObject:image];
                     }
                     
                     dispatch_group_leave(group);
                     
                 }];
            }
            
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
        
    }
    else
    {
        // update UI to indicate error or take remedial action
    }
    }];



}


- (void)downloadImage:(NSString*)url
             completion:(void (^)(UIImage *, NSError *))completion
{
    NSURL *imgURL = [NSURL URLWithString:url];

    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    [manager downloadImageWithURL:imgURL
                          options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {  } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                            {
                                if (image && finished && !error)
                                {
                                    completion(image, nil);
                                }
                                else
                                {
                                    completion(nil, error);
                                }
                            }];
    
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    UIImage *image = [self.photo_arary objectAtIndex:sourceIndexPath.row];
    
    [self.photo_arary removeObjectAtIndex:sourceIndexPath.row];
    
    [self.photo_arary insertObject:image atIndex:destinationIndexPath.row];
    self.didChange = YES;
    
    
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (PhotosCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotosCollectionViewCell* cell;
    
    if (cell == nil)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
        
        [cell setBackgroundColor:[UIColor whiteColor]];

        
        /*
        NSInteger count = [self.photo_arary count];
        
        
       // CGFloat xImageSize = 24;
        
        cell.photo.image = nil;
        cell.actionIcon.image = nil; */
   //     x_image = nil;
        
        if (indexPath.row < [self.photo_arary count])
        {
            if ([self.photo_arary objectAtIndex:indexPath.row])
            {
                
                /*
                [cell.photo sd_setImageWithURL:[NSURL URLWithString:[self.photo_arary objectAtIndex:indexPath.row]]
                              placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                                       options:SDWebImageRefreshCached]; */
                
                UIImage *img = [self.photo_arary objectAtIndex:indexPath.row];
                

                [cell.photo setImage:img];
                
                if (indexPath.row > 0)
                {
                    [cell.photo setHidden:NO];
                    [cell.actionIcon setImage:[UIImage imageNamed:@"remove_image"]];
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self action:@selector(handleBtnPress:)];
                    [cell.actionIcon setUserInteractionEnabled:YES];
                    tapGesture.delegate = self;
                    [cell.actionIcon addGestureRecognizer:tapGesture];
                    [cell.actionIcon setTag:indexPath.row];
                }
            }
        }
        else
        {
            if (indexPath.row > 0)
            {
                [cell.actionIcon setImage:[UIImage imageNamed:@"add_image"]];
            }
            
        }
        
    

        /*
        if (indexPath.row > 0 && (count - 1) >= indexPath.row) {
            [cell.actionIcon setImage:[UIImage imageNamed:@"remove_image"]];
        } */

        
        if (indexPath.row > 0)
        {
            
            /*
            x_image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, xImageSize, xImageSize)];
            //  x_image.layer.cornerRadius = 10;
            x_image.layer.masksToBounds = NO;
            x_image.center = CGPointMake(cellWidth - 5, cellHeight - 5);
            [cell bringSubviewToFront:x_image];
            [cell.photo setClipsToBounds:NO];
            [cell setClipsToBounds:NO];
            //  [x_image setBackgroundColor:[UIColor grayColor]];
            [x_image setImage:[UIImage imageNamed:@"add_image"]];
            
            [cell addSubview:x_image]; */
            
            
            
            
            /*
            if (indexPath.row <= (count - 1) && count > 0)
            {
            //    [x_image setImage:[UIImage imageNamed:@"remove_image"]];
           //     [x_image setTag:indexPath.row];
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(handleBtnPress:)];
                [cell.actionIcon setUserInteractionEnabled:YES];
                tapGesture.delegate = self;
                [cell.actionIcon addGestureRecognizer:tapGesture];
                
            } */
        }
        
        /*
        
        if (indexPath.row == 0)
        {
            [cell.actionIcon setHidden:YES];
        }
        else
        {
            [cell.actionIcon setImage:[UIImage imageNamed:@"add_image"]];
            [cell.actionIcon setHidden:NO];
            
            if (!cell.photo.image)
            {
    //            [cell.photo setHidden:YES];
            }
            else
            {
  //              [cell.photo setHidden:NO];
                [cell.actionIcon setImage:[UIImage imageNamed:@"add_image"]];
            }
        }
        
        
        
        
        if (indexPath.row <= count - 1 && count > 0)
        {
                        
            [cell.photo sd_setImageWithURL:[NSURL URLWithString:[self.photo_arary objectAtIndex:indexPath.row]]
                          placeholderImage:[UIImage imageNamed:@"Gradient_BG"]
                                   options:SDWebImageRefreshCached];
          //  [x_image setHidden:YES];
        } */
        
    }
    
    

    return cell;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 5;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cellWidth, cellHeight);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"longPressed"] isEqualToString:@"yes"])
    {
    
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
        [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"longPressed"];
        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"singleTap"];
        //_deleteButton = [[UIButton alloc] initWithFrame:CGRectZero];
        //[cell addSubview:_deleteButton];
        //[_deleteButton removeFromSuperview];
        [self.collectionView reloadData];
        
    } else {
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"longPressed"] isEqualToString:@"yes"])
        {
            if (self.photo_arary.count > 1) {
                [self removePhoto:indexPath];
                self.didChange = YES;
            }
        }else{
            
        }
    }
        
    }
    

}


-(void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    /*
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    } */
    p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath){
        
        selectedIndex = indexPath.row;
        adding = YES;
        [self performSegueWithIdentifier:@"selectionSegue" sender:self];
        /*
        NSLog(@"couldn't find index path");
        [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"longPressed"];
        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"singleTap"];
        //_deleteButton = [[UIButton alloc] initWithFrame:CGRectZero];
        //[cell addSubview:_deleteButton];
        //[_deleteButton removeFromSuperview];
        [self.collectionView reloadData]; */
    }
    
    
    /*
    else {
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"longPressed"] isEqualToString:@"yes"])
        {
            if (self.photo_arary.count > 1) {
                [self removePhoto:indexPath];
                self.didChangeOrder = YES;
            }
        }else{
            
        }
    }
     */
    
}
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    switch(gestureRecognizer.state){
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:self.collectionView]];
            if(selectedIndexPath == nil) break;
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self.collectionView updateInteractiveMovementTargetPosition:[gestureRecognizer locationInView:gestureRecognizer.view]];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self.collectionView endInteractiveMovement];
            break;
        }
        default:
        {
            [self.collectionView cancelInteractiveMovement];
            break;
        }
    }
    
    /*
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            if ([self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:self.collectionView]]) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:[self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:self.collectionView]]];
            }else{
                break;
            }
        case UIGestureRecognizerStateChanged:
            [self.collectionView updateInteractiveMovementTargetPosition:[gestureRecognizer locationInView:gestureRecognizer.view]];
        case UIGestureRecognizerStateEnded:
            [self.collectionView endInteractiveMovement];
        default:
            [self.collectionView cancelInteractiveMovement];
    } */
    
    /*
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        
        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"longPressed"];
        [self.collectionView reloadData];
        
    } */
}

-(void)handleBtnPress:(id)sender
{
    
    long tag = ((UITapGestureRecognizer *)sender).view.tag;
    
    if (tag > 0)
    {
        
        NSString *message = @"Remove photo from album?";
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete"
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"YES"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  [self.photo_arary removeObjectAtIndex:tag];
                                                                  [self.user.pics removeObjectAtIndex:tag];
                                                                  [self.collectionView reloadData];
                                                                  self.didChange = YES;
                                                                  
                                                              }];
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"CANCEL"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   
                                                               }];
        
        [alert addAction:firstAction]; // 4
        [alert addAction:secondAction]; // 5
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }

}

-(void)removePhoto:(NSIndexPath *)indexPath
{

    [self.collectionView performBatchUpdates:^{
        [self.photo_arary removeObjectAtIndex:indexPath.row];
      //  NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
 //       [self.collectionView.collectionViewLayout invalidateLayout];
    } completion:nil];
    
    
 //   [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"longPressed"];
  //  [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"singleTap"];
    //_deleteButton = [[UIButton alloc] initWithFrame:CGRectZero];
    //[cell addSubview:_deleteButton];
    //[_deleteButton removeFromSuperview];
 //   [self.collectionView reloadData];
    
}

-(void)deleteyourItem
{
    //delete your item based on the `indexpath` from your collectionViewArray here.
    //OR If you are accessing the database to display the collectionView, you can compare the value fetched based on the `indexPath`, with your database value and then delete it.
    
    // Reload your collectionView after deletion
}


- (IBAction)go_back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)delete_photos:(id)sender {
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"singleTap"] isEqualToString:@"yes"])
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"longPressed"];
        [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"singleTap"];
    }else{
        [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"longPressed"];
        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"singleTap"];
    }
    

    //_deleteButton = [[UIButton alloc] initWithFrame:CGRectZero];
    //[cell addSubview:_deleteButton];
    //[_deleteButton removeFromSuperview];
    [self.collectionView reloadData];
}

- (void)goto_albums
{
    adding = YES;
    PhotoManager *box = [PhotoManager singletonInstance];
    
    box.boxID = [self.photo_arary count] + 1;
    [self performSegueWithIdentifier:@"fbAlbumsSegue" sender:self];
}

-(void)syncOrder{
    
    /*
    for (int i = 0; i < 5; i++) {
        switch (i) {
            case 0:
                if ([self.photo_arary count] > i) {
                    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation([self.photo_arary objectAtIndex:i]) forKey:@"ProfileImage"];
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ProfileImage"];
                }
                break;
            case 1:
                if ([self.photo_arary count] > i) {
                    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation([self.photo_arary objectAtIndex:i]) forKey:@"ProfileImage2"];
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ProfileImage2"];
                }
                break;
            case 2:
                if ([self.photo_arary count] > i) {
                    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation([self.photo_arary objectAtIndex:i]) forKey:@"ProfileImage3"];
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ProfileImage3"];
                }
                break;
            case 3:
                if ([self.photo_arary count] > i) {
                    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation([self.photo_arary objectAtIndex:i]) forKey:@"ProfileImage4"];
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ProfileImage4"];
                }
                break;
            case 4:
                if ([self.photo_arary count] > i) {
                    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation([self.photo_arary objectAtIndex:i]) forKey:@"ProfileImage5"];
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ProfileImage5"];
                }
                break;
            default:
                break;
        }
    } */
    
    
    
    [DAServer updateAlbum:self.user.pics completion:^(NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                              // [self dismissViewControllerAnimated:NO completion:nil];
                               [[SDImageCache sharedImageCache]clearMemory];
                           });
        } else {

        }
    }];
    
}

- (IBAction) onSelectPhoto:(id)sender
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose"
                                                                   message:@"Add a photo by:"
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Photo Roll"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [self onGalleryPressed:self];
                                                          }];

    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Camera"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [self onCameraPressed:self];
                                                          }];
    
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Facebook Photos"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               [self goto_albums];
                                                           }];
    
    
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [alert addAction:thirdAction];

    
    [self presentViewController:alert animated:YES completion:nil]; // 6
}

#pragma mark - Photo Selector

- (IBAction) onCameraPressed:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (IBAction) onGalleryPressed:(id)sender
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
    
   // image = [image uuScaleAndCropToSize:CGSizeMake(200,200)];
    
 //   self.userImage = image;
    
    
    [DAServer addFoto:image index:selectedIndex completion:^(NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                           });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                           });
            NSLog(@"An error occured with the server!");
        }
    }];
    
    /*
    [DAServer addLocalPhoto:image index:selectedIndex  completion:^(NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            });
            NSLog(@"An error occured with the server!");
        }
    }]; */

    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"selectionSegue"])
    {
        AlbumSelectionViewController *vc = segue.destinationViewController;
        vc.selectedIndex = selectedIndex;
        vc.user = self.user;
    }
}

-(UIColor*)blueColor{
    return [UIColor colorWithRed:0.18 green:0.49 blue:0.83 alpha:1.0];
}


-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text containsString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    tvDidChange = YES;
    
    return YES;
}

- (IBAction)closeAction:(id)sender
{
    
    if (!tvDidChange)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    NSString *bioText = self.bioTV.text;
    //update user profile with bio/occupation and string description
    [DAServer updateProfile:@"bio" description:bioText completion:^(NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [self dismissViewControllerAnimated:YES completion:nil];
                           });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [self dismissViewControllerAnimated:YES completion:nil];
                           });
            NSLog(@"An error occured with the server!");
        }
    }];
}


@end
