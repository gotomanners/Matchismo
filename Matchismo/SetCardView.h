//
//  SetCardView.h
//  Matchismo
//
//  Created by Manners Oshafi on 17/07/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface SetCardView : CardView

@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) NSUInteger number;

@end
