//
//  BioViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/22/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "BioViewController.h"

@interface BioViewController (){
    BOOL tvDidChange;
}

@end

@implementation BioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (self.user.bio.length)
    {
        self.bioTextView.text = self.user.bio;
       // [self textViewDidChange:self.bioTextView];
    }
    
    self.bioTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bioTextView.layer.borderWidth = 0.5;
    self.bioTextView.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text containsString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    tvDidChange = YES;
    
    return YES;
}


- (IBAction)goBack:(id)sender
{
    
    if (!tvDidChange)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    NSString *bioText = self.bioTextView.text;

    
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
