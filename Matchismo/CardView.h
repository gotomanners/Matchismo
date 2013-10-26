//
//  CardView.h
//  Matchismo
//
//  Created by Manners Oshafi on 17/07/2013.
//  Copyright (c) 2013 Gotomanners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

@property (nonatomic) BOOL faceUp;
@property (nonatomic) BOOL unplayable;
@property (nonatomic) CGFloat faceCardScaleFactor;

- (void)pinch:(UIPinchGestureRecognizer *) gesture;
- (CGContextRef)pushContext;
- (CGContextRef)popContext;

@end
