//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Manners Oshafi on 01/04/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (nonatomic) NSUInteger gameMode;
@property(readonly, nonatomic) int score;
@property(nonatomic) NSString* matchStatus;

// designated initializer
- (id) initWithCardCount:(NSUInteger)count
               usingDeck:(Deck *)deck
             andGameMode:(NSUInteger)mode;

- (void) flipCardAtIndex:(NSUInteger)index;
- (Card *) cardAtIndex:(NSUInteger)index;
- (void) reset;
@end
