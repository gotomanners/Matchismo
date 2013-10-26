//
//  SetCardView.m
//  Matchismo
//
//  Created by Manners Oshafi on 17/07/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

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

- (void)setColor:(NSString *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading {
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSString *)symbol {
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number {
    _number = number;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:12.0];
    [roundedRect addClip];
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawSetCardSymbol];
}
#define SHAPE_H_OFFSET 0.3

- (CGPoint)calculateSymbolOrigin:(CGSize)symbolSize hOffset:(CGFloat)hOffset {
    CGPoint middle = CGPointMake((self.bounds.size.width/2), self.bounds.size.height/2);
    CGPoint symbolOrigin = CGPointMake(
                                      middle.x - symbolSize.width/2.0 - (hOffset * self.bounds.size.width),
                                      middle.y - symbolSize.height/2.0
                                      );
    return symbolOrigin;
}

#define SYMBOL_SIZE_FACTOR 4.0
#define SYMBOL_LINE_WIDTH 3.0

- (UIBezierPath *)drawOval:(CGSize)symbolSize symbolOrigin:(CGPoint)symbolOrigin {
    UIBezierPath *oval = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(symbolOrigin.x, symbolOrigin.y, symbolSize.width, symbolSize.height)
                          cornerRadius:symbolSize.width/2];
    return oval;
}

- (UIBezierPath *)drawDiamond:(CGSize)symbolSize symbolOrigin:(CGPoint)symbolOrigin {    
    UIBezierPath *diamond = [[UIBezierPath alloc] init];
    CGPoint centredSymbolOrigin = CGPointMake(symbolOrigin.x + (symbolSize.width/2), symbolOrigin.y);
    [diamond moveToPoint:centredSymbolOrigin];
    [diamond addLineToPoint:CGPointMake(centredSymbolOrigin.x + symbolSize.width/2, centredSymbolOrigin.y + symbolSize.height/2)];
    [diamond addLineToPoint:CGPointMake(centredSymbolOrigin.x , centredSymbolOrigin.y + symbolSize.height)];
    [diamond addLineToPoint:CGPointMake(centredSymbolOrigin.x - symbolSize.width/2, centredSymbolOrigin.y + symbolSize.height/2)];
    [diamond closePath];
    
    return diamond;
}

- (UIBezierPath *)drawSquiggle:(CGSize)symbolSize symbolOrigin:(CGPoint)symbolOrigin {
    UIBezierPath *squiggle = [[UIBezierPath alloc] init];
    [squiggle moveToPoint:CGPointMake(symbolOrigin.x, symbolOrigin.y)];
    [squiggle addQuadCurveToPoint:CGPointMake(symbolOrigin.x + (symbolSize.width/5)*4, symbolOrigin.y + symbolSize.height/3)
                controlPoint:CGPointMake(symbolOrigin.x + symbolSize.width, symbolOrigin.y)];
    [squiggle addQuadCurveToPoint:CGPointMake(symbolOrigin.x + symbolSize.width, symbolOrigin.y + symbolSize.height)
                     controlPoint:CGPointMake(symbolOrigin.x + (symbolSize.width/5)*2, symbolOrigin.y + (symbolSize.height/5)*4)];
    
    [squiggle moveToPoint:CGPointMake(symbolOrigin.x, symbolOrigin.y)];
    [squiggle addQuadCurveToPoint:CGPointMake(symbolOrigin.x + (symbolSize.width/5), symbolOrigin.y + (symbolSize.height/3)*2)
                     controlPoint:CGPointMake(symbolOrigin.x + (symbolSize.width/5)*3, symbolOrigin.y + symbolSize.height/5)];
    [squiggle addQuadCurveToPoint:CGPointMake(symbolOrigin.x + symbolSize.width, symbolOrigin.y + symbolSize.height)
                     controlPoint:CGPointMake(symbolOrigin.x, symbolOrigin.y + symbolSize.height)];
    
    [squiggle moveToPoint:CGPointMake(symbolSize.width, symbolSize.height)];
    [squiggle closePath];
    
    return squiggle;
}

#define SHADING_SPACING 0.7
- (void) shadeSymbol:(UIBezierPath *)symbol {
    if ([self.shading isEqualToString:@"solid"]) {
        [symbol fill];
    }
    if ([self.shading isEqualToString:@"striped"]) {
        [self pushContext];
        CGPoint symbolOrigin = symbol.bounds.origin;
        CGSize symbolSize = symbol.bounds.size;
        UIBezierPath *shadinglines = [[UIBezierPath alloc] init];
        [shadinglines setLineWidth:SYMBOL_LINE_WIDTH/6.0];
        [shadinglines moveToPoint:symbolOrigin];
        for (int i = 0; i < lround(symbolSize.height/SHADING_SPACING); i++) {
            CGPoint lineStartPoint = CGPointMake(symbolOrigin.x, symbolOrigin.y + (i*SHADING_SPACING));
            CGPoint lineEndPoint = CGPointMake(symbolOrigin.x + symbolSize.width, symbolOrigin.y + (i*SHADING_SPACING));
            if (i % lround(SHADING_SPACING*10.0) == 0) {
                [shadinglines moveToPoint:lineStartPoint];
                [shadinglines addLineToPoint:lineEndPoint];
            }
        }
        [symbol stroke];
        [shadinglines stroke];
        [self popContext];
    }
    if ([self.shading isEqualToString:@"open"]) {
        [symbol stroke];
    }
}

- (void)drawSetCardSymbol {
    if ([self.color isEqualToString:@"red"]) {
        [[UIColor redColor] setFill];
        [[UIColor redColor] setStroke];
    }
    if ([self.color isEqualToString:@"green"]) {
        [[UIColor greenColor] setFill];
        [[UIColor greenColor] setStroke];
    }
    if ([self.color isEqualToString:@"purple"]) {
        [[UIColor purpleColor] setFill];
        [[UIColor purpleColor] setStroke];
    }

    CGSize symbolSize = CGSizeMake(self.bounds.size.width/SYMBOL_SIZE_FACTOR, self.bounds.size.height/(SYMBOL_SIZE_FACTOR/2));
    NSMutableArray *symbolOrigins = [[NSMutableArray alloc] init];
    
    for (int symbolIdx = 0; symbolIdx < self.number; symbolIdx++) {
        if ((self.number == 1 || self.number == 3)) {
            CGPoint symbolOrigin = [self calculateSymbolOrigin:symbolSize hOffset:0.0];
            [symbolOrigins insertObject:NSStringFromCGPoint(symbolOrigin) atIndex:symbolIdx];
        }
        if (self.number > 1) {
            CGPoint symbolOrigin1 = [self calculateSymbolOrigin:symbolSize hOffset:SHAPE_H_OFFSET];
            CGPoint symbolOrigin2 = [self calculateSymbolOrigin:symbolSize hOffset:-SHAPE_H_OFFSET];
            [symbolOrigins insertObject:NSStringFromCGPoint(symbolOrigin1) atIndex:symbolIdx];
            [symbolOrigins insertObject:NSStringFromCGPoint(symbolOrigin2) atIndex:symbolIdx];
        }
    }
    
    for (NSString *origin in symbolOrigins) {
        [self pushContext];
        UIBezierPath *symbol = [[UIBezierPath alloc] init];
        if ([self.symbol isEqualToString:@"oval"]) {
            symbol = [self drawOval:symbolSize symbolOrigin:CGPointFromString(origin)];
        }
        if ([self.symbol isEqualToString:@"diamond"]) {
            symbol = [self drawDiamond:symbolSize symbolOrigin:CGPointFromString(origin)];
        }
        if ([self.symbol isEqualToString:@"squiggle"]) {
            symbol = [self drawSquiggle:symbolSize symbolOrigin:CGPointFromString(origin)];
        }
        [symbol setLineWidth:SYMBOL_LINE_WIDTH];
        [symbol addClip];
        [self shadeSymbol:symbol];

        [self popContext];
    }
}

@end
