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
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@property (strong, nonatomic) NSMutableArray *cardsToMatchAgainst; // of Card
@end

@implementation CardMatchingGame

// Game modes
#define NO_GAME_MODE -1
#define TWO_CARD_MATCH_MODE 2
#define THREE_CARD_MATCH_MODE 3

// Game scoring
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void) reset {
    self.score = 0;
    self.cards = nil;
    self.cardsToMatchAgainst = nil;
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

- (void) setGameMode:(NSUInteger)gameMode {
    if (gameMode == TWO_CARD_MATCH_MODE || gameMode == THREE_CARD_MATCH_MODE) {
        _gameMode = gameMode;
        for (Card *card in self.cards) { // enable cards for gameplay
            card.unplayable = NO;
        }
    } else {
        _gameMode = NO_GAME_MODE;
        for (Card *card in self.cards) { // disable cards for gameplay
            card.unplayable = YES;
        }
    }
}

- (id) initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck andGameMode:(NSUInteger)mode {
    
    self = [super init];
    
    if(self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if(!card) {
                self = nil;
            } else {
                card.unplayable = YES; // disable cards for game mode selection
                self.cards[i] = card;
            }
        }
        self.gameMode = mode;
    }
    
    return self;
}

- (void) flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    [self.cardsToMatchAgainst removeAllObjects];
    
    if(card && !card.isUnplayable) { //playable
        if(!card.isFaceUp) {
            self.score -= FLIP_COST;
            [self.cardsToMatchAgainst addObject:card];
            NSString *matches = @"";
            self.matchStatus = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            for (Card *otherCard in self.cards) {
                if(otherCard.isFaceUp && !otherCard.isUnplayable) { //faceUp & playable
                    [self.cardsToMatchAgainst addObject:otherCard];
                    
                    if ([self.cardsToMatchAgainst count] == self.gameMode) {
                        int matchScore = [card match:self.cardsToMatchAgainst];
                        if (matchScore) {
                            for (Card *matchedCard in self.cardsToMatchAgainst) {
                                matchedCard.unplayable = YES;
                            }
                            
                            int calculatedScore = matchScore * MATCH_BONUS;
                            self.score += calculatedScore;
                            matches =[self.cardsToMatchAgainst componentsJoinedByString:@" & "];
                            self.matchStatus = [NSString stringWithFormat:@"Matched %@ for %d points", matches, calculatedScore];
                        } else {
                            for (Card *matchedCard in self.cardsToMatchAgainst) {
                                if (matchedCard != card) matchedCard.faceUp = NO;
                            }
                            
                            matches =[self.cardsToMatchAgainst componentsJoinedByString:@" & "];
                            self.score -= MISMATCH_PENALTY;
                            self.matchStatus = [NSString stringWithFormat:@"%@ don't match! %d point penalty!", matches, MISMATCH_PENALTY];
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
