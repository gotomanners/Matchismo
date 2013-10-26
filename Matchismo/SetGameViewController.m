//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Manners Oshafi on 22/06/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardCollectionViewCell.h"

@implementation SetGameViewController
@synthesize game = _game;
@synthesize gameResult = _gameResult;

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                  usingDeck:[self createDeck]];
        
        _game.matchBonus = self.gameSettings.matchBonus;
        _game.mismatchPenalty = self.gameSettings.mismatchPenalty;
        _game.flipCost = self.gameSettings.flipCost;
        
        _game.numberOfMatchingCards = 3;
    }
    return _game;
}

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.gameType = @"Set Game";
    return _gameResult;
}

- (Deck *) createDeck {
    return [[SetCardDeck alloc] init];
}

- (NSString *) cellReuseIdentifier {
    return @"SetCard";
}

- (NSUInteger) startingCardCount {
    return 12;
}

- (BOOL)removeUnplayableCards {
    return YES;
}

#define NUMBER_OF_EXTRA_CARDS 3
- (IBAction)dealExtraCards:(UIButton *)sender {
    if (self.game.deckIsEmpty) {
        sender.enabled = NO;
        sender.alpha = 0.5;
    } else {
        [self.game drawExtraCards:NUMBER_OF_EXTRA_CARDS];
        [self.cardCollectionView reloadData];
        [self.cardCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.game.numberOfCardsInGame-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }
}

- (NSAttributedString *)updateAttributedString:(NSAttributedString *)attributedString withAttributesOfCard:(SetCard *)card {
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    NSRange range = [[mutableAttributedString string] rangeOfString:card.contents];
    if (range.location != NSNotFound) {
        NSString *symbol = @"?";
        if ([card.symbol isEqualToString:@"oval"]) symbol = @"●";
        if ([card.symbol isEqualToString:@"squiggle"]) symbol = @"▲";
        if ([card.symbol isEqualToString:@"diamond"]) symbol = @"■";
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        if ([card.color isEqualToString:@"red"])
            [attributes setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        if ([card.color isEqualToString:@"green"])
            [attributes setObject:[UIColor greenColor] forKey:NSForegroundColorAttributeName];
        if ([card.color isEqualToString:@"purple"])
            [attributes setObject:[UIColor purpleColor] forKey:NSForegroundColorAttributeName];
        if ([card.shading isEqualToString:@"solid"])
            [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
        if ([card.shading isEqualToString:@"striped"])
            [attributes addEntriesFromDictionary:@{
                     NSStrokeWidthAttributeName : @-5,
                     NSStrokeColorAttributeName : attributes[NSForegroundColorAttributeName],
                 NSForegroundColorAttributeName : [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.1]
             }];
        if ([card.shading isEqualToString:@"open"])
            [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];
        symbol = [symbol stringByPaddingToLength:card.number withString:symbol startingAtIndex:0];
        [mutableAttributedString replaceCharactersInRange:range
                                     withAttributedString:[[NSAttributedString alloc]
                                                           initWithString:symbol
                                                           attributes:attributes]];
    }
    
    return mutableAttributedString;
}

- (NSAttributedString *) updateAttributedString:(NSAttributedString *)attributedString withFontSize:(CGFloat)fontSize {
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    UIFont *font=[UIFont fontWithName:@"Helvetica" size:fontSize];
    [mutableAttributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [mutableAttributedString length])];
    
    return mutableAttributedString;
}

- (void)updateUI {
    [super updateUI];
    NSAttributedString *lastFlip = [[NSAttributedString alloc] initWithString:
                                    self.game.matchStatus ? self.game.matchStatus : @""];

    self.gameStatusLabel.attributedText = lastFlip;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card atIndexPath:(NSIndexPath *)indexPath animate:(BOOL) animate {
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]] && [card isKindOfClass:[SetCard class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        SetCard *setCard = (SetCard *)card;
        setCardView.number = setCard.number;
        setCardView.color = setCard.color;
        setCardView.shading = setCard.shading;
        setCardView.symbol = setCard.symbol;
        setCardView.unplayable = setCard.isUnplayable;
        
        setCardView.alpha = setCard.isUnplayable && !indexPath.section ? 0.3 : 1.0;
        
        if ((setCard.isFaceUp || setCardView.faceUp) && animate) {
            [UIView transitionWithView:setCardView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                setCardView.faceUp = !indexPath.section ? setCard.isFaceUp : NO;
            } completion:NULL];
            
        } else {
            setCardView.faceUp = !indexPath.section ? setCard.isFaceUp : NO;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) return CGSizeMake(40, 40);
    if (indexPath.section == 1) return CGSizeMake(150, 20);
    return CGSizeMake(90, 70);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    if (section == 1) return UIEdgeInsetsMake(10, 10, 0, 0);
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
