#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UIBezierPath-Smoothing.h"
#import "DrawingView.h"
#import "Game.h"

#define DB_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

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
    @property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
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
    
    
//    NSLog(@"CONTEXT");
//    NSLog(@"%@", self.managedObjectContext);
//    
//    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
//    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
//    
////    NSError *error;
////    NSURL *url = [NSURL fileURLWithPath:[DB_PATH stringByAppendingFormat:@"Database.sqlite"]];
////    if(![persistentStoreCoordinator addPersistentStoreWithType: NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]){
////        NSLog(@"Error creating persistent store coordinator: %@", error.localizedDescription);
////    }
//
//    //NSManagedObjectContext *context = [self managedObjectContext];
//    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
//    context.persistentStoreCoordinator = persistentStoreCoordinator;
//    
//    self.managedObjectContext = context;
//    
//    NSManagedObject *user1 = [NSEntityDescription
//                              insertNewObjectForEntityForName:@"User"
//                              inManagedObjectContext:context];
//    [user1 setValue:[NSNumber numberWithDouble:1] forKey:@"id"];
//    [user1 setValue:[NSNumber numberWithDouble:1000] forKey:@"facebookId"];
//    [user1 setValue:@"Dan" forKey:@"name"];
//    
//    NSManagedObject *user2 = [NSEntityDescription
//                              insertNewObjectForEntityForName:@"User"
//                              inManagedObjectContext:context];
//    [user2 setValue:[NSNumber numberWithDouble:2] forKey:@"id"];
//    [user2 setValue:[NSNumber numberWithDouble:2000] forKey:@"facebookId"];
//    [user2 setValue:@"Matt" forKey:@"name"];
//
//    NSManagedObject *user3 = [NSEntityDescription
//                              insertNewObjectForEntityForName:@"User"
//                              inManagedObjectContext:context];
//    [user3 setValue:[NSNumber numberWithDouble:3] forKey:@"id"];
//    [user3 setValue:[NSNumber numberWithDouble:3000] forKey:@"facebookId"];
//    [user3 setValue:@"Chris" forKey:@"name"];
//
//    NSManagedObject *game1 = [NSEntityDescription
//                              insertNewObjectForEntityForName:@"Game"
//                              inManagedObjectContext:context];
//    [game1 setValue:[NSNumber numberWithDouble:1] forKey:@"id"];
//    [game1 setValue:user1 forKey:@"player1"];
//    [game1 setValue:user2 forKey:@"player2"];
//    
//    NSManagedObject *game2 = [NSEntityDescription
//                              insertNewObjectForEntityForName:@"Game"
//                              inManagedObjectContext:context];
//    [game2 setValue:[NSNumber numberWithDouble:2] forKey:@"id"];
//    [game2 setValue:user1 forKey:@"player1"];
//    [game2 setValue:user3 forKey:@"player2"];
//
//    
//    if (![context save:&error]) {
//        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//    }
//    
    return YES;
}

@end
int main(int argc, char *argv[]) {
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"RunAppDelegate");
        return retVal;
    }
}