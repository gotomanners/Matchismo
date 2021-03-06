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
    if ([otherCards count]) {
        for (id otherCard in otherCards) {
            if ([otherCard isKindOfClass:[PlayingCard class]]) {
                PlayingCard *otherPlayingCard = (PlayingCard *)otherCard;
                if ([otherPlayingCard.suit isEqualToString:self.suit]) {
                    score += 1;
                } else if (otherPlayingCard.rank == self.rank) {
                    score += 4;
                } else {
                    score = 0;
                    break;
                }
            }
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
