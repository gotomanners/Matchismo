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
@property (strong, nonatomic) NSMutableArray *cardsToMatchAgainst; // of Card
@end

@implementation CardMatchingGame

@synthesize numberOfMatchingCards = _numberOfMatchingCards;

- (void) reset {
    self.score = 0;
    self.cards = nil;
    self.cardsToMatchAgainst = nil;
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

- (NSMutableArray *) cardsToMatchAgainst {
    if(!_cardsToMatchAgainst) {
        _cardsToMatchAgainst = [[NSMutableArray alloc] init];
    }
    return _cardsToMatchAgainst;
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
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if(!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
        _matchBonus = -1;
        _mismatchPenalty = -1;
        _flipCost = -1;
    }
    
    return self;
}

- (void) flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    [self.cardsToMatchAgainst removeAllObjects];
    
    if(card && !card.isUnplayable) { //playable
        if(!card.isFaceUp) {
            self.score -= self.flipCost;
            [self.cardsToMatchAgainst addObject:card];
            NSString *matches = @"";
            self.matchStatus = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            for (Card *otherCard in self.cards) {
                if(otherCard.isFaceUp && !otherCard.isUnplayable) { //faceUp & playable
                    [self.cardsToMatchAgainst addObject:otherCard];
                    
                    if ([self.cardsToMatchAgainst count] == self.numberOfMatchingCards) {
                        int matchScore = [card match:self.cardsToMatchAgainst];
                        if (matchScore) {
                            for (Card *matchedCard in self.cardsToMatchAgainst) {
                                matchedCard.unplayable = YES;
                            }
                            
                            int calculatedScore = matchScore * self.matchBonus;
                            self.score += calculatedScore;
                            matches =[self.cardsToMatchAgainst componentsJoinedByString:@" & "];
                            self.matchStatus = [NSString stringWithFormat:@"Matched %@ for %d points", matches, calculatedScore];
                        } else {
                            for (Card *matchedCard in self.cardsToMatchAgainst) {
                                if (matchedCard != card) matchedCard.faceUp = NO;
                            }
                            
                            matches =[self.cardsToMatchAgainst componentsJoinedByString:@" & "];
                            self.score -= self.mismatchPenalty;
                            self.matchStatus = [NSString stringWithFormat:@"%@ don't match! %d point penalty!", matches, self.mismatchPenalty];
                        }
                        break;
                    }
                }
                
            }
        }
        card.faceUp = !card.faceUp;
    }
}

- (Card *) cardAtIndex:(NSUInteger)index {
    if(index < [self.cards count]) {
        return self.cards[index];
    } else {
        return nil;
    }
}

@end
