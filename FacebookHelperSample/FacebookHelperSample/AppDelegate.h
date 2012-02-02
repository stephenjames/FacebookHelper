//
//  AppDelegate.h
//  FacebookHelperSample
//
//  Created by Stephen James on 2/02/12.
//  Copyright (c) 2012 Mako Australia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FacebookHelper;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

#define kFacebookAppId @"Your Facebook Application ID In Here" //facebook application id
@property (nonatomic, strong) FacebookHelper *facebookHelper; //used to post messages to facebook

- (NSURL *)applicationDocumentsDirectory;

@end
