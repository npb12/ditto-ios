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
    UIColor *inactiveColor;
}
@property (strong, nonatomic) IBOutlet UILabel *headingLabel;
@property (strong, nonatomic) IBOutlet UIButton *unmatchBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *unmatchBtnHeight;

@property (strong, nonatomic) IBOutlet UIView *bgView;


@property (strong, nonatomic) IBOutlet UIButton *inappropriateBtn;
@property (strong, nonatomic) IBOutlet UIButton *chemistryBtn;
@property (strong, nonatomic) IBOutlet UIButton *interestBtn;
@property (strong, nonatomic) IBOutlet UIButton *responseTimeBtn;
@property (strong, nonatomic) IBOutlet UIButton *noReasonBtn;

@property (strong, nonatomic) IBOutlet UIImageView *inappropriateImageView;
@property (strong, nonatomic) IBOutlet UIImageView *chemistryImageView;
@property (strong, nonatomic) IBOutlet UIImageView *noReasonImageView;
@property (strong, nonatomic) IBOutlet UIImageView *responseTimeImageView;
@property (strong, nonatomic) IBOutlet UIImageView *interestImageView;


@end

@implementation PartingMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.bgView setBackgroundColor:[UIColor darkGrayColor]];

    self.currentType = 0;
    inactiveColor = self.inappropriateBtn.titleLabel.textColor;

    
    [self.unmatchBtn setAlpha:0.1];
    [self.unmatchBtn setUserInteractionEnabled:NO];
    
    self.headingLabel.text = [NSString stringWithFormat:@"Are you sure you want to\n unmatch with %@?", [MatchUser currentUser].name];
    
    UITapGestureRecognizer *cancelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noAction:)];
    [self.bgView addGestureRecognizer:cancelGesture];
    
    
}

-(void)viewDidLayoutSubviews
{
    
    CGFloat dimen = self.unmatchBtn.frame.size.width;
    
    CGFloat height = (dimen - 15) / 5;
    
    self.unmatchBtnHeight.constant = height;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    
    [self.bgView setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)noAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)inappropriateAction:(id)sender {
    
    if (self.currentType != INAPPROPRIATE)
    {
        message = [NSString stringWithFormat:@"%@ felt your messages may have been innapropriate", [User currentUser].name];
        self.currentType = INAPPROPRIATE;
    }
    else
    {
        self.currentType = 0;
        message = @"";
    }
    
    [self setStuff];
}

- (IBAction)responseAction:(id)sender {
    
    if (self.currentType != RESPONSE_TIME)
    {
        message = @"Try to respond sooner next time!";
        self.currentType = RESPONSE_TIME;
    }
    else
    {
        self.currentType = 0;
        message = @"";
    }
    
    [self setStuff];
    
}

- (IBAction)chemistryAction:(id)sender
{
    
    if (self.currentType != CHEMISTRY)
    {
        message = @"Seems like the connection wasn’t there";
        self.currentType = CHEMISTRY;
    }
    else
    {
        self.currentType = 0;
        message = @"";
    }
    
    [self setStuff];

}

- (IBAction)interestAction:(id)sender
{
    if (self.currentType != INTEREST)
    {
        message = [NSString stringWithFormat:@"%@ felt you showed little interest", [User currentUser].name];
        self.currentType = INTEREST;
    }
    else
    {
        self.currentType = 0;
        message = @"";
    }
    
    [self setStuff];
}

- (IBAction)noReasonAction:(id)sender
{
    if (self.currentType != NO_REASON)
    {
        message = @"";
        self.currentType = NO_REASON;
    }
    else
    {
        self.currentType = 0;
        message = @"";
    }
    
    [self setStuff];
}



-(IBAction)unmatchAction:(id)sender
{
    
    if (self.currentType != 0)
    {
        [self dismissAndSend];
    }
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

-(void)setStuff
{
    [self unsetAll];
    
    switch (self.currentType)
    {
        case INAPPROPRIATE:
        {
            //set text and btn state
            [self.inappropriateBtn setTitleColor:[self activeColor] forState:UIControlStateNormal];
            UIImage *image = [UIImage imageNamed:@"unmatch_messages_active_icon"];
            self.inappropriateImageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self.inappropriateImageView setTintColor:[self activeColor]];
                [self.unmatchBtn setAlpha:1];
                [self.unmatchBtn setUserInteractionEnabled:YES];
            break;
        }
        case CHEMISTRY:
        {
            [self.chemistryBtn setTitleColor:[self activeColor] forState:UIControlStateNormal];
         //       [self.chemistryImageView setImage:[UIImage imageNamed:@"unmatch_chemistry_active_icon"]];
            UIImage *image = [UIImage imageNamed:@"unmatch_chemistry_active_icon"];
            self.self.chemistryImageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self.self.chemistryImageView setTintColor:[self activeColor]];
                [self.unmatchBtn setAlpha:1];
                [self.unmatchBtn setUserInteractionEnabled:YES];
            break;
        }
        case INTEREST:
        {
                [self.interestBtn setTitleColor:[self activeColor] forState:UIControlStateNormal];
              //      [self.interestImageView setImage:[UIImage imageNamed:@"unmatch_interest_active_icon"]];
            UIImage *image = [UIImage imageNamed:@"unmatch_interest_active_icon"];
            self.self.self.interestImageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self.self.self.interestImageView setTintColor:[self activeColor]];
                [self.unmatchBtn setAlpha:1];
                [self.unmatchBtn setUserInteractionEnabled:YES];
            break;
        }
        case RESPONSE_TIME:
        {
                [self.responseTimeBtn setTitleColor:[self activeColor] forState:UIControlStateNormal];
            //    [self.responseTimeImageView setImage:[UIImage imageNamed:@"unmatch_response_active_icon"]];
            UIImage *image = [UIImage imageNamed:@"unmatch_response_active_icon"];
            self.self.self.self.responseTimeImageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self.self.self.self.responseTimeImageView setTintColor:[self activeColor]];
                [self.unmatchBtn setAlpha:1];
                [self.unmatchBtn setUserInteractionEnabled:YES];
            break;
        }
        case NO_REASON:
        {
                [self.noReasonBtn setTitleColor:[self activeColor] forState:UIControlStateNormal];
           //     [self.noReasonImageView setImage:[UIImage imageNamed:@"unmatch_no_reason_active_icon"]];
            UIImage *image = [UIImage imageNamed:@"unmatch_no_reason_active_icon"];
            self.self.self.self.self.noReasonImageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self.self.self.self.self.noReasonImageView setTintColor:[self activeColor]];
                [self.unmatchBtn setAlpha:1];
                [self.unmatchBtn setUserInteractionEnabled:YES];
            break;
        }
        default:
        {
            self.currentType = 0;
            [self.unmatchBtn setAlpha:0.1];
            [self.unmatchBtn setUserInteractionEnabled:NO];
            break;
        }
    }
    
    
}

-(void)unsetAll
{
    [self.inappropriateBtn setTitleColor:inactiveColor forState:UIControlStateNormal];
    [self.chemistryBtn setTitleColor:inactiveColor forState:UIControlStateNormal];
    [self.noReasonBtn setTitleColor:inactiveColor forState:UIControlStateNormal];
    [self.interestBtn setTitleColor:inactiveColor forState:UIControlStateNormal];
    [self.responseTimeBtn setTitleColor:inactiveColor forState:UIControlStateNormal];
    
    
    [self.inappropriateImageView setImage:[UIImage imageNamed:@"unmatch_messages_icon"]];
    [self.chemistryImageView setImage:[UIImage imageNamed:@"unmatch_chemistry_icon"]];
    [self.responseTimeImageView setImage:[UIImage imageNamed:@"unmatch_response_icon"]];
    [self.interestImageView setImage:[UIImage imageNamed:@"unmatch_interest_icon"]];
    [self.noReasonImageView setImage:[UIImage imageNamed:@"unmatch_no_reason_icon"]];
}

-(UIColor*)activeColor
{
    return [UIColor colorWithRed:0.31 green:0.70 blue:1.00 alpha:1.0];
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
