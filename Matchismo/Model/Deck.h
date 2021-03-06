//
//  Deck.h
//  Matchismo
//
//  Created by Manners Oshafi on 28/03/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject
@property (nonatomic) int numberOfCardsInDeck;

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

- (Card *)drawRandomCard;
@end
