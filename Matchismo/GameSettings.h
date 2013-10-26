//
//  GameSettings.h
//  Matchismo
//
//  Created by Manners Oshafi on 11/07/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSettings : NSObject

@property (nonatomic) int matchBonus;
@property (nonatomic) int mismatchPenalty;
@property (nonatomic) int flipCost;
@property (nonatomic) int numberOfCardsToDealInCardMatchingGame;

@end
