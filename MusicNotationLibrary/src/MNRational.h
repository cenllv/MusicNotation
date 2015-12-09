//
//  Rational.h
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

#import "IAModelBase.h"

/*! The `MNrational` class performs rationalal operations on a numerator and a denominator. It
 is useful for representing logic that involves rationals as opposed to floating point operations.
 */
@interface MNRational : IAModelBase
{
   @private
}

#pragma mark - Properties

/*!---------------------------------------------------------------------------------------------------------------------
 * Properties
 *  ---------------------------------------------------------------------------------------
 */

/*! The multiplier is the integer that the numerator and denominator are both multiplied by before a rational has been
 simplified.
 @warning The logic for this property has not yet been implemented.
 */
@property (assign, nonatomic) NSUInteger multiplier;
@property (assign, nonatomic) NSUInteger numerator;
@property (assign, nonatomic) NSUInteger denominator;
@property (assign, nonatomic) BOOL positive;
@property (readonly, nonatomic) float floatValue;
@property (strong, nonatomic, getter=getSimplifiedString) NSString* simplifiedString;
@property (strong, nonatomic, getter=getMixedString) NSString* mixedString;

#pragma mark - Methods


//- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

/*! This is the first super-awesome method.

 You can also add lists, but have to keep an empty line between these blocks.

 - One
 - Two
 - Three

 @param string A parameter that is passed in.
 @return Whatever it returns.
 */
- (instancetype)initWithNumerator:(NSUInteger)numerator andDenominator:(NSUInteger)denominator;

/*! This is the second super-awesome method.
 Note that there are additional cool things here, like [direct hyperlinks](http://www.cocoanetics.com)
 @param number A parameter that is passed in, almost as cool as someMethodWithString:
 @return Whatever it returns.
 @see someMethodWithString:

 @bug *Bug:* A yellow background.
 */
+ (MNRational*)rationalWithNumerator:(NSUInteger)numerator andDenominator:(NSUInteger)denominator;

+ (MNRational*)rationalWithNumerator:(NSUInteger)numerator;

+ (MNRational*)rationalZero;

+ (MNRational*)rationalOne;

+ (MNRational*)rationalWithRational:(MNRational*)otherrational;

- (MNRational*)clone;

/*! Converts the rational numerator and denominator and to a float by performing division.
 @return Returns the float value when division is performed.
 */
- (float)floatValue;

//- (BOOL)valueAsBool;

- (NSNumber*)numberValue;

#pragma mark - String operations
/*!---------------------------------------------------------------------------------------------------------------------
 * @name String operations
 *  ---------------------------------------------------------------------------------------
 */
//
//- (NSString *)toString;
//
//- (NSString *)toSimplifiedString;

/*!
 @warning *Warning:* The following method has not been implemented yet.
 */
//- (NSString *)toMixedString;

#pragma mark - Math operations
/*!---------------------------------------------------------------------------------------------------------------------
 * @name Math operations
 *  ---------------------------------------------------------------------------------------
 */

- (void)set:(NSUInteger)numerator with:(NSUInteger)denominator;

+ (MNRational*)simplify:(MNRational*)rational;

- (MNRational*)simplify;

- (MNRational*)add:(MNRational*)other;

+ (MNRational*)add:(MNRational*)param1 with:(MNRational*)param2;

- (MNRational*)addn:(NSUInteger)value;

- (MNRational*)subtract:(MNRational*)other;

+ (MNRational*)subtract:(MNRational*)param1 with:(MNRational*)param2;

- (MNRational*)subt:(NSUInteger)value;

- (MNRational*)multiply:(MNRational*)other;

+ (MNRational*)multiply:(MNRational*)param1 with:(MNRational*)param2;

/*!
 *  Multiplies this Rational by another Rational
 *
 *  @param value another Rational
 *
 *  @return this Rational
 */
- (MNRational*)mult:(NSUInteger)value;

- (MNRational*)divide:(MNRational*)other;

//+ (MNRational*)divide:(MNRational*)param1 with:(MNRational*)param2;

- (MNRational*)divn:(NSUInteger)value;

#pragma mark - Comparison Operations
/*!---------------------------------------------------------------------------------------------------------------------
 * @name Comparison operations
 *  ---------------------------------------------------------------------------------------
 */

- (BOOL)equalsFloat:(float)other;

//+ (BOOL)equalsRational:(MNRational*)rat1 with:(MNRational*)rat2;

/*! Determines if this rational is equivalent to another rational.
 @param other The other rational to compare this rational to.
 @return The result of the comparison
 */
- (BOOL)equalsRational:(MNRational*)other;
- (BOOL)notEqualsRational:(MNRational*)other;
- (BOOL)lt:(MNRational*)other;

- (BOOL)gt:(MNRational*)other;

- (BOOL)lte:(MNRational*)other;

- (BOOL)gte:(MNRational*)other;

/*! is the numberat of this rational zero? YES or NO
 */
- (BOOL)zero;

/*! Copies values of another rational into itself.
 @param sender The rational to be copied
 @return This rational
 */
- (MNRational*)copy:(MNRational*)sender;

#pragma mark - Math operations
/*!---------------------------------------------------------------------------------------------------------------------
 * @name Algorithmic operations
 *  ---------------------------------------------------------------------------------------
 */

/*! Determines the quotient - the integer resulting from decimal division of the numerator and denominator.
 @return An integer as the quotient
 */
- (NSUInteger)quotient;

/*! Determines the remainder after performing modular division.
 */
- (NSUInteger)rational;

/*! Performs absolute value on the numerator and the denominator.
 @return Returns this rational.
 */
- (MNRational*)abs;

// must be in form @"p/q"
+ (MNRational*)parse:(NSString*)numString;

/*! Determines the greatest common divisor of the two integers.
 @param u An integer
 @param v Another integer
 @return The greatest common divisor
 */
+ (NSUInteger)GCD:(NSUInteger)u with:(NSUInteger)v;

/*! Determines the least common multiple of the two integers.
 @param param1 An integer
 @param param2 Another integer
 @return The least common multiple
 */
+ (NSUInteger)LCM:(NSUInteger)param1 with:(NSUInteger)param2;

/*! Determines the greatest common divisor of many integers.
 @params Two or more integers integers
 @return the least common multiple
 */
+ (NSUInteger)LCMM:(NSUInteger)params, ...;

@end

//// http://stackoverflow.com/a/21371401/629014
//
//#define GET_MACRO(_0, _1, _2, NAME, ...) NAME
//#define FOO(...) GET_MACRO(_0, ##__VA_ARGS__, FOO2, FOO1, FOO0)(__VA_ARGS__)
