//
//  EditPhotosViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/20/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "EditPhotosViewController.h"

@interface EditPhotosViewController (){
    CGPoint p;
    UIImageView *x_image;
    BOOL adding;
    CGFloat cellWidth, cellHeight;
}

@property (strong,nonatomic) NSMutableArray *photo_arary;
@property (nonatomic) BOOL didChangeOrder;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgWidth;

@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view1Height;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view1Width;


@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view2Width;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view2Height;

@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view3Height;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view3Width;

@property (strong, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view4Width;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view4Height;

@property (strong, nonatomic) IBOutlet UIView *view5;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view5Width;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view5Height;

@end

@implementation EditPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    [self.view.layer insertSublayer:gradient atIndex:0];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)([UIColor whiteColor].CGColor),(id)([UIColor colorWithRed:0.95 green:0.95 blue:0.98 alpha:1.0].CGColor),nil];
    gradient.startPoint = CGPointMake(0.25,0.0);
    gradient.endPoint = CGPointMake(0.25,1.0);
    self.view.layer.masksToBounds = YES;
    
    self.didChangeOrder = NO;
    
    self.photo_arary = [[NSMutableArray alloc] init];

    [self getPhotos];
    
    adding = NO;

    CGFloat commonWidth = self.view.frame.size.width / 1.1;
    
    self.collectionViewWidth.constant = commonWidth;
    
    self.bgWidth.constant = commonWidth;
    
    cellWidth = self.view.bounds.size.width / 3.4;
    cellHeight = self.view.bounds.size.width / 3.4;
    
    self.view1.layer.borderWidth = 2;
    self.view1.layer.borderColor = [self blueColor].CGColor;
    self.view1Height.constant = cellHeight;
    self.view1Width.constant = cellWidth;
    self.view1.layer.cornerRadius = 5;
    
    self.view2.layer.borderWidth = 2;
    self.view2.layer.borderColor = [UIColor grayColor].CGColor;
    self.view2Height.constant = cellHeight;
    self.view2Width.constant = cellWidth;
    self.view2.layer.cornerRadius = 5;
    
    self.view3.layer.borderWidth = 2;
    self.view3.layer.borderColor = [UIColor grayColor].CGColor;
    self.view3Height.constant = cellHeight;
    self.view3Width.constant = cellWidth;
    self.view3.layer.cornerRadius = 5;
    
    self.view4.layer.borderWidth = 2;
    self.view4.layer.borderColor = [UIColor grayColor].CGColor;
    self.view4Height.constant = cellHeight;
    self.view4Width.constant = cellWidth;
    self.view4.layer.cornerRadius = 5;
    
    self.view5.layer.borderWidth = 2;
    self.view5.layer.borderColor = [UIColor grayColor].CGColor;
    self.view5Height.constant = cellHeight;
    self.view5Width.constant = cellWidth;
    self.view5.layer.cornerRadius = 5;
    

    UILongPressGestureRecognizer *lpgr
    = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = .1; // To detect after how many seconds you want shake the cells
    lpgr.delegate = self;
    [self.collectionView addGestureRecognizer:lpgr];
    [self.collectionView setClipsToBounds:NO];
    
 //   lpgr.delaysTouchesBegan = YES;
    
    /// This will be helpful to restore the animation when clicked outside the cell
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handleTap:)];
    //lpgr.minimumPressDuration = .3; //seconds
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    if (adding) {
        [self.photo_arary removeAllObjects];
        [self getPhotos];
        [self.collectionView reloadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    if (self.didChangeOrder) {
        [self syncOrder];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getPhotos{

    /*
    UIImage* image = [[DataAccess singletonInstance] getProfileImage];
    UIImage* image2 = [[DataAccess singletonInstance] getProfileImage2];
    UIImage* image3 = [[DataAccess singletonInstance] getProfileImage3];
    UIImage* image4 = [[DataAccess singletonInstance] getProfileImage4];
    UIImage* image5 = [[DataAccess singletonInstance] getProfileImage5]; */
    
    [self.photo_arary addObject:[UIImage imageNamed:@"girl1"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl1"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl1"]];
    [self.photo_arary addObject:[UIImage imageNamed:@"girl1"]];
 //   [self.photo_arary addObject:[UIImage imageNamed:@"girl1"]];

    
    /*
    if (image != nil) {
        [self.photo_arary addObject:image];
    }
    
    if (image2 != nil) {
        [self.photo_arary addObject:image2];
    }
    
    if (image3 != nil) {
        [self.photo_arary addObject:image3];
    }
    
    if (image4 != nil) {
        [self.photo_arary addObject:image4];
    }
    
    if (image5 != nil) {
        [self.photo_arary addObject:image5];
    } */
    
    

}


-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    UIImage *image = [self.photo_arary objectAtIndex:sourceIndexPath.row];
    
    [self.photo_arary removeObjectAtIndex:sourceIndexPath.row];
    
    [self.photo_arary insertObject:image atIndex:destinationIndexPath.row];
    self.didChangeOrder = YES;
    
    
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (PhotosCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotosCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    cell.photo.image = [self.photo_arary objectAtIndex:indexPath.row];

    
    
    [cell setBackgroundColor:[UIColor lightGrayColor]];

    

    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"longPressed"] isEqualToString:@"yes"])
    {
        CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [anim setToValue:[NSNumber numberWithFloat:0.0f]];
        [anim setFromValue:[NSNumber numberWithDouble:M_PI/64]];
        [anim setDuration:0.1];
        [anim setRepeatCount:NSUIntegerMax];
        [anim setAutoreverses:YES];
        cell.layer.shouldRasterize = YES;
        [cell.layer addAnimation:anim forKey:@"SpringboardShake"];
        CGFloat delButtonSize = 50;
        CGFloat xImageSize = 20;

        
        x_image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, xImageSize, xImageSize)];
        x_image.layer.cornerRadius = 10;
        x_image.layer.masksToBounds = NO;
        x_image.center = CGPointMake(5, 5);
        [cell bringSubviewToFront:x_image];
        [cell.photo setClipsToBounds:NO];
        [cell setClipsToBounds:NO];
      //  [x_image setBackgroundColor:[UIColor grayColor]];
        [x_image setImage:[UIImage imageNamed:@"xButton"]];
        
    //    [_deleteButton setImage: [UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [cell addSubview:x_image];
        
    }
    
    else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"singleTap"] isEqualToString:@"yes"])
    {
        
        for(UIView *subview in [cell subviews]) {
            if([subview isKindOfClass:[UIImageView class]]) {
                [subview removeFromSuperview];
            } else{
                // Do nothing - not a UIButton or subclass instance

            }
        }
        [cell.layer removeAllAnimations];
        //            _deleteButton.hidden = YES;
        //            [_deleteButton removeFromSuperview];
        
        
       //     [cell setBackgroundColor:[UIColor lightGrayColor]];

        
    }
    

    return cell;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.photo_arary count];
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
    
    return 3;
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
                self.didChangeOrder = YES;
            }
        }else{
            
        }
    }
        
    }

}


-(void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    NSLog(@"singleTap");
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
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
                self.didChangeOrder = YES;
            }
        }else{
            
        }
    }
    
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

- (IBAction)goto_albums:(id)sender {
    adding = YES;
    PhotoManager *box = [PhotoManager singletonInstance];
    
    box.boxID = [self.photo_arary count] + 1;
    [self performSegueWithIdentifier:@"albumsSegue" sender:self];
}

-(void)syncOrder{
    
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
    }
    
}

-(UIColor*)blueColor{
    return [UIColor colorWithRed:0.18 green:0.49 blue:0.83 alpha:1.0];
}


-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}
@end
