//
//  ViewController.m
//  Tip Calculator
//
//  Created by Anthony Coelho on 2016-05-13.
//  Copyright © 2016 Anthony Coelho. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>


@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addKeyboardObserver];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.billAmountTextField.delegate = self;
    self.tipPercentageTextField.delegate = self;
    
    self.keyboardHidden = YES;
    
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed)];
    
    [keyboardToolbar setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];
    [self.billAmountTextField setInputAccessoryView:keyboardToolbar];
    [self.tipPercentageTextField setInputAccessoryView:keyboardToolbar];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];


}

- (CGFloat)heightForNotification:(NSNotification *)notification {
    NSValue *keyboardInfo = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [keyboardInfo CGRectValue];
    return rect.size.height;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    //NSLog(@"%@",notification.userInfo);
    CGFloat kbHeight = [self heightForNotification:notification];
    
    if (self.keyboardHidden == YES) {
        [self adjustViewForKeyboardHeight:kbHeight];
        self.keyboardHidden = NO;
    }

}

- (void)keyboardWillHide:(NSNotification *)notification {
    //NSLog(@"%@", notification.userInfo);
    CGFloat kbHeight = [self heightForNotification:notification];
    
    if (self.keyboardHidden == NO) {
        [self adjustViewForKeyboardHeight:-kbHeight];
        self.keyboardHidden = YES;;
    }
    
}


- (void)adjustViewForKeyboardHeight:(CGFloat)height {
    
    CGRect viewBounds = self.view.bounds;
    viewBounds.origin.y += height;
    //NSLog(@"%@", NSStringFromCGRect(viewBounds));
    self.view.bounds = viewBounds;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void) doneButtonPressed {

    [self.view endEditing:YES];
    
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField == self.tipPercentageTextField) {
        self.tipSlider.value = [textField.text intValue];
    }
    
    [self calculateTip:nil];
    
    return YES;
}



- (void)viewTapped:(UITapGestureRecognizer *)sender {
    if ([self.billAmountTextField isFirstResponder]) {
        [self.billAmountTextField resignFirstResponder];
    }
    if ( [self.tipPercentageTextField isFirstResponder]) {
        [self.tipPercentageTextField resignFirstResponder];
    }
}

- (IBAction)calculateTip:(id)sender {
    
    self.tipSlider.value = [self.tipPercentageTextField.text intValue];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    if ([self.tipPercentageTextField.text  isEqual: @""])
    {
        self.tipAmountLabel.text = [NSString stringWithFormat:@"Tip Amount: %@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:([self.billAmountTextField.text floatValue] * 0.15)]]];
    }
    else
    {
        self.tipAmountLabel.text = [NSString stringWithFormat:@"Tip Amount: %@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat: ([self.billAmountTextField.text floatValue] * [self.tipPercentageTextField.text floatValue] * 0.01)]]];
    }

}
- (IBAction)adjustTipPercentage:(UISlider *)slider {
    
    self.tipPercentageTextField.text = [NSString stringWithFormat:@"%.f", slider.value];
    [self calculateTip:nil];
    
}






@end
