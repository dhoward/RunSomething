#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "Game.h"
#import "User.h"

#define DB_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

int main(int argc, char *argv[]) {
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"RunAppDelegate");
        return retVal;
    }
}