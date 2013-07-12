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

@property (strong, nonatomic) NSString *gameType;
@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;

- (NSComparisonResult)compareGameType:(GameResult *)aGameResult;
- (NSComparisonResult)compareDate:(GameResult *)aGameResult;
- (NSComparisonResult)compareScore:(GameResult *)aGameResult;
- (NSComparisonResult)compareDuration:(GameResult *)aGameResult;
@end
