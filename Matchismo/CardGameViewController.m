//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Manners Oshafi on 28/03/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"
#import "PlayingCardView.h"

@interface CardGameViewController ()

@end

@implementation CardGameViewController

@synthesize game = _game;
@synthesize gameResult = _gameResult;

- (CardMatchingGame *)game {
    if(!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                  usingDeck:[self createDeck]];
        _game.matchBonus = self.gameSettings.matchBonus;
        _game.mismatchPenalty = self.gameSettings.mismatchPenalty;
        _game.flipCost = self.gameSettings.flipCost;
        
        _game.numberOfMatchingCards = 2;
    }
    return _game;
}

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.gameType = @"Card Matching";
    return _gameResult;
}

- (Deck *) createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger) startingCardCount {
    return self.gameSettings.numberOfCardsToDealInCardMatchingGame;
}

- (NSString *) cellReuseIdentifier {
    return @"PlayingCard";
}

- (void)updateUI {
    [super updateUI];
    self.gameStatusLabel.text = self.game.matchStatus;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card atIndexPath:(NSIndexPath *)indexPath animate:(BOOL) animate {
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]] && [card isKindOfClass:[PlayingCard class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        PlayingCard *playingCard = (PlayingCard *)card;
        playingCardView.rank = playingCard.rank;
        playingCardView.suit = playingCard.suit;
        playingCardView.unplayable = playingCard.isUnplayable;
        
        playingCardView.alpha = playingCard.isUnplayable && !indexPath.section ? 0.3 : 1.0;
        
        if (!playingCardView.unplayable && (playingCard.isFaceUp || playingCardView.faceUp) && animate) {
            [UIView transitionWithView:playingCardView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                playingCardView.faceUp = !indexPath.section ? playingCard.isFaceUp : YES;
            } completion:NULL];
        } else {
            playingCardView.faceUp = !indexPath.section ? playingCard.isFaceUp : YES;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) return CGSizeMake(56, 72);
    if (indexPath.section == 1) return CGSizeMake(150, 20);
    return CGSizeMake(70, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    if (section == 1) return UIEdgeInsetsMake(10, 10, 0, 0);
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
