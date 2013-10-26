//
//  GameViewController.m
//  Matchismo
//
//  Created by Manners Oshafi on 22/06/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation GameViewController

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.game.numberOfCardsInGame;
    }
    if (section == 1) {
        return [self.matchedCards count] ? 1 : 0;
    }
    if (section == 2) {
        return [self.matchedCards count];
    }
    return 0;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
        [self updateCell:cell usingCard:self.matchedCards[indexPath.item] atIndexPath:indexPath animate:NO];
        return cell;
    }
    if (indexPath.section == 1) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HeaderCell" forIndexPath:indexPath];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:cell.bounds];
        textLabel.text = @"Matched cards:";
        textLabel.textColor = [UIColor blackColor];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont fontWithName:@"System Bold" size:20.0];
        [cell addSubview:textLabel];
        return cell;
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    
    [self updateCell:cell usingCard:card atIndexPath:indexPath animate:NO];
    return cell;
}

- (NSString *) cellReuseIdentifier {
    return @"";
}

- (void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card atIndexPath:(NSIndexPath *)indexPath animate:(BOOL) animate {
    // abstract
}

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
    }
    return _game;
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

- (NSMutableArray *)matchedCards {
    if (!_matchedCards) {
        _matchedCards = [[NSMutableArray alloc] init];
    }
    return _matchedCards;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.game.matchBonus = self.gameSettings.matchBonus;
    self.game.mismatchPenalty = self.gameSettings.mismatchPenalty;
    self.game.flipCost = self.gameSettings.flipCost;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardCollectionView.delegate = self;
    [self updateUI];
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void) reset {
    [self.game reset];
    self.game = nil;
    self.gameResult = nil;
    self.matchedCards = nil;
    self.flipCount = 0; // reset flipCount
    self.gameStatusLabel.text = [NSString stringWithFormat:@"Flip cards to begin"];
    [self.cardCollectionView reloadData];
    if (!self.game.deckIsEmpty) {
        self.addCardsButton.enabled = YES;
        self.addCardsButton.alpha = 1.0;
    }
    [self updateUI];
}

- (IBAction)dealCards:(UIButton *)sender {
    [self reset];
}

- (IBAction)dealExtraCards:(UIButton *)sender {
    
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture {
    
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    Card *flippedCard = [self.game cardAtIndex:indexPath.item];
    
    if (indexPath && indexPath.section == 0 && !flippedCard.isUnplayable) { // faceUp and playable
        BOOL matchFound = [self.game flipCardAtIndex:indexPath.item];
        self.flipCount++;
        
        NSMutableArray *deleteIndexPaths = [[NSMutableArray alloc] init];
        NSMutableArray *matchedIndexPaths = [[NSMutableArray alloc] init];
        for (int i = self.game.numberOfCardsInGame - 1; i >= 0; i--) {
            Card *card = [self.game cardAtIndex:i];
            if (card.isUnplayable) {
                if (![self.matchedCards containsObject:card]) {
                    [matchedIndexPaths addObject:[NSIndexPath indexPathForItem:[self.matchedCards count] inSection:2]];
                    [self.matchedCards addObject:card];
                }
                if (self.removeUnplayableCards) {
                    [self.game removeCardAtIndex:i];
                    [deleteIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
                }
            }
        }
        
        [self.cardCollectionView performBatchUpdates:^{
            if ([deleteIndexPaths count]) {
                [self.cardCollectionView deleteItemsAtIndexPaths:deleteIndexPaths];
            }
            if ([matchedIndexPaths count]) {
//                self.cheatCards = nil;
                [self.cardCollectionView insertItemsAtIndexPaths:matchedIndexPaths];
                if ([self.matchedCards count] == self.game.numberOfMatchingCards) {
                    [self.cardCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:1]]];
                }
            }
        } completion:nil];
        
        self.gameResult.score = self.game.score;
        [self updateUI];
    }
}

- (Deck *)createDeck {
    return nil; // abstract
}

- (void)updateUI {
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        if (indexPath.section == 2) {
            [self updateCell:cell
                   usingCard:self.matchedCards[indexPath.item]
                 atIndexPath:indexPath animate:YES];
        } else {
            [self updateCell:cell
                   usingCard:[self.game cardAtIndex:indexPath.item]
                 atIndexPath:indexPath animate:YES];
        }
    }
    self.gameStatusLabel.text = self.game.matchStatus;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
