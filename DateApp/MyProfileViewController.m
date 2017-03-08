//
//  MyProfileViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/12/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "Includes.h"

@interface MyProfileViewController (){
    UIColor *grayColor;
    UIColor *blackColor;
    UIFont *headerFont;
    UIFont *contentFont;
}


- (IBAction)go_back:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (strong, nonatomic) IBOutlet UIView *navbar;
@property (strong, nonatomic) IBOutlet UILabel *age_label;
@property (strong, nonatomic) IBOutlet UILabel *edu_job;
@property (strong, nonatomic) IBOutlet UILabel *edit_header;

@end

@implementation MyProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.navbar.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)([UIColor colorWithRed:0.29 green:0.34 blue:0.86 alpha:1.0].CGColor),(id)([UIColor colorWithRed:0.01 green:0.68 blue:0.80 alpha:1.0].CGColor),nil];
    gradient.startPoint = CGPointMake(0.25,0.0);
    gradient.endPoint = CGPointMake(0.25,1.0);
    [self.navbar.layer insertSublayer:gradient atIndex:0];
    
    [self.profileImage setImage:[UIImage imageNamed:@"girl1"]];
    [self.bio_label setText:@"This is a string about me that is going to persuade you to give me a heart. From there we'll chat it up and make big plans, only for you...."];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableViewHeight.constant = self.view.bounds.size.height / 3;
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self setFonts];
    [self setAgeLabel];
    [self setTitleLabel];
    
    //  [self addBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFonts{
    grayColor = self.edit_header.textColor;
    blackColor = self.bio_label.textColor;
    headerFont = [UIFont systemFontOfSize:11.0];
    contentFont = [UIFont systemFontOfSize:17.0];
    
}

- (void)setAgeLabel{
    
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"AGE: " attributes:@{NSForegroundColorAttributeName : grayColor, NSFontAttributeName: headerFont}]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"25" attributes:@{NSForegroundColorAttributeName : blackColor, NSFontAttributeName: contentFont}]];
    self.age_label.attributedText = attrString;
}

//

- (void)setTitleLabel{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"TITLE: " attributes:@{NSForegroundColorAttributeName : grayColor, NSFontAttributeName: headerFont}]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Software Engineer" attributes:@{NSForegroundColorAttributeName : blackColor, NSFontAttributeName: contentFont}]];
    self.edu_job.attributedText = attrString;
}



- (IBAction)edit_images:(id)sender {
}

- (IBAction)edit_info:(id)sender {
}

- (IBAction)go_back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 
 Table View
 
 */


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MyProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileTVC"];
    
    
    if (indexPath.row == 0) {
        cell.label1.text = @"Photos:";
        cell.label2.text = @"Edit your album/cover photo";
    }else if(indexPath.row == 1){
        cell.label1.text = @"About:";
        cell.label2.text = @"What's your story?";
    }else if(indexPath.row == 2){
        cell.label1.text = @"Occupation:";
        cell.label2.text =  @"What do you do?";
    }else{
        cell.label1.text = @"Education:";
        cell.label2.text =  @"What's your education?";
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    return NO;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"photosSegue" sender:self];
    }
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"pickerSegue"]) {
        OccupationViewController *vc = segue.destinationViewController;
        vc.view.backgroundColor = [UIColor clearColor];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    /*
    self.networksVC = segue.destinationViewController;
    //  NewMatchViewController *matchVC = (NewMatchViewController *)segue.destinationViewController;
    self.networksVC.user_data = sender;
    //  self.networksVC.view.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3];
    self.networksVC.view.backgroundColor = [UIColor clearColor];
    self.networksVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;*/
}


- (IBAction)goBack:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)editJob:(id)sender {
}

- (IBAction)editBio:(id)sender {
}

@end
