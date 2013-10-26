//
//  GameSettingsViewController.m
//  Matchismo
//
//  Created by Manners Oshafi on 11/07/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import "GameSettingsViewController.h"

@interface GameSettingsViewController ()

@end

@implementation GameSettingsViewController

- (void) setup {
    // Custom initialization
}

- (void) awakeFromNib {
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.matchBonusSlider.value = self.gameSettings.matchBonus;
    self.mismatchPenaltySlider.value = self.gameSettings.mismatchPenalty;
    self.flipCostSlider.value = self.gameSettings.flipCost;
    self.numberOfCardsToDealInCardMatchingGameSlider.value = self.gameSettings.numberOfCardsToDealInCardMatchingGame;
    
    [self setLabel:self.matchBonusLabel forSlider:self.matchBonusSlider];
    [self setLabel:self.mismatchPenaltyLabel forSlider:self.mismatchPenaltySlider];
    [self setLabel:self.flipCostLabel forSlider:self.flipCostSlider];
    [self setLabel:self.numberOfCardsToDealInCardMatchingGameLabel forSlider:self.numberOfCardsToDealInCardMatchingGameSlider];
}


- (GameSettings *)gameSettings {
    if (!_gameSettings) {
        _gameSettings = [[GameSettings alloc]init];
    }
    return _gameSettings;
}

- (void)setLabel:(UILabel *)label forSlider:(UISlider *)slider {
    int sliderValue;
    sliderValue = lroundf(slider.value);
    [slider setValue:sliderValue animated:NO];
    label.text = [NSString stringWithFormat:@"%d", sliderValue];
}

- (IBAction)matchBonusSliderChanged:(UISlider *)sender {
    [self setLabel:self.matchBonusLabel forSlider:sender];
    self.gameSettings.matchBonus = floor(sender.value);
}

- (IBAction)mismatchPenaltySliderChanged:(UISlider *)sender {
    [self setLabel:self.mismatchPenaltyLabel forSlider:sender];
    self.gameSettings.mismatchPenalty = floor(sender.value);
}

- (IBAction)flipCostSliderChanged:(UISlider *)sender {
    [self setLabel:self.flipCostLabel forSlider:sender];
    self.gameSettings.flipCost = floor(sender.value);
}

- (IBAction)numberOfCardsToDealInCardMatchingGameSliderChanged:(UISlider *)sender {
    [self setLabel:self.numberOfCardsToDealInCardMatchingGameLabel forSlider:sender];
    self.gameSettings.numberOfCardsToDealInCardMatchingGame = floor(sender.value);
}
@end
