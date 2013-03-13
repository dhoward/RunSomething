//
//  User.m
//  Run
//
//  Created by Daniel Howard on 2/26/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic userId;
@dynamic name;
@dynamic facebookId;

- (void) init: (NSString*)theName withUserId: (NSString*)userId andFacebookId: (NSString*)facebookId {
    self.userId = userId;
    self.facebookId = facebookId;
    self.name = theName;
}

+ (User*) getCurrentUser {
    NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:userEntity];
    
    NSError *error;
    NSArray *users = [NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:&error]];
    
    if([users count] == 0)
        return nil;
    else {
        NSLog(@"USING CURRENT USER: %@", ((User*)users[0]).name);
        return (User*)users[0];
    }
}

+ (User*) saveUser: userId withName: username andFacebookId: facebookId {
    NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    
    //delete old user object if it exists
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:userEntity];
    NSError *error;
    NSArray* users = [NSArray arrayWithArray:[context executeFetchRequest:fetchRequest error:&error]];
    for (NSManagedObject * u in users) {
        [context deleteObject:u];
    }
    
    //create new user object
    User *newUser = (User*) [[NSManagedObject alloc] initWithEntity:userEntity insertIntoManagedObjectContext:context];
    [newUser init:username withUserId:userId andFacebookId:facebookId];
    NSLog(@"SAVING USER: %@", username);
    NSError *error2;
    [context save:&error2];
    
    
    return newUser;
}

@end
