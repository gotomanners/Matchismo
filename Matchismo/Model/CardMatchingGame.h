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

@property (nonatomic) int numberOfMatchingCards;
@property(readonly, nonatomic) int score;
@property(nonatomic) NSString* matchStatus;
@property(readonly, nonatomic) NSMutableArray* matchStatusData;

@property (nonatomic) int matchBonus;
@property (nonatomic) int mismatchPenalty;
@property (nonatomic) int flipCost;

// designated initializer
- (id) initWithCardCount:(NSUInteger)count
               usingDeck:(Deck *)deck;

- (void) flipCardAtIndex:(NSUInteger)index;
- (Card *) cardAtIndex:(NSUInteger)index;
- (void) reset;
@end
