//
//  GameViewController.h
//  Matchismo
//
//  Created by Manners Oshafi on 22/06/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameResult.h"
#import "CardMatchingGame.h"
#import "GameSettings.h"

#define NO_GAME_MODE -1
#define TWO_CARD_MATCH_MODE 2
#define THREE_CARD_MATCH_MODE 3

@interface GameViewController : UIViewController

@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameStatusLabel;
@property (strong, nonatomic) GameResult *gameResult;
@property (strong, nonatomic) GameSettings *gameSettings;

- (void)updateUI;

- (IBAction)flipCard:(UIButton *)sender;
- (IBAction)dealCards:(UIButton *)sender;
@end
