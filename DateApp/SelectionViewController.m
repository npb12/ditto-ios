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

@end

@implementation SelectionViewController
{
    BOOL firstSelected, secondSelected;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.firstOptionBtn.titleLabel.textColor = [DAGradientColor gradientFromColor:self.firstOptionBtn.titleLabel.frame.size.width];
        self.secondOptionBtn.titleLabel.textColor = [DAGradientColor gradientFromColor:self.secondOptionBtn.titleLabel.frame.size.width];
    
    firstSelected = NO;
    secondSelected = NO;
    
    [self.bottomOptionBtn setAlpha:0.1];
    [self.bottomOptionBtn setUserInteractionEnabled:NO];
}

-(void)viewDidLayoutSubviews
{
    
    CGFloat dimen = self.bottomOptionBtn.frame.size.width;
    
    CGFloat height = (dimen - 15) / 5;
    
    self.bottomBtnHeight.constant = height;
    [self.bottomOptionBtn layoutIfNeeded];
    
    UIColor *color1 = [UIColor colorWithRed:0.09 green:0.92 blue:0.85 alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:0.08 green:0.77 blue:0.90 alpha:1.0];
    UIColor *color3 = [UIColor colorWithRed:0.08 green:0.67 blue:0.94 alpha:1.0];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bottomOptionBtn.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)([color1 colorWithAlphaComponent:1].CGColor),(id)([color2 colorWithAlphaComponent:1].CGColor),(id)([color3 colorWithAlphaComponent:1].CGColor),nil];
    gradient.startPoint = CGPointMake(0.0,0.5);
    gradient.endPoint = CGPointMake(1.0,0.5);
    [self.bottomOptionBtn.layer insertSublayer:gradient atIndex:0];
    gradient.cornerRadius = height / 5;
    gradient.masksToBounds = YES;
    self.bottomOptionBtn.layer.masksToBounds = NO;
    self.bottomOptionBtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.bottomOptionBtn.layer.shadowOpacity = 0.75;
    self.bottomOptionBtn.layer.shadowRadius = 3;
    self.bottomOptionBtn.layer.shadowOffset = CGSizeZero;
    
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
        [self.firstOptionBtn setAlpha:0.3];
        [self updateBtnStateTwoSelect];
    }
    else
    {
        firstSelected = YES;
        [self.firstOptionBtn setAlpha:1.9];
        [self updateBtnStateTwoSelect];
    }
}

- (IBAction)secondBtnAction:(id)sender
{
    if (secondSelected)
    {
        secondSelected = NO;
        [self.secondOptionBtn setAlpha:0.3];
        [self updateBtnStateTwoSelect];
    }
    else
    {
        secondSelected = YES;
        [self.secondOptionBtn setAlpha:1.9];
        [self updateBtnStateTwoSelect];
    }
}

-(void)updateBtnStateTwoSelect
{
    if (firstSelected || secondSelected)
    {
        [self.bottomOptionBtn setAlpha:1];
        [self.bottomOptionBtn setUserInteractionEnabled:YES];
    }
    else
    {
        [self.bottomOptionBtn setAlpha:0.1];
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
            [self dismissViewControllerAnimated:YES completion:nil];
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



@end
