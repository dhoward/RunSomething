//
//  LoginViewController.m
//  Run
//
//  Created by Daniel Howard on 2/24/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void) viewWillAppear:(BOOL)animated {
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {        
        [self FBLogin:nil];
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)FBLogin:(id)sender {
    
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
            switch (state) {
                case FBSessionStateClosedLoginFailed:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:error.localizedDescription
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
                    break;
                default:
                    [self performSegueWithIdentifier: @"loggedInSegue" sender: self];
                    break;
            }
        }];
    }else{
        [self performSegueWithIdentifier: @"loggedInSegue" sender: self];
    }
    
}


@end
