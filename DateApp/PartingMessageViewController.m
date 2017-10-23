//
//  PartingMessageViewController.m
//  DateApp
//
//  Created by Neil Ballard on 3/17/17.
//  Copyright © 2017 Neil Ballard. All rights reserved.
//

#import "PartingMessageViewController.h"
#import "DAServer.h"

@interface PartingMessageViewController (){
    NSString *message;
}
@property (strong, nonatomic) IBOutlet UILabel *headingLabel;

@property (strong, nonatomic) IBOutlet UIView *bgView;
@end

@implementation PartingMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.headingLabel.text = [NSString stringWithFormat:@"Are you sure you want to\n unmatch with %@?", [MatchUser currentUser].name];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    
    [self.bgView setBackgroundColor:[UIColor darkGrayColor]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    
    [self.bgView setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)noAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)inappropriateAction:(id)sender {
    message = [NSString stringWithFormat:@"%@ felt your messages were innapropriate", [User currentUser].name];
    [self dismissAndSend];
}

- (IBAction)responseAction:(id)sender {
    message = @"Try to respond sooner next time!";
    [self dismissAndSend];
}

- (IBAction)chemistryAction:(id)sender
{
    message = [NSString stringWithFormat:@"%@ felt there wasn't enough chemistry", [User currentUser].name];
    [self dismissAndSend];

}

- (IBAction)interestAction:(id)sender
{
    message = [NSString stringWithFormat:@"%@ felt you showed little interest", [User currentUser].name];
    [self dismissAndSend];

}

- (IBAction)noReasonAction:(id)sender
{
    message = @"";
    [self dismissAndSend];
    
}





-(void)dismissAndSend
{
    id<PartingMessageDelegate> strongDelegate = self.delegate;
    [strongDelegate sendMessageBack:@""];
    [DAServer dropMatch:message  completion:^(NSError *error) {
        // here, update the UI to say "Not busy anymore"
        if (!error) {
            [MatchUser removeCurrentMatch];
        } else {
            // update UI to indicate error or take remedial action
        }
    }];
    
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
