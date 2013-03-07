//
//  User.m
//  Run
//
//  Created by Daniel Howard on 2/26/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic name;
@dynamic facebookId;

- (void) init: (NSString*)theName withFacebookId: (NSString*)theId {
    self.facebookId = theId;
    self.name = theName;
}

+ (User*) getCurrentUser {
    NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:userEntity];
    
    NSError *error;
    NSArray *users = [NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:&error]];
    
    NSLog(@"USING CURRENT USER: %@", ((User*)users[0]).name);
    if([users count] == 0)
        return nil;
    else
        return (User*)users[0];
}

@end
