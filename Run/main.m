#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "Game.h"

#define DB_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

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
    
    [Parse setApplicationId:@"XiyQ0nn8lar0Hou0uVXTa1zFHdCpO8SzGZ1hU0Zq" clientKey:@"rhKly2xxuUJf1yLyzZGtwhATEMP5iRgNWRrs7Rzn"];
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:[DB_PATH stringByAppendingFormat:@"Database.sqlite"]];
    if(![persistentStoreCoordinator addPersistentStoreWithType: NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]){
        NSLog(@"Error creating persistent store coordinator: %@", error.localizedDescription);
    }

    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = persistentStoreCoordinator;
    
    self.managedObjectContext = context;
    
    return YES;
}

@end
int main(int argc, char *argv[]) {
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"RunAppDelegate");
        return retVal;
    }
}