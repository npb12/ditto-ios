//
//  BioViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/22/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "BioViewController.h"

@interface BioViewController ()

@end

@implementation BioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupbioLabel];
    [self setupBioTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupbioLabel {
    UIFont *font;
    
    CGFloat height = 0;
    
    self.bioLabel = [[UILabel alloc] init];
    
    self.bioLabel.font = [UIFont systemFontOfSize:5];
    height = 15;
    
    CGFloat pad = 0;

    
    
    [self.bioLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.bioLabel invalidateIntrinsicContentSize];
    self.bioLabel.font = [UIFont fontWithName:@"Verdana" size:17.0f];
    self.bioLabel.textColor = [UIColor lightGrayColor];
    
    self.bioLabel.text = @"Bio";
    
    [self.view addSubview:self.bioLabel];
    
    NSDictionary *viewsDictionary = @{@"label" : self.bioLabel};
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[label]" options:0 metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraint1];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[label]" options:0 metrics:@{@"pad":[NSNumber numberWithFloat:20]} views:viewsDictionary];
    [self.view addConstraints:constraint2];
    
}

- (void)setupBioTextField {
    
    self.bioTextField = [[UITextView alloc]init];
    self.bioTextField.delegate = self;
    self.bioTextField.layer.cornerRadius = 7.0;
    self.bioTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bioTextField invalidateIntrinsicContentSize];
    
    NSString *bio = [[DataAccess singletonInstance] getBio];
    
    if (bio != nil) {
        self.bioTextField.text = bio;
    }
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat height = 0, width = 0;
    width = screen.size.width - 30;
    height = screen.size.height / 2.5;
    CGFloat font_size = 0;
    

    
    UIColor *color = [UIColor lightGrayColor];
    
    
    self.bioTextField.backgroundColor = [UIColor whiteColor];
    self.bioTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bioTextField.layer.borderWidth = 0.5f;
    self.bioTextField.layer.masksToBounds = true;
    
    NSMutableDictionary *viewsDictionary = [[NSMutableDictionary alloc] init];
    [viewsDictionary setObject:self.bioTextField forKey:@"textField"];
    [viewsDictionary setObject:self.bioLabel forKey:@"label"];
    
    [self.view addSubview:self.bioTextField];
    
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-xpad-[textField]" options:0 metrics:@{@"xpad" : [NSNumber numberWithFloat:15], @"width" : [NSNumber numberWithFloat:width]} views:viewsDictionary];
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-pad-[textField(height)]" options:0 metrics:@{@"height" : [NSNumber numberWithFloat:height], @"pad" : [NSNumber numberWithFloat:20]} views:viewsDictionary];
    
    [self.view addConstraints:hConstraints];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bioTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
    
    [self.view addConstraints:vConstraints];
    
}




- (void)textFieldDidChange {
    //
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [textField setReturnKeyType:UIReturnKeyDone];
    return TRUE;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.bioTextField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[DataAccess singletonInstance] setBio:self.bioTextField.text];
    [self.bioTextField resignFirstResponder];
    [self.bioTextField endEditing:YES];
}

- (void)touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {
    NSArray *subviews = [self.view subviews];
    for (id objects in subviews) {
        if ([objects isKindOfClass:[UITextView class]]) {
            UITextView *theTextField = objects;
            if ([objects isFirstResponder]) {
                [theTextField resignFirstResponder];
            }
        }
    }
}

@end
