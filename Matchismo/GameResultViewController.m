//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Manners Oshafi on 09/06/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;
@property (strong, nonatomic) NSArray *allGameResults;

@end

@implementation GameResultViewController


- (void) setup {
    // Custom initialization
}

- (void) awakeFromNib {
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.allGameResults = [GameResult allGameResults];
    [self updateUI];
}

- (void) updateUI {
    NSString *displayText = @"";
    for (GameResult *result in self.allGameResults) {
        displayText = [displayText stringByAppendingFormat:@"Score: %d, (%@, %gs)\n",
                       result.score,
                       [NSDateFormatter localizedStringFromDate:result.end
                                                      dateStyle:NSDateFormatterShortStyle
                                                      timeStyle:NSDateFormatterShortStyle],
                       round(result.duration)];
    }
    self.display.text = displayText;
}

- (IBAction)sortByDate {
    self.allGameResults = [self.allGameResults sortedArrayUsingSelector:@selector(compareDate:)];
    [self updateUI];
}

- (IBAction)sortByScore {
    self.allGameResults = [self.allGameResults sortedArrayUsingSelector:@selector(compareScore:)];
    [self updateUI];

}

- (IBAction)sortByDuration {
    self.allGameResults = [self.allGameResults sortedArrayUsingSelector:@selector(compareDuration:)];
    [self updateUI];

}

@end
