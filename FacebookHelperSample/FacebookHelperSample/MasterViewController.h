//
//  MasterViewController.h
//  FacebookHelperSample
//
//  Created by Stephen James on 2/02/12.
//  Copyright (c) 2012 Mako Australia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookDialogViewController.h"
#import "FacebookHelper.h"
@interface MasterViewController : UIViewController <FacebookDialogViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;


- (IBAction)doFacebookPost:(id)sender;
- (IBAction)doFacebookLogout:(id)sender;

@end
