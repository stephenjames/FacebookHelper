//
//  FacebookDialogViewController.m
//  FacebookHelperSample
//
//  Created by Stephen James on 2/02/12.
//  Copyright (c) 2012 Mako Australia. All rights reserved.
//

#import "FacebookDialogViewController.h"

@implementation FacebookDialogViewController
@synthesize textView;
@synthesize delegate;

#pragma mark - View lifecycle


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload{
  [self setTextView:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelButtonTouched:(id)sender {
  //notify the delegate
  [self.delegate facebookDialogViewControllerDidCancel:self];
}

- (IBAction)postButtonTouched:(id)sender {
  //notify the delegate
  [self.delegate facebookDialogViewControllerDidPost:self withMessage:self.textView.text];
}
@end
