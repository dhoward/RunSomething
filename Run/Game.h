//
//  Game.h
//  Run
//
//  Created by Daniel Howard on 2/26/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"


@interface Game : NSManagedObject

@property (nonatomic, retain) User *player1;
@property (nonatomic, retain) User *player2;

- (void) initWithPlayer1: (User*)thePlayer1 andPlayer2: (User*)thePlayer2;

@end
