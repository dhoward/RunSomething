//
//  Game.h
//  Run
//
//  Created by Daniel Howard on 2/26/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Game : NSManagedObject

@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSManagedObject *player1;
@property (nonatomic, retain) NSManagedObject *player2;

@end
