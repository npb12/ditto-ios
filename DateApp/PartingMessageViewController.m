//
//  PartingMessageViewController.m
//  DateApp
//
//  Created by Neil Ballard on 3/17/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "PartingMessageViewController.h"

@interface PartingMessageViewController (){
    NSString *message;
}

@property (strong, nonatomic) IBOutlet UIView *bgView;
@end

@implementation PartingMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    
    [self.bgView setBackgroundColor:[UIColor darkGrayColor]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    
        [self.bgView setBackgroundColor:[UIColor clearColor]];
     id<PartingMessageDelegate> strongDelegate = self.delegate;
     [strongDelegate sendMessageBack:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)noAction:(id)sender {
    message = @"";
    [self dismissAndSend];
}

- (IBAction)responseAction:(id)sender {
    message = @"response";
    [self dismissAndSend];
}

- (IBAction)chemistryAction:(id)sender {
    message = @"chemistry";
    [self dismissAndSend];

}


- (IBAction)interestAction:(id)sender {
    message = @"interest";
    [self dismissAndSend];

}


- (IBAction)reportAction:(id)sender {
    [self dismissAndSend];
}

-(void)dismissAndSend{
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
