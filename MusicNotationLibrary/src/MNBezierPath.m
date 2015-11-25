//
//  MNBezierPath.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15.
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "MNBezierPath.h"
#import "MNUtils.h"
#import "NSBezierPath+MNAdditions.h"

#if TARGET_OS_IPHONE

@implementation  MNBezierPath
- (void)addArcWithCenter:(CGPoint)center
                  radius:(CGFloat)radius
              startAngle:(CGFloat)startAngle
                endAngle:(CGFloat)endAngle
               clockwise:(BOOL)clockwise
{
}
+ (MNBezierPath*)bezierPathWithArcCenter:(CGPoint)center
                                  radius:(CGFloat)radius
                              startAngle:(CGFloat)startAngle
                                endAngle:(CGFloat)endAngle
                               clockwise:(BOOL)clockwise
{
    return nil;
}
- (void)addLineToPoint:(CGPoint)point
{
    [self addLineToPoint:point];
}
+ (MNBezierPath*)bezierPath
{
    return (MNBezierPath*)[UIBezierPath bezierPath];
}
+ (MNBezierPath*)bezierPathWithRect:(CGRect)rect
{
    return (MNBezierPath*)[UIBezierPath bezierPathWithRect:rect];
}
- (void)addQuadCurveToPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint
{
    [self addQuadCurveToPoint:endPoint controlPoint:controlPoint];
}
- (void)addCurveToPoint:(CGPoint)endPoint controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2
{
    [self addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
}
@end

#elif TARGET_OS_MAC

@implementation MNBezierPath

// https://github.com/iccir/XUIKit/blob/master/Source/XUIBezierPathAdditions.m

- (void)addArcWithCenter:(CGPoint)center
                  radius:(CGFloat)radius
              startAngle:(CGFloat)startAngle
                endAngle:(CGFloat)endAngle
               clockwise:(BOOL)clockwise
{
    [self appendBezierPathWithArcWithCenter:center
                                     radius:radius
                                 startAngle:startAngle
                                   endAngle:endAngle
                                  clockwise:clockwise];
}

+ (MNBezierPath*)bezierPathWithArcCenter:(CGPoint)center
                                  radius:(CGFloat)radius
                              startAngle:(CGFloat)startAngle
                                endAngle:(CGFloat)endAngle
                               clockwise:(BOOL)clockwise
{
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path appendBezierPathWithArcWithCenter:center
                                     radius:radius
                                 startAngle:startAngle
                                   endAngle:endAngle
                                  clockwise:clockwise];
    return (MNBezierPath*)path;
}

- (void)addLineToPoint:(CGPoint)point
{
    [self lineToPoint:point];
}

+ (MNBezierPath*)bezierPath
{
    return [[MNBezierPath alloc] init];
}

+ (MNBezierPath*)bezierPathWithRect:(NSRect)rect
{
    return (MNBezierPath*)[NSBezierPath bezierPathWithRect:rect];
}

- (void)addQuadCurveToPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint
{
    CGPoint QP0 = [self currentPoint];
    CGPoint QP2 = endPoint;
    CGPoint CP3 = QP2;
    CGPoint QP1 = controlPoint;

    CGPoint CP1 = CGPointMake(
        //  QP0   +   2   / 3    * (QP1   - QP0  )
        QP0.x + ((2.0 / 3.0) * (QP1.x - QP0.x)), QP0.y + ((2.0 / 3.0) * (QP1.y - QP0.y)));

    CGPoint CP2 = CGPointMake(
        //  QP2   +  2   / 3    * (QP1   - QP2)
        QP2.x + (2.0 / 3.0) * (QP1.x - QP2.x), QP2.y + (2.0 / 3.0) * (QP1.y - QP2.y));

    [self curveToPoint:CP3 controlPoint1:CP1 controlPoint2:CP2];
}

- (void)addCurveToPoint:(CGPoint)endPoint controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2
{
    [self curveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
}
@end
#endif