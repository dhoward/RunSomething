//
//  LoginViewController.h
//  Run
//
//  Created by Daniel Howard on 2/24/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController{
    NSMutableData *urlData;
}
-(IBAction)FBLogin:(id)sender;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;
@end
