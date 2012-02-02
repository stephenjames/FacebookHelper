//
//  FacebookHelper.h
//  A simple wrapper around the Facebook Graph API
//
//  Created by Stephen James on 17/01/12.
//  Copyright (c) 2012 Mako Australia. All rights reserved.
//
@protocol FacebookHelperDelegate;

#import <Foundation/Foundation.h>
#import "FBConnect.h"

#define kFacebookAppPermissions @"publish_stream"
/*
 * Enum used to login to facebook and write a message to the users news feed
 */
typedef enum {
  Login = 0,                  //logging in
  RequestProfile = 1,         //request profile information username etc
  RequestProfilePicture = 2,  //request profile picture
  WriteToFeed = 3,       //writing text to the users news feed
} WriteToFeedState;

@interface FacebookHelper : NSObject<FBSessionDelegate,FBRequestDelegate>
@property (nonatomic, retain) NSString *facebookName; //facebook username
@property (nonatomic, retain) UIImage *facebookProfilePicture; //facebook profile picture

@property (nonatomic, strong) Facebook *facebook; //instance of facebook SDK
@property (nonatomic, assign) WriteToFeedState writeToFeedState; //the current state of the write

@property (nonatomic,weak) id <FacebookHelperDelegate> delegate; //the delegate to send messages to

@property (nonatomic, strong) NSString *message; //the message to write to the facebook feed
/*
 * ******************************************************************************************************
 * public methods
 */
/*
 * helper class method to return the helper instance
 */
+ (FacebookHelper *) helper;
/*
 * write a message to a facebook feed and return the facebook username and profile picture
 * to the supplied delegate
 * see didWriteToFeedWithName:(NSString *)username andPicture:(UIImage *)picture
 * see didFailToWriteToFeedWithError:(NSString *)error
 */
- (void) writeToFeed:(NSString *)message withDelegate:(id) delegate;
/*
 * logout the facebook app
 */
- (void) logout;
/*
 * return YES if a valid facebook session exists
 */
- (BOOL) isSessionValid;
/*
 * this method is called by application delegate to implement single sign on
 */
- (BOOL)handleOpenURL:url; 
/*
 * ******************************************************************************************************
 * private methods
 */

/*
 * state machine for writing to the feed
 */
- (void) runWriteToFeedMachine;
/*
 * Initiate login brings up a login panel
 * responds via FBSessionDelegate
 */
- (void) doFacebookLogin;
/*
 * Request the facebook profile data
 * responds via FBRequestDelegate
 */
- (void) getFacebookProfile;
/*
 * Request the facebook profile picture
 * responds via FBRequestDelegate
 */
- (void) getFacebookProfilePicture;
/*
 * write a message to the facebook news feed
 * responds via FBRequestDelegate
 */
- (void) doFacebookWrite;

@end

/*
 * ******************************************************************************************************
 * delegate methods
 */
@protocol FacebookHelperDelegate <NSObject>
-(void) didWriteToFacebookFeed:(FacebookHelper *)helper withFacebookUsername:(NSString *)username andProfilePicture:(UIImage *)profilePicture;
@end
