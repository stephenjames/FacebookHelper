//
//  AppDelegate.m
//  FacebookHelperSample
//
//  Created by Stephen James on 2/02/12.
//  Copyright (c) 2012 Mako Australia. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "FacebookHelper.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize facebookHelper;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

  return YES;
}
							


#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma facebook shizzle 
//The relevant method is called by iOS when the Facebook App redirects to the app during the SSO (single sign on) process. The call to Facebook::handleOpenURL: provides the app with the user's credentials.

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  
  //pass the message on to the facebook wrapper if it exisits
  if(self.facebookHelper!=nil){
    return [self.facebookHelper handleOpenURL:url];
  }
  return NO;
}

@end
