//
//  EduViewController.m
//  DateApp
//
//  Created by Neil Ballard on 11/22/16.
//  Copyright © 2016 Neil Ballard. All rights reserved.
//

#import "EduViewController.h"

@interface EduViewController (){
    NSArray *_pickerData;
}
@property (strong, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation EduViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pickerData = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5", @"Item 6"];
    
    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(tappedToSelectRow:)];
    tapToSelect.delegate = self;
    [self.picker addGestureRecognizer:tapToSelect];
    
    UITapGestureRecognizer *tapToDismiss = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                  action:@selector(tappedToDismiss:)];
    [self.view addGestureRecognizer:tapToDismiss];
    
    
    self.picker.delegate = self;
    self.picker.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    NSLog(@"%ld", (long)row);
}

- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [self.picker rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(self.picker.bounds, 0.0, (CGRectGetHeight(self.picker.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:self.picker]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [self.picker selectedRowInComponent:0];
            [self pickerView:self.picker didSelectRow:selectedRow inComponent:0];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}


- (IBAction)tappedToDismiss:(UITapGestureRecognizer *)tapRecognizer
{
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
