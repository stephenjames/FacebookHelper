//
//  FacebookDialogViewController.h
//  FacebookHelperSample
//
//  Created by Stephen James on 2/02/12.
//  Copyright (c) 2012 Mako Australia. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FacebookDialogViewControllerDelegate;
@interface FacebookDialogViewController : UIViewController
@property (nonatomic,weak) id <FacebookDialogViewControllerDelegate> delegate;
- (IBAction)cancelButtonTouched:(id)sender;
- (IBAction)postButtonTouched:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@protocol FacebookDialogViewControllerDelegate <NSObject>
-(void) facebookDialogViewControllerDidPost:(FacebookDialogViewController *)vc withMessage:(NSString *)message;
-(void) facebookDialogViewControllerDidCancel:(FacebookDialogViewController *)vc;
@end