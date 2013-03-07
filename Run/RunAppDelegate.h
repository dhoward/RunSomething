//
//  RunAppDelegate.h
//  Run
//
//  Created by Daniel Howard on 3/6/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "User.h"

#define DB_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface RunAppDelegate : NSObject <UIApplicationDelegate>
    @property (strong, nonatomic) UIWindow *window;
    @property (nonatomic, strong) User *currentUser;
    @property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
    - (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;
@end
