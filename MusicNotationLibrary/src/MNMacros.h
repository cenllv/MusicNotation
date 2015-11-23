//
//  MNMacros.h
//  MusicNotation
//
//  Created by Scott on 3/26/15.
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

#ifndef MusicNotation_MNMacros_h
#define MusicNotation_MNMacros_h

#define MNBoundingBoxMake(x, y, w, h) [MNBoundingBox boundingBoxWithRect:CGRectMake(x, y, w, h)]

#define  MNRectMake(x, y, w, h)  [MNRect boundingBoxAtX:x atY:y withWidth:w andHeight:h]

#define MNPointMake(x, y) [MNPoint pointWithX:x andY:y]

// pad all 4 directions with same padding
#define  MNPaddingMake(padding)  [MNPadding paddingWith:padding]

#define MNFloatSizeMake(x, y) [MNFloatSize sizeWithWidth:x andHeight:y]

#define MNUIntSizeMake(x, y) [MNUIntSize sizeWithWidth:x andHeight:y]
#define MNUIntSizeZero() [MNUIntSize sizeWithWidth:0 andHeight:0]

#define RationalParse(s) [MNRational parse:s]

#define Rational(p, q) [MNRational rationalWithNumerator:p andDenominator:q]

#define Rational1(p) Rational(p, 1)

#define RationalZero() Rational(0, 1)

#define RationalOne() Rational(1, 1)

#define kDrawUsingMNKit YES

#define expect(fmt, ...) DDLogVerbose((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define MNLogInfo(fmt, ...) DDLogInfo((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define MNLogDebug(fmt, ...) DDLogDebug((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define MNLogWarn(fmt, ...) DDLogWarn((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define MNLogError(fmt, ...) DDLogError((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define MNLogVerbose(fmt, ...) DDLogVerbose((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

//
//#if !defined(MAX_CGFLOAT)
//#define MAX(A,B)	({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); __a < __b ? __b : __a; })
//#endif
//
//

#define STAFF_LINE_GAP 10.0f
#define STAFF_STANDARD_WIDTH 569.0f

#define SHEET_MUSIC_COLOR [NSColor colorWithRed:0.93f green:0.93f blue:0.87f alpha:1.0f]

#define TF(BOOL_VAL) (BOOL_VAL ? @"YES" : @"NO")

//#define ok(msg) \
//    assertThatBool(YES, describedAs(msg, isTrue(), nil));

#define mnstring(s, ...) [NSString stringWithFormat:(s), ##__VA_ARGS__ ?: @""]

#define ok(bResult, string) assertThatBool(bResult, describedAs(string, isTrue(), nil));

#if TARGET_OS_IPHONE
#define SHEET_MUSIC_COLOR [UIColor colorWithRed:0.93f green:0.93f blue:0.87f alpha:1.0f]
#elif TARGET_OS_MAC
#define SHEET_MUSIC_COLOR [NSColor colorWithRed:0.93f green:0.93f blue:0.87f alpha:1.0f]
#endif

#if TARGET_OS_IPHONE
#define  MNGraphicsContext() UIGraphicsGetCurrentContext()
#elif TARGET_OS_MAC
#define  MNGraphicsContext() [[NSGraphicsContext currentContext] graphicsPort]
#endif

#if TARGET_OS_IPHONE
#define  MNView UIView
#elif TARGET_OS_MAC
#define  MNView NSView
#endif

#define VariableName(arg) (@"" #arg)

#define CGRectShiftOrigin(rect, newOrigin) CGRectMake(newOrigin.x, newOrigin.y +, rect.size.width, rect.size.height)

#define CGRectShiftOriginByAmount(rect, shiftSize) \
    CGRectMake(rect.origin.x + shiftSize.width, rect.origin.y + shiftSize.height, rect.size.width, rect.size.height)

#define CGScaleRect(rect, scale) \
    CGRectMake(rect.origin.x, rect.origin.y, rect.size.width* scale, rect.size.height* scale)

#define CGScaleSize(size, scale) CGSizeMake(size.width* scale, size.height* scale)

#define CGScalePoint(point, scale) CGPointMake(point.x* scale, point.y* scale)

#define CGInvertPoint(point) CGPointMake(-point.x, -point.y)

#define CGInvertYForPoint(point) CGPointMake(point.x, -point.y)

#define CGInvertXForPoint(point) CGPointMake(-point.x, point.y)

#define CGCombinePoints(point1, point2) CGPointMake(point1.x + point2.x, point1.y + point2.y)

#define CGPositivePoint(point) CGPointMake(ABS(point.x), ABS(point.y))

#define CGOneMinusPoint(point) CGPointMake(1. - point.x, 1. - point.y)

//#define CGClampPoint(point) \
    CGPointMake(ABS(point.x / MAX(ABS(point.x), ABS(point.y))), ABS(point.y / MAX(ABS(point.x), ABS(point.y))))

#define CGClampPoint(point, size) CGPointMake(ABS(point.x / size.width), ABS(point.y / size.height))

#define CGPointSizeCombine(point, size) CGRectMake(point.x, point.y, size.width, size.height)

#define CGRectExpandBySize(rect, size)                                                                        \
    CGRectMake(rect.origin.x + size.width / 2, rect.origin.y + size.height / 2, rect.size.width + size.width, \
               rect.size.height + size.height)

#define CGRectToString(rect)                                                                               \
    [NSString stringWithFormat:@"(%@ x:%.02f y:%.02f w:%.02f h:%.02f)", VariableName(rect), rect.origin.x, \
                               rect.origin.y, rect.size.width, rect.size.height]

// // CGRectUnion
//#define CGMergeRects(rect1, rect2)                                                   \
//    CGRectMake(MIN(CGRectGetMinX(rect1, rect2)), MIN(CGRectGetMinY(rect1, rect2)),   \
//               -MIN(CGRectGetMinX(rect1, rect2)) + MAX(CGRectGetMaxX(rect1, rect2)), \
//               -MIN(CGRectGetMinY(rect1, rect2)) + MAX(CGRectGetMaxY(rect1, rect2)))

#endif
