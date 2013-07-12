//
//  SetCard.h
//  Matchismo
//
//  Created by Manners Oshafi on 22/06/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) NSUInteger number;

+ (NSArray *) validColors;
+ (NSArray *) validSymbols;
+ (NSArray *) validShadings;
+ (NSUInteger) maxNumber;

@end
