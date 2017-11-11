//
//  FBAlbumsViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/26/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "FBAlbumsViewController.h"

@interface FBAlbumsViewController ()

@property (strong, nonatomic) PhotoManager *album;

@property (strong, nonatomic) IBOutlet UIView *gradientView;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;

@end

@implementation FBAlbumsViewController
{
    NSString *name;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];

    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PhotoManager *albums = [PhotoManager singletonInstance];
        [albums getFacebookProfileInfos:1 completion:^{
            
            
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            //         [self.tableView reloadData];
            
            
            
        }];
    });
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PhotoManager *albums = [PhotoManager singletonInstance];
    return [albums.albums count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumcell"];

        PhotoManager *album = (PhotoManager*)[[[PhotoManager singletonInstance] albums] objectAtIndex:indexPath.row];
        cell.album_label.text = album.album_name;
    [cell.album_label layoutIfNeeded];
        cell.album_label.textColor = [DAGradientColor gradientFromColor:cell.album_label.frame.size.width];
        UIFont *font;

        
        cell.album_label.font = font;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    return NO;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoManager *album = (PhotoManager*)[[[PhotoManager singletonInstance] albums] objectAtIndex:indexPath.row];
    
    PhotoManager *instance = [PhotoManager singletonInstance];
    
    instance.album_id = album.album_id;
    
    name = album.album_name;
    
    NSLog(@"%@", album.album_id);
    
    
    
    PhotoManager *albums = [PhotoManager singletonInstance];
    [albums getFacebookProfileInfos:2 completion:^{
        
        /*
        PhotosViewController *controller = [[PhotosViewController alloc] initWithNibName:NSStringFromClass([PhotosViewController class]) bundle:nil]; */
        
        [self performSegueWithIdentifier:@"photosSegue" sender:self];

        
    }];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"photosSegue"])
    {
        FBPhotosViewController *vc = segue.destinationViewController;
        vc.selectedIndex = self.selectedIndex;
        vc.photos = self.photos;
        vc.albumName = name;
    }
}


- (IBAction)backAction:(id)sender {
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
