//
//  TitleBGView.m
//  ScrollView
//
//  Created by vivo on 16/5/25.
//  Copyright © 2016年 vivo. All rights reserved.
//

#import "TitleBGView.h"

@implementation TitleBGView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat x = rect.origin.x+2;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width-4;
    CGFloat height = rect.size.height;
    CGFloat linewidth = 1.0f;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(x+height/2.0, y+height)];
    [path addArcWithCenter:CGPointMake(x+height/2.0, y+height/2.0) radius:height/2.0 startAngle:M_PI*0.5 endAngle:M_PI*1.5 clockwise:YES];
    [path addLineToPoint:CGPointMake(x+width-height/2.0, y)];
    [path addArcWithCenter:CGPointMake(x+width-height/2.0, y+height/2.0) radius:height/2.0 startAngle:M_PI*1.5 endAngle:M_PI*0.5 clockwise:YES];
    [path addLineToPoint:CGPointMake(x+height/2, y+height)];
    
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetFillColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    CGContextFillPath(ctx);
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(ctx, linewidth);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextStrokePath(ctx);

    
}

-(void) setFrame:(CGRect)frame{
    [super setFrame: frame];
    [self setNeedsDisplay];
}

@end
