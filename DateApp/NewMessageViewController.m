//
//  NewMessageViewController.m
//  DateApp
//
//  Created by Neil Ballard on 3/18/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "NewMessageViewController.h"

@interface NewMessageViewController ()
@property (strong, nonatomic) IBOutlet UIView *touchView;
@property (strong, nonatomic) IBOutlet UILabel *subHeader;
@property (strong, nonatomic) IBOutlet UILabel *messageText;
@property (strong, nonatomic) IBOutlet UIButton *exitBtn;

@end

@implementation NewMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitAction:)];
    [self.touchView addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    
    [self.touchView setBackgroundColor:[UIColor darkGrayColor]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    
    [self.touchView setBackgroundColor:[UIColor clearColor]];

}


- (IBAction)gotoMessage:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    id<SegueProtocol> strongDelegate = self.delegate;
    [strongDelegate gotoMessage];

}

- (IBAction)exitAction:(id)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
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
