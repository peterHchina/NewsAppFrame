//
//  IFTTTFilmstrip.h
//  JazzHands
//
//  Created by Laura Skelton on 6/17/15.
//  Copyright (c) 2015 IFTTT Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFTTTEasingFunction.h"
#import "IFTTTInterpolatable.h"
#define RGB(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
@interface IFTTTFilmstrip : NSObject

- (BOOL)isEmpty;
- (void)setValue:(id<IFTTTInterpolatable>)value atTime:(CGFloat)time;
- (void)setValue:(id<IFTTTInterpolatable>)value atTime:(CGFloat)time withEasingFunction:(IFTTTEasingFunction)easingFunction;
- (id<IFTTTInterpolatable>)valueAtTime:(CGFloat)time;
- (id<IFTTTInterpolatable>)reverseValueAtTime:(CGFloat)time;
- (id<IFTTTInterpolatable>)sizeAtTime:(CGFloat)time;
- (id<IFTTTInterpolatable>)reverseSizeAtTime:(CGFloat)time;
- (id<IFTTTInterpolatable>)BoundsFromTime:(CGRect)fromRect toTime:(CGRect)toRect  :(CGFloat)time;
- (id<IFTTTInterpolatable>)reverseBoundsFromTime:(CGRect)fromRect toTime:(CGRect)toRect  :(CGFloat)time;

@end
