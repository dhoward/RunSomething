#import <UIKit/UIKit.h>
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

@end

@implementation RunAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{	
    [application setStatusBarHidden:YES];
    
    UIViewController *navController = self.window.rootViewController;
    [(UINavigationController *)navController setNavigationBarHidden:YES animated:NO];
    
    return YES;
}
@end
int main(int argc, char *argv[]) {
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"RunAppDelegate");
        return retVal;
    }
}