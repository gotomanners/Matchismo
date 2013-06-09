//
//  PlayingCard.m
//  Matchismo
//
//  Created by Manners Oshafi on 28/03/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

+ (NSArray *)validSuits {
    return @[@"♠",@"♣",@"♥",@"♦"];
}

+ (NSArray *)rankStrings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank {
    return [self rankStrings].count-1;
}

- (int) match:(NSArray *)otherCards {
    
    int score = 0;
    int numMatches = 0;
    int otherCardsCount = [otherCards count];
    if (otherCardsCount > 0) {
        for (int i = 0; i < otherCardsCount; i++) { // TODO
            id otherCard1 = otherCards[i];
            if ([otherCard1 isKindOfClass:[PlayingCard class]]) {
                PlayingCard *card1 = (PlayingCard *)otherCard1;
                
                for (int j = i+1; j < otherCardsCount; j++) {
                    id otherCard2 =otherCards[j];
                    if ([otherCard2 isKindOfClass:[PlayingCard class]])
                    {
                        PlayingCard *card2 =(PlayingCard *)otherCard2;
                        
                        // check for the same suit
                        if ([card1.suit isEqualToString:card2.suit]) {
                            score += 1;
                            numMatches++;
                        }
                        // check for the same rank
                        if (card1.rank == card2.rank) {
                            score += 4;
                            numMatches++;
                        }
                    }
                }
            }
        }
        
        if (numMatches < [otherCards count] -1) {
            score = 0;
        }
        
    }
    return score;
}

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit {
    if( [[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
