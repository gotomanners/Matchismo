//
//  GameResult.m
//  Matchismo
//
//  Created by Manners Oshafi on 09/06/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import "GameResult.h"

@interface GameResult()
@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;
@end

@implementation GameResult

#define GAME_KEY @"Game"
#define ALL_RESULTS_KEY @"GameResults_All"
#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"

+ (NSArray *) allGameResults {
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    
    for (id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        GameResult *gameResult = [[GameResult alloc] initFromPropertyList: plist];
        [allGameResults addObject:gameResult];
    }
    return allGameResults;
}

// convenience initializer
- (id) initFromPropertyList: (id)plist {
    self = [self init];
    if ([plist isKindOfClass:[NSDictionary class]]) {
        NSDictionary *resultDictionary = (NSDictionary *) plist;
        _gameType = resultDictionary[GAME_KEY];
        _start = resultDictionary[START_KEY];
        _end = resultDictionary[END_KEY];
        _score = [resultDictionary[SCORE_KEY] intValue] ;
        if (!_start && !_end) {
            self = nil;
        }
    }
    return self;
}

- (void) synchronize {
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!mutableGameResultsFromUserDefaults) {
        mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    }
    mutableGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id) asPropertyList {
    return @{ START_KEY: self.start,
              END_KEY: self.end,
              SCORE_KEY: @(self.score),
              GAME_KEY : self.gameType
            };
}

// designated initializer
- (id) init {
    self = [super init];
    if (self) {
        _start = [NSDate date];
        _end = _start;
    }
    return self;
}

- (NSTimeInterval) duration {
    return [self.end timeIntervalSinceDate:self.start];
}

- (void) setScore:(int)score {
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}

- (NSComparisonResult)compareGameType:(GameResult *)aGameResult {
    return ([self.gameType compare:aGameResult.gameType]);
}

- (NSComparisonResult)compareDate:(GameResult *)aGameResult {
    return ([self.end compare:aGameResult.end]);
}

- (NSComparisonResult)compareScore:(GameResult *)aGameResult {
    return ([@(self.score) compare:@(aGameResult.score)]);
}

- (NSComparisonResult)compareDuration:(GameResult *)aGameResult {
    return ([@(self.duration) compare:@(aGameResult.duration)]);
}
@end
