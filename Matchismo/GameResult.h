//
//  GameResult.h
//  Matchismo
//
//  Created by Manners Oshafi on 09/06/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *) allGameResults;

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;

- (NSComparisonResult)compareDate:(GameResult *)aGameResult;
- (NSComparisonResult)compareScore:(GameResult *)aGameResult;
- (NSComparisonResult)compareDuration:(GameResult *)aGameResult;
@end
