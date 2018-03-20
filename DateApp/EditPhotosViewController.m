//
//  EditPhotosViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/20/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "EditPhotosViewController.h"
#import "DAGradientColor.h"

@interface EditPhotosViewController ()<UIImagePickerControllerDelegate, UITextFieldDelegate>{
    CGPoint p;
  //  UIImageView *x_image;
    BOOL adding;
    CGFloat cellWidth, cellHeight;
    NSInteger selectedIndex;
    BOOL tvDidChange;
    BOOL notInitial, heightChanged;
}

@property (strong,nonatomic) NSMutableArray *photo_arary;
@property (nonatomic) BOOL didChange;

@property (strong, nonatomic) IBOutlet UIButton *touchBtn;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


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
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 1.1;

    CGFloat commonWidth = width;
    
    self.collectionViewWidth.constant = commonWidth;
    
        
    cellWidth = width / 3.4;
    cellHeight = cellWidth;
    
    self.collectionViewHeight.constant = cellHeight * 2.1;
    
    [self getProfile];

    [self.activityIndicator setHidden:YES];
    
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
    
 //   self.headerLabel.textColor = [DAGradientColor gradientFromColor:self.headerLabel.frame.size.width];
    
    if (notInitial)
    {
        if (adding)
        {
            [self getProfile];
            notInitial = YES;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    if (!notInitial)
    {
        if (adding)
        {
            [self.photo_arary removeAllObjects];
            [self getProfile];
        }
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

    [self.photo_arary removeAllObjects];
    
    [DAServer getProfile:^(User *user, NSError *error) {
    // here, update the UI to say "Not busy anymore"
    if (!error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.user = user;
            [self.tableView reloadData];
        });
        
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        
        if ([self.user.pics count] > 0)
        {
            dispatch_group_t group = dispatch_group_create();
            
            //__block NSInteger *count = 0;;
            
            for (int i = 0; i < [self.user.pics count]; i++)
            {
                dispatch_group_enter(group);
                
                [self downloadImage:[self.user.pics objectAtIndex:i] completion:^(UIImage *image, NSError *error)
                 {
                     if (image && !error)
                     {
                         NSLog(@"count is hit");
                         
                         int offset = i + 1;
                         //  [dict setValue:image forKey:[NSString stringWithFormat:@"%d", offset]];
                         [dict setObject:image forKey:[NSString stringWithFormat:@"%d", offset]];
                         
                         if ([dict count] == [self.user.pics count])
                         {
                             [self updatePhotos:dict dispatch:group];
                         }
                         
                     }
                     
                     dispatch_group_leave(group);
                     
                 }];
            }
        }
        
    }
    else
    {
        // update UI to indicate error or take remedial action
    }
    }];
}

-(void)updatePhotos:(NSDictionary*)dict dispatch:(dispatch_group_t)group
{
    
    self.photo_arary = [NSMutableArray new];
    
    for (int i = 1; i <= [dict count]; i++)
    {
        [self.photo_arary addObject:[dict objectForKey:[NSString stringWithFormat:@"%d", i]]];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
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
                                    CGSize size = CGSizeMake(cellWidth, cellHeight);
                                    UIImage *resizedImage =  [image scaleImageToSize:size];
                                    completion(resizedImage, nil);
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
        
//        [cell setBackgroundColor:[UIColor whiteColor]];
        
        cell.containerView.layer.cornerRadius = cellWidth / 2;
        cell.layer.masksToBounds = NO;
        cell.layer.cornerRadius = cellWidth / 2;
        cell.photo.layer.cornerRadius = cellWidth / 2;

        
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
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Yes"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  
                                                                  NSString *pos = [NSString stringWithFormat:@"%ld", tag];
                                                                  
                                                                  [self.activityIndicator setHidden:NO];
                                                                  [self.activityIndicator startAnimating];
                                                                  
                                                                  [DAServer deletePhoto:pos completion:^(NSError *error) {
                                                                        dispatch_async(dispatch_get_main_queue(), ^
                                                                                     {
                                                                                                                                        [self.activityIndicator stopAnimating];                   [self.photo_arary removeObjectAtIndex:tag];
                                                                                         [self.user.pics removeObjectAtIndex:tag];
                                                                                         [self.collectionView reloadData];
                                                                                     });
                                                                  }];
                                                                  
                                                                  
                                                              }];
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Cancel"
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
 //   PhotoManager *box = [PhotoManager singletonInstance];
    
 //   box.boxID = [self.photo_arary count] + 1;
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

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 2:
            return 150.0;
        default:
            return 58.0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    /*    ConnectionsTableViewCell *cell = (ConnectionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier]; */
    
    
    UserInfoTableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        
        cell = (UserInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"textFieldIdentifier"];
        cell.textField.delegate = self;
        cell.textField.tag = 0;
        cell.textField.placeholder = @"Current place of work";
        if (self.user.job.length)
        {
            [cell.textField setText:self.user.job];
        }
            /*
            cell.distance_slider.minimumValue = 1.0;
            cell.distance_slider.maximumValue = 90.0;
            
            [cell.distance_slider addTarget:self
                                     action:@selector(distanceValueChanged:)
                           forControlEvents:UIControlEventValueChanged];
            cell.distance_slider.minimumTrackTintColor = [DAGradientColor gradientFromColor:cell.distance_slider.frame.size.width];
            cell.sliderLabel.text = @"Maximum Distance";
            // cell.sliderDataLabel.text = @"30 mi. Away";
            [cell.doubleSlider setHidden:YES]; */
            
    }
    else if (indexPath.section == 1)
    {
        cell = (UserInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"textFieldIdentifier"];
        cell.textField.delegate = self;
        cell.textField.tag = 1;
        cell.textField.placeholder = @"School or place of education";
        if (self.user.edu.length)
        {
            [cell.textField setText:self.user.edu];
        }
    }
    else if (indexPath.section == 2)
    {
        cell = (UserInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"textViewIdentifier"];
        cell.textView.delegate = self;
        if (self.user.bio.length)
        {
            [cell.textView setText:self.user.bio];
            [cell.textViewPlaceholder setHidden:YES];
        }
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section 
{
    return 35.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20,0,100,40)];
    
    
    switch (section) {
        case 0:
        case 1:
        case 2:
            if (section == 0) {
                UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20,5,200,40)];
                lbl.text = @"CURRENT WORK";
                footer.backgroundColor=[UIColor clearColor];
                lbl.backgroundColor = [UIColor clearColor];
                lbl.textAlignment = NSTextAlignmentLeft;
                [lbl setNumberOfLines:1];//set line if you need
                [lbl setFont:[UIFont fontWithName:@"RooneySansLF-Regular" size:12.0]];                [lbl setTextColor:[self headerColor]];
                [footer addSubview:lbl];
                break;
                
            }else if(section == 1){
                UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20,0,200,40)];
                lbl.text = @"EDUCATION";
                footer.backgroundColor=[UIColor clearColor];
                lbl.backgroundColor = [UIColor clearColor];
                lbl.textAlignment = NSTextAlignmentLeft;
                [lbl setNumberOfLines:1];//set line if you need
                [lbl setFont:[UIFont fontWithName:@"RooneySansLF-Regular" size:12.0]];//font size and style
                [lbl setTextColor:[self headerColor]];
                [footer addSubview:lbl];
                /*
                 self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 80,0,100,40)];
                 self.distanceLabel.text = self.distance;
                 self.distanceLabel.backgroundColor = [UIColor clearColor];
                 self.distanceLabel.textAlignment = NSTextAlignmentLeft;
                 [self.distanceLabel setNumberOfLines:1];
                 [self.distanceLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];//font size and style
                 [self.distanceLabel setTextColor:[self othBlueColor]];
                 [footer addSubview:self.distanceLabel]; */
                
            }else{
                UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20,0,200,40)];
                lbl.text = @"ABOUT ME";
                footer.backgroundColor=[UIColor clearColor];
                lbl.backgroundColor = [UIColor clearColor];
                lbl.textAlignment = NSTextAlignmentLeft;
                [lbl setNumberOfLines:1];//set line if you need
                [lbl setFont:[UIFont fontWithName:@"RooneySansLF-Regular" size:12.0]];//font size and style
                [lbl setTextColor:[self headerColor]];
                [footer addSubview:lbl];
                // lbl.text = @"Age Range:";
                /*self.ageRangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 80,0,100,40)];
                 self.ageRangeLabel.text = self.ageRange;
                 self.ageRangeLabel.backgroundColor = [UIColor clearColor];
                 self.ageRangeLabel.textAlignment = NSTextAlignmentLeft;
                 [self.ageRangeLabel setNumberOfLines:1];
                 [self.ageRangeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];//font size and style
                 [self.ageRangeLabel setTextColor:[self othBlueColor]];
                 [footer addSubview:self.ageRangeLabel]; */
                
            }
            /*
             footer.backgroundColor=[UIColor clearColor];
             lbl.backgroundColor = [UIColor clearColor];
             lbl.textAlignment = NSTextAlignmentLeft;
             [lbl setNumberOfLines:1];//set line if you need
             [lbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];//font size and style
             [lbl setTextColor:[UIColor blackColor]];
             [footer addSubview:lbl]; */
            break;
        default:
            break;
    }
    
    
    
    return footer;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
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
    
    
    [DAServer uploadPhoto:image index:selectedIndex completion:^(NSError *error) {
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string containsString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    tvDidChange = YES;
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:2];
    UserInfoTableViewCell *cell = (UserInfoTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.textViewPlaceholder setHidden:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //[self.scrollView setContentOffset:CGPointMake(0, -100) animated:YES];
}

- (void)textViewDidEndEditing:(UITextField *)textField
{
    //[self.scrollView setContentOffset:CGPointMake(0, -100) animated:YES];
}

- (IBAction)dismissAction:(id)sender
{
    [[self view] endEditing:YES];
    [self.touchBtn setUserInteractionEnabled:NO];
    [self.touchBtn setHidden:YES];
}


- (IBAction)closeAction:(id)sender
{
    
    if (!tvDidChange)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:2];
    UserInfoTableViewCell *cell = (UserInfoTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *bio =  cell.textView.text;
    
        indexPath =[NSIndexPath indexPathForRow:0 inSection:1];
        cell = (UserInfoTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
        NSString *edu =  cell.textField.text;

        indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
        cell = (UserInfoTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
        NSString *job =  cell.textField.text;
    
    
    NSDictionary *dict = @{
                                  @"bio": bio,
                                  @"occupation": job,
                                  @"education": edu
                                  };
    
    [self updateData:dict];

    /*
    NSString *bioText = self.bioTV.text;
    //update user profile with bio/occupation and string description
    [DAServer updateProfile:@"PUT" editType:@"bio" description:bioText completion:^(NSError *error) {
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
    }]; */
}

-(void)updateData:(NSDictionary*)dict
{
    [DAServer updateProfile:@"PUT" data:dict completion:^(NSError *error) {
        // here, update the UI to say "Not busy anymore"
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self dismissViewControllerAnimated:YES completion:nil];
                       });
    }];
}

-(UIColor*)headerColor
{
    return [UIColor colorWithRed:0.56 green:0.56 blue:0.58 alpha:1.0];
}


@end
