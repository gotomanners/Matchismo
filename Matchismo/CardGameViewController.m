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

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutlet UISegmentedControl *gameModeSelected;
@property (nonatomic) int selectedGameMode;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameStatusLabel;
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
                                                andGameMode:self.selectedGameMode];
    }
    return _game;
}

- (void) setGame:(CardMatchingGame *)game {
    _game = game;
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
    self.flipCount = 0; // reset flipCount
    self.gameModeSelected.alpha = 1; // show gameModeSelector
    self.gameStatusLabel.text = [NSString stringWithFormat:@"Select a game mode to begin"];
    [self.gameModeSelected setSelectedSegmentIndex:UISegmentedControlNoSegment]; // NO_GAME_MODE
    [self updateUI];
}

- (IBAction)gameModeSelected:(UISegmentedControl *)sender {
    [self updateUI];
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.selectedGameMode = TWO_CARD_MATCH_MODE;
            break;
        case 1:
            self.selectedGameMode = THREE_CARD_MATCH_MODE;
            break;
        default:
            self.selectedGameMode = NO_GAME_MODE;
            break;
    }
    self.game = nil;
    [self updateUI];
    self.gameModeSelected.alpha = 0;
    self.gameStatusLabel.text = [NSString stringWithFormat:@"Flip cards to begin! \n Match %@ to win",
                                 [self.gameModeSelected titleForSegmentAtIndex:[self.gameModeSelected selectedSegmentIndex]]];
}

- (IBAction)dealCards:(UIButton *)sender {
    [self reset];
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.gameModeSelected.alpha = 0;
    self.flipCount++;
    [self updateUI];
}

- (void)updateUI {
    UIImage *cardBackImage = [UIImage imageNamed:@"cardBack.png"];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        if (self.gameModeSelected.selectedSegmentIndex == UISegmentedControlNoSegment) {
//            cardButton.enabled = NO;
        }
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
