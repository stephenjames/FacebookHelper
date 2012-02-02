//
//  MasterViewController.m
//  FacebookHelperSample
//
//  Created by Stephen James on 2/02/12.
//  Copyright (c) 2012 Mako Australia. All rights reserved.
//

#import "MasterViewController.h"

@implementation MasterViewController
@synthesize doFacebookLogout;
@synthesize label;
@synthesize imageView;



#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
  [self setLabel:nil];

  [self setImageView:nil];
  [self setDoFacebookLogout:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"FacebookDialog"]) {
      UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
      FacebookDialogViewController *vc = (FacebookDialogViewController *)[nc topViewController];
      vc.delegate=self;
    }
}

#pragma FacebookDialogViewControllerDelegate
-(void) facebookDialogViewControllerDidPost:(FacebookDialogViewController *)vc withMessage:(NSString *)message{
  //get the facebook instance
  FacebookHelper *helper=[FacebookHelper helper];
  
  //write the feed, supplying delegate so we get the didWriteToFeed: callback
  [helper writeToFeed:message withDelegate:self];

  [self.navigationController dismissModalViewControllerAnimated:YES];  
}
-(void) facebookDialogViewControllerDidCancel:(FacebookDialogViewController *)vc{
  [self.navigationController dismissModalViewControllerAnimated:YES];
}
#pragma mark - FacebookHelperDelegate
-(void) didWriteToFacebookFeed:(FacebookHelper *)helper withFacebookUsername:(NSString *)username andProfilePicture:(UIImage *)profilePicture{
  //display username
  self.label.text = username;
  self.imageView.image = profilePicture;
  
  UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Wrote to facebook"
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles:@"Ok",nil];
  
  [alert show];
  return;

}


- (IBAction)doFacebookPost:(id)sender {
  [self performSegueWithIdentifier:@"FacebookDialog" sender:sender];
}

- (IBAction)doFacebookLogout:(id)sender {
  FacebookHelper *helper = [FacebookHelper helper];
  [helper logout];
}
@end
