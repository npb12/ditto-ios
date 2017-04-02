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


@end

@implementation FBAlbumsViewController

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
    
    NSLog(@"%@", album.album_id);
    
    PhotoManager *albums = [PhotoManager singletonInstance];
    [albums getFacebookProfileInfos:2 completion:^{
        
        /*
        PhotosViewController *controller = [[PhotosViewController alloc] initWithNibName:NSStringFromClass([PhotosViewController class]) bundle:nil]; */
        
        [self performSegueWithIdentifier:@"photosSegue" sender:self];

        
    }];
    
    
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
