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

@interface GameViewController : UIViewController

@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameStatusLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;
@property (strong, nonatomic) GameResult *gameResult;
@property (strong, nonatomic) GameSettings *gameSettings;
@property (nonatomic) BOOL removeUnplayableCards;

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture;
- (IBAction)dealCards:(UIButton *)sender;
- (IBAction)dealExtraCards:(UIButton *)sender;

//abstract
@property (nonatomic) NSUInteger startingCardCount;
@property (strong, nonatomic) NSMutableArray *matchedCards;

- (Deck *) createDeck;
- (NSString *) cellReuseIdentifier;
- (void)updateUI;
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card atIndexPath:(NSIndexPath *)indexPath animate:(BOOL) animate;

@end
