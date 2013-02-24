//
//  LoginViewController.h
//  Run
//
//  Created by Daniel Howard on 2/24/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController
-(IBAction)FBLogin:(id)sender;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;
@end
