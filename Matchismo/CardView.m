//
//  CardView.m
//  Matchismo
//
//  Created by Manners Oshafi on 17/07/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import "CardView.h"

@implementation CardView

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.80

- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)setUnplayable:(BOOL)unplayable {
    _unplayable = unplayable;
    [self setNeedsDisplay];
}

- (void) pinch:(UIPinchGestureRecognizer *) gesture {
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        self.faceCardScaleFactor = gesture.scale;
        gesture.scale = 1;
    }
}

# pragma mark - Initialization

- (void) setup {
    // Initialization code
}

- (void) awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (CGContextRef)pushContext {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    return context;
}

- (CGContextRef)popContext {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextRestoreGState(context);
    return context;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
