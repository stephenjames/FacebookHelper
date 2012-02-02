//
//  FacebookWrapper.m
//  A simple wrapper around the Facebook Graph API
//
//  Created by Stephen James on 17/01/12.
//  Copyright (c) 2012 Mako Australia. All rights reserved.
//

#import "FacebookHelper.h"
#import "AppDelegate.h"

@implementation FacebookHelper
@synthesize facebookName;
@synthesize facebookProfilePicture;

@synthesize facebook;
@synthesize writeToFeedState;

@synthesize delegate;
@synthesize message;

- (FacebookHelper *) init{
  if(![super init]){
    return nil;
  }
  //create a new instance of the facebook SDK which we are obfuscating
  Facebook *_facebook = [[Facebook alloc] initWithAppId:kFacebookAppId andDelegate:self];
  //retain it
  self.facebook=_facebook;
  return self;
}

/*
 * return the helper object.  Create it and store in the application delegate if it doesn't exist
 */
+ (FacebookHelper *) helper{
  //get the application delegate
  AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
  //if the facebook helper doesn't already exists
  if(app.facebookHelper==nil){
    //create a new instance of this class
    FacebookHelper *helper=[[FacebookHelper alloc] init];
    //wire up this helper instance to the application delegate so it can be re-used
    app.facebookHelper=helper;
  }
  //retain login if we have logged in before
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
    app.facebookHelper.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
    app.facebookHelper.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    app.facebookHelper.facebookName = (NSString *)[defaults objectForKey:@"FBUserName"];
    NSData* imageData = [defaults objectForKey:@"FBProfilePicture"];
    UIImage *image = [UIImage imageWithData:imageData];
    //handle retina
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
      image=[UIImage imageWithCGImage:image.CGImage scale:2.0 orientation:image.imageOrientation];
    }
    app.facebookHelper.facebookProfilePicture = image;
  }

  NSLog(@"%@",app.facebookHelper.facebook);
  //return the helper
  return app.facebookHelper;
}
// **********************************************************************************************************
#pragma mark public methods
- (void) writeToFeed:(NSString *)_message withDelegate:(id<FacebookHelperDelegate>) _delegate{
  //wire up the delegate
  self.delegate=_delegate;
  //set the initial state
  if (![[self facebook] isSessionValid]) {
    self.writeToFeedState=Login;
  }
  else{
    self.writeToFeedState=WriteToFeed;
  }
  //save the message
  self.message=_message;
  //start the state machine
  [self runWriteToFeedMachine];
}
- (void) logout{
  //logout the the facebook app
  [self.facebook logout];
}
- (BOOL) isSessionValid{
  return [[self facebook] isSessionValid];
}
- (BOOL)handleOpenURL:url{
  return [self.facebook handleOpenURL:url];
}
// **********************************************************************************************************
#pragma mark private methods
- (void) runWriteToFeedMachine{
  switch (self.writeToFeedState) {
      //login
		case Login:
      [self doFacebookLogin];
      break;
      //request profile information
		case RequestProfile:
			[self getFacebookProfile];
      break;
		case RequestProfilePicture:
			[self getFacebookProfilePicture];
      break;
		case WriteToFeed:
      [self doFacebookWrite];
      break;
			
		default:
			break;
  }
  //
  //  NSString *str=@"test";
  //	NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
  //                                  str, @"message", 
  //                                  nil];
  //	
  //	[facebook requestWithGraphPath:@"me/feed"
  //                       andParams:params
  //                   andHttpMethod:@"POST"
  //                     andDelegate:nil]; //no callback
}
- (void) doFacebookLogin{
  //this will prompt the user to authorize the Goalie facebook app
  NSArray *arr=[NSArray arrayWithObjects: kFacebookAppPermissions,nil];
  [self.facebook authorize:arr];
}

- (void) getFacebookProfile{
  [self.facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (void) getFacebookProfilePicture{
  [facebook requestWithGraphPath:@"me/picture?type=large" andDelegate:self];
}

- (void) doFacebookWrite{
  NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.message, @"message", nil];
  [facebook requestWithGraphPath:@"me/feed"
                       andParams:params
                   andHttpMethod:@"POST"
                     andDelegate:self]; 
  
}

// **********************************************************************************************************
#pragma mark FBSessionDelegate
- (void)fbDidLogin {
  //save the access token in the user defaults
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
  [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
  [defaults setObject:[self facebookName] forKey:@"FBUserName"];
  [defaults setObject:UIImagePNGRepresentation(self.facebookProfilePicture) forKey:@"FBProfilePicture"];
  [defaults synchronize]; 
  //increment the state machine
  self.writeToFeedState++;
  [self runWriteToFeedMachine];
}

- (void)fbDidNotLogin:(BOOL)cancelled{
//  UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Failed to send event to facebook"
//                                                message:nil
//                                               delegate:self
//                                      cancelButtonTitle:nil
//                                      otherButtonTitles:@"Ok",nil];
//  
//  [alert show];
  
  //notify the delegate of failure
  NSLog(@"fbDidNotLogin");


}

- (void) fbDidLogout{
  // Remove saved authorization information if it exists
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults objectForKey:@"FBAccessTokenKey"]) {
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults removeObjectForKey:@"FBUserName"];
    [defaults removeObjectForKey:@"FBProfilePicture"];
    [defaults synchronize];
  }
  NSLog(@"facebook did logout");
}
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt{
  ;
}

- (void)fbSessionInvalidated{
  ;
}

// **********************************************************************************************************
#pragma mark FBRequestDelegate
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
  //notify the delegate
  if(self.writeToFeedState==Login){
    NSLog(@"facebook failed login %@",error);

  }
  else if(self.writeToFeedState==RequestProfile){
    NSLog(@"facebook failed to request profile %@",error);

  }
  else if(self.writeToFeedState==RequestProfilePicture){
    NSLog(@"facebook failed to request profile picture %@",error);

  }
  else if(self.writeToFeedState==WriteToFeed){
    NSLog(@"facebook failed to write to feed %@",error);

  }
  else{
    NSLog(@"facebook failed unknown status %@",error);

  }
}
- (void)request:(FBRequest *)request didLoad:(id)result{
  if(self.writeToFeedState==Login){
    ;
  }
  else if(self.writeToFeedState==RequestProfile){
    NSDictionary *dict =(NSDictionary *)result;
    self.facebookName=[dict objectForKey:@"name"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self facebookName] forKey:@"FBUserName"];
    [defaults synchronize]; 
    //save facebook username
    NSLog(@"Facebook Name %@ Done.",self.facebookName);
  }
  else if(self.writeToFeedState==RequestProfilePicture){
    //save the facebook profile picture
    UIImage *image = [UIImage imageWithData: [request responseText]];
    //resize the picture to 35x35 pixels
    CGSize newSize=CGSizeMake(35,35);
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
      UIGraphicsBeginImageContextWithOptions(newSize, YES, 2.0);
    }
    else{
      UIGraphicsBeginImageContext(newSize);
    }
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    //render the facebook logo in the bottom right corner
    image = [UIImage imageNamed:@"facebook_white"];
    CGFloat scaleFactor=2.0f/3.0f;
    [image drawInRect:CGRectMake(newSize.width-image.size.width*scaleFactor, 
                                 newSize.height-image.size.height*scaleFactor, 
                                 image.size.width*scaleFactor, 
                                 image.size.height*scaleFactor) 
            blendMode:kCGBlendModeNormal alpha:0.8];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //save the image
    self.facebookProfilePicture=newImage;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:UIImagePNGRepresentation(self.facebookProfilePicture) forKey:@"FBProfilePicture"];
    [defaults synchronize]; 
    //save facebook profile picture
    NSLog(@"Facebook Profile Picture: %@ Done.",image);
  }
  else if(self.writeToFeedState==WriteToFeed){
    //notify the delegate of success and exit
    NSLog(@"Facebook wrote to feed");
    [self.delegate didWriteToFacebookFeed:self withFacebookUsername:self.facebookName andProfilePicture:self.facebookProfilePicture];
    return;
  }
  else{
    NSLog(@"Facebook invalid state: %@",result);
  }
  //increment the state machine
  self.writeToFeedState++;
  [self runWriteToFeedMachine];
  
}


@end
