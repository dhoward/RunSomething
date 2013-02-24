#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UIBezierPath-Smoothing.h"
#import "DrawingView.h"

@interface DrawingViewController : UIViewController
@end

@implementation DrawingViewController
- (void) clear
{
    [(DrawingView *)self.view clear];
}

- (void) loadView
{    
    [super loadView];
    RESIZABLE(self.view);
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self clear];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
@end

#pragma mark -

#pragma mark Application Setup
@interface RunAppDelegate : NSObject <UIApplicationDelegate>

    @property (strong, nonatomic) UIWindow *window;
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
    - (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;

@end

@implementation RunAppDelegate

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error {
    switch (state) {
        case FBSessionStateOpen: {
                    }
        case FBSessionStateClosed: {
            break;
        }
        case FBSessionStateClosedLoginFailed: {
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        }
        default:
            break;
    }
    
    if (error) {
       
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{	
    [application setStatusBarHidden:YES];
    
    UIViewController *navController = self.window.rootViewController;
    [(UINavigationController *)navController setNavigationBarHidden:YES animated:NO];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"LOGGED IN");
        // To-do, show logged in view
    } else {
        NSLog(@"NOT LOGGED IN");
        // No, display the login page.
    }
    
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
                break;
        }
    }];
    
    return YES;
}
@end
int main(int argc, char *argv[]) {
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"RunAppDelegate");
        return retVal;
    }
}