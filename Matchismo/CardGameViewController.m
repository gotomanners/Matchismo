//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Manners Oshafi on 28/03/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "GameResult.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameStatusLabel;
@property (strong, nonatomic) GameResult *gameResult;
@end

@implementation CardGameViewController

@synthesize game = _game;

#define NO_GAME_MODE -1
#define TWO_CARD_MATCH_MODE 2
#define THREE_CARD_MATCH_MODE 3

- (CardMatchingGame *)game {
    if(!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[PlayingCardDeck alloc] init]
                                                andGameMode:TWO_CARD_MATCH_MODE];
    }
    return _game;
}

- (void) setGame:(CardMatchingGame *)game {
    _game = game;
}

- (GameResult *) gameResult {
    if (!_gameResult) {
        _gameResult = [[GameResult alloc] init];
    }
    return _gameResult;
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
    self.gameStatusLabel.text = [NSString stringWithFormat:@"Select a game mode to begin"];
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
    UIImage *cardBackImage = [UIImage imageNamed:@"cardBack.png"];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        if (cardButton.selected) {
            [cardButton setImage:nil forState:UIControlStateNormal];
        } else {
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        }
        
    }
    if (self.game.matchStatus) {
        self.gameStatusLabel.text = self.game.matchStatus;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
