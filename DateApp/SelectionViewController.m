//
//  GenderSelectionViewController.m
//  DateApp
//
//  Created by Neil Ballard on 2/13/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

#import "SelectionViewController.h"
#import "DAGradientColor.h"

@interface SelectionViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subheaderLabel;
@property (strong, nonatomic) IBOutlet UIButton *secondOptionBtn;
@property (strong, nonatomic) IBOutlet UIButton *firstOptionBtn;
@property (strong, nonatomic) IBOutlet UIButton *bottomOptionBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomBtnHeight;
@property (strong, nonatomic) IBOutlet UILabel *heading;

@end

@implementation SelectionViewController
{
    BOOL firstSelected, secondSelected;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.bottomOptionBtn layoutIfNeeded];
    self.bottomOptionBtn.titleLabel.textColor = [DAGradientColor gradientFromColor:self.bottomOptionBtn.titleLabel.frame.size.width];
    
    firstSelected = NO;
    secondSelected = NO;
/*
    self.firstOptionBtn.layer.borderColor = [UIColor clearColor].CGColor;
    self.firstOptionBtn.layer.borderWidth = 0.75;
    
    self.secondOptionBtn.layer.borderColor = [UIColor clearColor].CGColor;
    self.secondOptionBtn.layer.borderWidth = 0.75;
  */
    
    [self.bottomOptionBtn setHidden:YES];
    [self.bottomOptionBtn setUserInteractionEnabled:NO];
}

-(void)viewDidLayoutSubviews
{
    
    CGFloat dimen = self.bottomOptionBtn.frame.size.width;
    CGFloat height = (dimen - 15) / 5.5;
    self.bottomBtnHeight.constant = height;
    self.bottomOptionBtn.layer.cornerRadius = height / 2;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)firstBtnAction:(id)sender
{
    if (firstSelected)
    {
        firstSelected = NO;
        [UIView animateWithDuration:0.1
                         animations:^{
                             [self.firstOptionBtn setAlpha:0.3];
                             [self.firstOptionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                      //       self.firstOptionBtn.layer.borderColor = [UIColor clearColor].CGColor;
                         }];
        [self updateBtnStateTwoSelect];
    }
    else
    {
        firstSelected = YES;
        
        [UIView animateWithDuration:0.1
                         animations:^{
                             [self.firstOptionBtn setAlpha:1.0];
                             [self.firstOptionBtn setTitleColor:[self baseColor] forState:UIControlStateNormal];
                       //      self.firstOptionBtn.layer.borderColor = [UIColor whiteColor].CGColor;
                         }];
        [self updateBtnStateTwoSelect];
    }
}

- (IBAction)secondBtnAction:(id)sender
{
    if (secondSelected)
    {
        secondSelected = NO;
        [UIView animateWithDuration:0.1
                         animations:^{
                             [self.secondOptionBtn setAlpha:0.3];
                             [self.secondOptionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                   //          self.secondOptionBtn.layer.borderColor = [UIColor clearColor].CGColor;
                         }];
        [self updateBtnStateTwoSelect];
    }
    else
    {
        secondSelected = YES;
        [UIView animateWithDuration:0.1
                         animations:^{
                             [self.secondOptionBtn setAlpha:1.0];
                             [self.secondOptionBtn setTitleColor:[self baseColor] forState:UIControlStateNormal];
                  //           self.secondOptionBtn.layer.borderColor = [UIColor whiteColor].CGColor;
                         }];
        [self updateBtnStateTwoSelect];
    }
}

-(void)updateBtnStateTwoSelect
{
    if (firstSelected || secondSelected)
    {
        [self.bottomOptionBtn setHidden:NO];
        [self.bottomOptionBtn setUserInteractionEnabled:YES];
    }
    else
    {
        [self.bottomOptionBtn setHidden:YES];
        [self.bottomOptionBtn setUserInteractionEnabled:NO];
    }

}

- (IBAction)bottomBtnAction:(id)sender
{
    NSString *selection;
    
    if (firstSelected && !secondSelected)
    {
        selection = @"male";
    }
    else if(!firstSelected && secondSelected)
    {
        selection = @"female";
    }
    else
    {
        selection = @"both";
    }
    
    NSDictionary *dict = @{
                           @"pref_gender": selection
                           };
    
    [DAServer updateProfile:@"PUT" data:dict completion:^(NSError *error) {
        // here, update the UI to say "Not busy anymore"
        [[DataAccess singletonInstance] setReturningUserStatus:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{
                [self.delegate runSetupAfterLogin];
            }];
        });
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIColor*)baseColor
{
    return [UIColor colorWithRed:0.35 green:0.85 blue:0.64 alpha:1.0];
}



@end
