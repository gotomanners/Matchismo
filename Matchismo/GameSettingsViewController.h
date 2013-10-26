//
//  GameSettingsViewController.h
//  Matchismo
//
//  Created by Manners Oshafi on 11/07/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameSettings.h"

@interface GameSettingsViewController : UIViewController

@property (strong, nonatomic) GameSettings *gameSettings;
@property (weak, nonatomic) IBOutlet UILabel *matchBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *mismatchPenaltyLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCardsToDealInCardMatchingGameLabel;

@property (weak, nonatomic) IBOutlet UISlider *matchBonusSlider;
@property (weak, nonatomic) IBOutlet UISlider *mismatchPenaltySlider;
@property (weak, nonatomic) IBOutlet UISlider *flipCostSlider;
@property (weak, nonatomic) IBOutlet UISlider *numberOfCardsToDealInCardMatchingGameSlider;

@end
