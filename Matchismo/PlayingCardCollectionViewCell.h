//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Manners Oshafi on 15/07/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end
