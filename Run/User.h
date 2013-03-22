//
//  User.h
//  Run
//
//  Created by Daniel Howard on 2/26/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * facebookId;

- (void) init: (NSString*)theName withUserId: (NSString*)userId andFacebookId: (NSNumber*)facebookId;
+ (User*) getCurrentUser;
+ (User*) saveUser: userId withName: username andFacebookId: facebookId;

@end
