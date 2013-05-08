//
//  RunAppDelegate.m
//  Run
//
//  Created by Daniel Howard on 3/6/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "RunAppDelegate.h"

@implementation RunAppDelegate

@synthesize currentUser;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
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
    [FBProfilePictureView class];
    [application setStatusBarHidden:YES];
    
    _window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
    
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
