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
    NSLog(@"SET NAME AND ID:%@, %@", self.name, self.facebookId);
}

@end
