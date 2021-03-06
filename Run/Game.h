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

@property (nonatomic, retain) NSString * gameId;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) NSString * promptId;
@property (nonatomic, retain) NSNumber * promptPoints;
@property (nonatomic, retain) NSString * promptWord;
@property (nonatomic, retain) NSString * promptImage;
@property BOOL promptGuessed;
@property (nonatomic, retain) NSString * opponentName;
@property (nonatomic, retain) NSNumber * opponentFacebookId;
@property (nonatomic) BOOL yourMove;

@end
