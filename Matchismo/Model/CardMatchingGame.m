//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Manners Oshafi on 01/04/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score;
@property(readwrite, nonatomic) NSMutableArray* matchStatusData; // store match status data in array and pass it to controller
@property (strong, nonatomic) NSMutableArray *cards; // of Card

@property (nonatomic, strong) Deck *deck;
@property (nonatomic, readwrite) int numberOfCardsInGame;
@end

@implementation CardMatchingGame

@synthesize numberOfMatchingCards = _numberOfMatchingCards;

- (void) reset {
    self.score = 0;
    self.cards = nil;
}

- (int)matchBonus {
    if (!_matchBonus < 0) {
        _matchBonus = 4;
    }
    return _matchBonus;
}

- (int)mismatchPenalty {
    if (!_mismatchPenalty < 0) {
        _mismatchPenalty = 2;
    }
    return _mismatchPenalty;
}

- (int)flipCost {
    if (!_flipCost < 0) {
        _flipCost = 1;
    }
    return _flipCost;
}

- (NSMutableArray *) cards {
    if(!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (void) setNumberOfMatchingCards:(int)numberOfMatchingCards {
    
    if (numberOfMatchingCards < 2) {
        _numberOfMatchingCards = 2;
    } else if (numberOfMatchingCards > 3) {
        _numberOfMatchingCards = 3;
    } else {
        _numberOfMatchingCards = numberOfMatchingCards;
    }
}

- (id) initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    self = [super init];
    
    if(self) {
        self.deck = deck;
        self.numberOfCardsInGame = count;
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if(card) {
                self.cards[i] = card;
            } else {
                self = nil;
            }
        }
        _matchBonus = -1;
        _mismatchPenalty = -1;
        _flipCost = -1;
    }
    
    return self;
}

- (Card *) cardAtIndex:(NSUInteger)index {
    if(index < [self.cards count]) {
        return self.cards[index];
    } else {
        return nil;
    }
}

- (BOOL)flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    BOOL matchFound = NO;
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            NSMutableArray *otherContents = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [otherCards addObject:otherCard];
                    [otherContents addObject:otherCard.contents];
                }
            }
            if ([otherCards count] < self.numberOfMatchingCards - 1) {
                self.matchStatus = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            } else {
                int matchScore = [card match:otherCards];
                if (matchScore) {
                    matchFound = YES;
                    card.unplayable = YES;
                    for (Card *otherCard in otherCards) {
                        otherCard.unplayable = YES;
                    }
                    self.score += matchScore * self.matchBonus;
                    self.matchStatus = [NSString stringWithFormat:@"Matched %@ & %@ for %d points",
                                        card.contents,
                                        [otherContents componentsJoinedByString:@" & "],
                                        matchScore * self.matchBonus];
                } else {
                    matchFound = NO;
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }
                    self.score -= self.mismatchPenalty;
                    self.matchStatus = [NSString stringWithFormat:@"%@ & %@ don’t match! %d point penalty!",
                                        card.contents,
                                        [otherContents componentsJoinedByString:@" & "],
                                        self.mismatchPenalty];
                }
            }
            self.score -= self.flipCost;
        }
        card.faceUp = !card.faceUp;
    }
    return matchFound;
}

- (BOOL)deckIsEmpty {
    if (self.deck.numberOfCardsInDeck) {
        return NO;
    }
    return YES;
}

- (BOOL) drawExtraCards:(NSInteger)numberOfCardsNeeded {
    int numberOfCardsLeftInDeck = [self.deck numberOfCardsInDeck];
    BOOL enoughCardsInDeck = numberOfCardsLeftInDeck >= numberOfCardsNeeded;
    if (enoughCardsInDeck) {
        for (int i = 0; i < numberOfCardsNeeded; i++) {
            Card *card = [self.deck drawRandomCard];
            if(card) {
                [self.cards addObject:card];
                self.numberOfCardsInGame += 1;
            }
        }
        return YES;
    }
    return NO;
}

- (void)removeCardAtIndex:(NSUInteger)index {
    [self.cards removeObjectAtIndex:index];
    self.numberOfCardsInGame = [self.cards count];
}

//- (NSMutableArray *) removeMatchedCardsFromGame {
//    NSMutableArray *matchedCards = [[NSMutableArray alloc] init];
//    NSMutableArray *matchedCardIndexes = [[NSMutableArray alloc] init];
//    for (Card *card in self.cards) {
//        if (card.isFaceUp && card.isUnplayable) { // faceUp and unplayable AKA matched
//            [matchedCards addObject:card];
//            [matchedCardIndexes addObject:[NSIndexPath indexPathForItem:[self.cards indexOfObject:card] inSection:0]];
//        }
//    }
//    if ([matchedCards count]) {
//        [self.cards removeObjectsInArray:matchedCards];
//        self.numberOfCardsInGame = [self.cards count];
//    }
//    return matchedCardIndexes;
//}

@end
