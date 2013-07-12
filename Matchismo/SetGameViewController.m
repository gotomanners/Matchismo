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

@implementation SetGameViewController
@synthesize game = _game;
@synthesize gameResult = _gameResult;

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[SetCardDeck alloc] init]];
        
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
    NSAttributedString *lastFlip = [[NSAttributedString alloc] initWithString:
                                           self.game.matchStatus ? self.game.matchStatus : @""];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:card.contents];
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *) card;
            title = [self updateAttributedString:title withAttributesOfCard:setCard];
            lastFlip = [self updateAttributedString:lastFlip
                               withAttributesOfCard:setCard];
            lastFlip = [self updateAttributedString:lastFlip withFontSize:11.0f];
            [cardButton setAttributedTitle:title forState:UIControlStateNormal];
            cardButton.selected = setCard.isFaceUp;
            cardButton.enabled = !setCard.isUnplayable;
            cardButton.alpha = (setCard.isUnplayable ? 0.3 : 1.0);
            if (setCard.isFaceUp) {
                [cardButton setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
            } else {
                [cardButton setBackgroundColor:[UIColor clearColor]];
            }

        }
    }
    
    [super updateUI];
    self.gameStatusLabel.attributedText = lastFlip;
}

@end
