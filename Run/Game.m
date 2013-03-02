//
//  Game.m
//  Run
//
//  Created by Daniel Howard on 2/26/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "Game.h"


@implementation Game

@dynamic player1;
@dynamic player2;

- (void) initWithPlayer1: (User*)thePlayer1 andPlayer2: (User*)thePlayer2 {
    self.player1 = thePlayer1;
    self.player2 = thePlayer2;
}

@end
