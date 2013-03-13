//
//  LoginViewController.m
//  Run
//
//  Created by Daniel Howard on 2/24/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "RunAppDelegate.h"
#import "LoginViewController.h"
#import "NSString+URLEncoding.h"
#import "User.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void) viewWillAppear:(BOOL)animated {    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [self FBLogin:nil];
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

- (void) getFBUserInfo {
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if (!error) {
             [self createUser:user.name withFacebookId:user.id];
         }
     }];
}

- (void) createUser: (NSString*) userName withFacebookId: (NSString*) facebookId {
    NSString *myRequestString = [NSString stringWithFormat:@"name=%@&facebookId=%@", [userName urlEncodeUsingEncoding:NSUTF8StringEncoding], facebookId];
    NSString *requestString = [NSString stringWithFormat:@"http://localhost:3000/user?%@",myRequestString];
    
    NSLog(@"REQUEST: %@", requestString);
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
    [theRequest setHTTPMethod: @"POST"];
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    urlData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [urlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *jsonParsingError = nil;
    NSDictionary *object = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:&jsonParsingError];
    NSLog(@"OBJECT: %@", object);
    NSString *userId = [object objectForKey:@"_id"];
    NSString *username = [object objectForKey:@"name"];
    NSString *fbId = [object objectForKey:@"facebookId"];    
    [self saveLocalUser:userId withName:username andFacebookId:fbId];
}

- (void) saveLocalUser:(NSString*) userId withName:(NSString*) username andFacebookId:(NSString*) facebookId {
    
    User* newUser = [User saveUser: userId withName: username andFacebookId: facebookId];

    RunAppDelegate *appDelegate = (RunAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentUser = newUser;
    
    [self performSegueWithIdentifier: @"loggedInSegue" sender: self];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            [self getFBUserInfo];
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

- (void) showErrorView: (NSError*) error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}


@end
