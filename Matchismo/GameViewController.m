//
//  GameViewController.m
//  Matchismo
//
//  Created by Manners Oshafi on 22/06/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController()

@end

@implementation GameViewController

- (CardMatchingGame *)game {
    return nil; // needs to be implemented in sub class
}

- (GameResult *) gameResult {
    if (!_gameResult) {
        _gameResult = [[GameResult alloc] init];
    }
    return _gameResult;
}

- (GameSettings *)gameSettings {
    if (!_gameSettings) {
        _gameSettings = [[GameSettings alloc] init];
    }
    return _gameSettings;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.game.matchBonus = self.gameSettings.matchBonus;
    self.game.mismatchPenalty = self.gameSettings.mismatchPenalty;
    self.game.flipCost = self.gameSettings.flipCost;
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void) reset {
    [self.game reset];
    self.game = nil;
    self.gameResult = nil;
    self.flipCount = 0; // reset flipCount
    self.gameStatusLabel.text = [NSString stringWithFormat:@"Flip cards to begin"];
    [self updateUI];
}

- (IBAction)dealCards:(UIButton *)sender {
    [self reset];
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
    self.gameResult.score = self.game.score;
}

- (void)updateUI {
    if (self.game.matchStatus) {
        self.gameStatusLabel.text = self.game.matchStatus;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
