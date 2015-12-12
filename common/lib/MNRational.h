//
//  MNRational.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  author zz85
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

#import <Foundation/Foundation.h>

/*!
 *  The `MNrational` class performs rationalal operations on a numerator and a denominator. It
 *  is useful for representing logic that involves rationals as opposed to floating point operations.
 */
@interface MNRational : NSObject
{
   @private
    NSUInteger _multiplier;
    NSUInteger _numerator;
    NSUInteger _denominator;
    BOOL _positive;
}

//@property (assign, nonatomic) NSUInteger multiplier;
- (NSUInteger)multiplier;
- (nonnull id)setMultiplier:(NSUInteger)multiplier;
//@property (assign, nonatomic) NSUInteger numerator;
- (NSUInteger)numerator;
- (nonnull id)setNumerator:(NSUInteger)numerator;
//@property (assign, nonatomic) NSUInteger denominator;
- (NSUInteger)denominator;
- (nonnull id)setDenominator:(NSUInteger)denominator;
//@property (readonly, nonatomic) BOOL positive;
- (BOOL)positive;
- (nonnull id)setPositive:(BOOL)positive;

@property (readonly, nonatomic) float floatValue;
@property (strong, nonatomic, readonly) NSString* _Nonnull simplifiedString;
@property (strong, nonatomic, readonly) NSString* _Nonnull mixedString;

- (nonnull instancetype)initWithNumerator:(NSUInteger)numerator andDenominator:(NSUInteger)denominator;
+ (nonnull MNRational*)rationalWithNumerator:(NSUInteger)numerator andDenominator:(NSUInteger)denominator;
+ (nonnull MNRational*)rationalWithNumerator:(NSUInteger)numerator;
+ (nonnull MNRational*)rationalWithRational:(nonnull MNRational*)otherrational;
+ (nonnull MNRational*)zero;
+ (nonnull MNRational*)one;

#pragma mark - Methods

- (nonnull id)copy;
- (nonnull MNRational*)clone;
- (float)floatValue;
- (BOOL)boolValue;
- (nonnull NSNumber*)numberValue;

#pragma mark String

- (nonnull NSString*)description;
//- (nonnull NSString*)toString;
//- (NSString*)simplifiedString;
//- (NSString*)mixedString;
- (NSUInteger)hash;
//- (nonnull id)set:(NSUInteger)numerator with:(NSUInteger)denominator;
+ (nonnull MNRational*)simplify:(nonnull MNRational*)rational;
- (nonnull MNRational*)simplify;

#pragma mark Math Operations

//+ (nonnull MNRational*)add:(nonnull MNRational*)param1 with:(nonnull MNRational*)param2;
- (nonnull MNRational*)add:(nonnull MNRational*)other;
- (nonnull MNRational*)addValue:(NSUInteger)value;
//+ (nonnull MNRational*)subtract:(nonnull MNRational*)param1 with:(nonnull MNRational*)param2;
- (nonnull MNRational*)subtract:(nonnull MNRational*)other;
- (nonnull MNRational*)subtractValue:(NSUInteger)value;
//+ (nonnull MNRational*)multiply:(nonnull MNRational*)param1 with:(nonnull MNRational*)param2;
- (nonnull MNRational*)multiply:(nonnull MNRational*)other;
- (nonnull MNRational*)multiplyByValue:(NSUInteger)value;
//- (nonnull MNRational*)mult:(NSUInteger)value;
//+ (nonnull MNRational*)divide:(nonnull MNRational*)param1 with:(nonnull MNRational*)param2;
- (nonnull MNRational*)divide:(nonnull MNRational*)other;
- (nonnull MNRational*)divideByValue:(NSUInteger)value;
- (nonnull MNRational*)invert;

- (BOOL)equals:(nonnull MNRational*)other;
//+ (BOOL)equals:(nonnull MNRational*)r1 with:(nonnull MNRational*)r2;
- (BOOL)notEquals:(nonnull MNRational*)other;
- (BOOL)equalsFloat:(float)f;
- (BOOL)equalsFloat:(float)f withAccuracy:(float)accuracy;
// static BOOL equalsWithAccuracy(float a, float b, float accuracy);
- (BOOL)lessThan:(nonnull MNRational*)other;
- (BOOL)greaterThan:(nonnull MNRational*)other;
- (BOOL)lessThanOrEquael:(nonnull MNRational*)other;
- (BOOL)greaterThanOrEqual:(nonnull MNRational*)other;
- (BOOL)isZero;
- (NSUInteger)quotient;
- (NSUInteger)fraction;
- (nonnull MNRational*)abs;
+ (nonnull MNRational*)parse:(nonnull NSString*)numString;
NSUInteger gcd(NSUInteger param1, NSUInteger param2);
NSUInteger lcm(NSUInteger param1, NSUInteger param2);
+ (NSUInteger)lcmm:(NSUInteger)params, ...;

@end
