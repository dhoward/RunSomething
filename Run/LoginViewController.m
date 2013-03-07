//
//  LoginViewController.m
//  Run
//
//  Created by Daniel Howard on 2/24/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "RunAppDelegate.h"
#import "LoginViewController.h"
#import "User.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void) viewWillAppear:(BOOL)animated {
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {        
        [self FBLogin:nil];
    }
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            [self getUserInfo];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed: {
            [self showErrorView:error];
        }
            break;
        default:
            break;
    }
    
    if (error) {
        [self showErrorView:error];
    }
}

- (IBAction)FBLogin:(id)sender {
    
    if (!FBSession.activeSession.isOpen) {
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            [self sessionStateChanged:session state:state error:error];
        }];
    }else{
        RunAppDelegate *appDelegate = (RunAppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.currentUser = [User getCurrentUser];
        [self performSegueWithIdentifier: @"loggedInSegue" sender: self];
    }
}

- (void) showErrorView: (NSError*) error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:error.localizedDescription
                                                        delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
    [alertView show];
}

- (void) getUserInfo {
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if (!error) {
             NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
             NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
             User *newUser = (User*) [[NSManagedObject alloc] initWithEntity:userEntity insertIntoManagedObjectContext:context];
             [newUser init:user.name withFacebookId:user.id];
             NSLog(@"USER ID: %@", user.id);
             NSError *error;
             [context save:&error];
             
             RunAppDelegate *appDelegate = (RunAppDelegate *)[[UIApplication sharedApplication] delegate];
             appDelegate.currentUser = newUser;
             NSLog(@"GETTING NEW USER");
             [self performSegueWithIdentifier: @"loggedInSegue" sender: self];
         }
     }];
}


@end
