//
//  MNrational.m
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

#import "MNRational.h"
#import "MNMacros.h"
#import "MNLog.h"

#pragma mark -  MNrational Implementation

typedef NSInteger (^Operation)(NSInteger operand1, NSInteger operand2);

//@interface Rational (private)
//@property (assign, nonatomic) NSUInteger multiplier;
//@property (assign, nonatomic) NSUInteger numerator;
//@property (assign, nonatomic) NSUInteger denominator;
//@property (assign, nonatomic) BOOL positive;
//@end

@implementation MNRational

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
    }
    return self;
}

- (instancetype)initWithNumerator:(NSInteger)numerator andDenominator:(NSInteger)denominator
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        _numerator = (NSUInteger)ABS(numerator);
        _denominator = (NSUInteger)ABS(denominator);
        _multiplier = 1;
        _positive = !((numerator > 0) ^ (denominator > 0));

        // disallow NaN
        _denominator = _denominator ? _denominator : 1;
        //        [self simplify];
    }
    return self;
}

+ (MNRational*)rationalWithNumerator:(NSInteger)numerator andDenominator:(NSInteger)denominator
{
    MNRational* ret = [[MNRational alloc] initWithNumerator:numerator andDenominator:denominator];
    //    [ret simplify];
    return ret;
}

+ (MNRational*)rationalWithNumerator:(NSInteger)numerator
{
    MNRational* ret = [[MNRational alloc] initWithNumerator:numerator andDenominator:1];
    return ret;
}

+ (MNRational*)rationalWithRational:(MNRational*)otherrational
{
    MNRational* ret =
        [[MNRational alloc] initWithNumerator:otherrational.numerator andDenominator:otherrational.denominator];
    [ret simplify];
    return ret;
}

+ (MNRational*)rationalZero
{
    return [[MNRational alloc] initWithNumerator:0 andDenominator:1];
}

+ (MNRational*)rationalOne
{
    return [[MNRational alloc] initWithNumerator:1 andDenominator:1];
}

#pragma mark - Properties

- (NSInteger)getNumerator
{
    return _numerator;
}

- (NSInteger)getDenominator
{
    return _denominator;
}

- (void)setNumerator:(NSUInteger)numerator
{
    self.positive = ((numerator > 0) != (_numerator > 0)) ? (!self.positive) : (self.positive);
    if(numerator == 0)
    {
        self.positive = YES;
    }
    _numerator = ABS(numerator);
}

- (void)setDenominator:(NSUInteger)denominator
{
    self.positive = ((denominator > 0) != (_denominator > 0)) ? (!self.positive) : (self.positive);
    _denominator = ABS(denominator);
    _denominator = _denominator != 0 ? _denominator : 1;
}

#pragma mark - Methods

- (MNRational*)clone
{
    MNRational* ret = [MNRational rationalOne];
    ret.numerator = self.numerator;
    ret.denominator = self.denominator;
    ret.positive = self.positive;
    return ret;
}

- (float)floatValue
{
    float numFloat = self.numerator;
    float denFloat = self.denominator;
    float ret = numFloat / denFloat;
    if(!self.positive)
    {
        ret *= -1.0f;
    }
    return ret;
}

- (BOOL)boolValue
{
    return self.floatValue != 0;
}

- (NSNumber*)numberValue
{
    return [NSNumber numberWithFloat:self.floatValue];
}

#pragma mark String

- (NSString*)description
{
    return self.simplifiedString;
}

- (NSString*)toString
{
    return self.description;
}

- (NSString*)getSimplifiedString
{
    [self simplify];
    NSString* bit = self.positive ? @"+" : @"-";
    if(self.numerator == 0)
    {
        bit = @"";
    }
    return [NSString stringWithFormat:@"%@ %ld / %ld", bit, self.numerator, self.denominator];
}

- (NSString*)getMixedString
{
    NSInteger t = 0;
    NSMutableString* ret = [[NSMutableString alloc] init];
    [ret appendFormat:@""];
    NSInteger q = [self quotient];
    MNRational* f = [self clone];
    [ret appendFormat:@" %ld", [f quotient]];   //
    if(q < 0)
    {
        t = [[f abs] rational];
    }
    else
    {
        t = [f rational];
    }
    MNRational* u = [[MNRational alloc] init];
    u.denominator = [f denominator];
    u.numerator = t;
    if(q != 0)
    {
        if(f.numerator != 0)
        {
            [ret appendFormat:@" and %@", u.simplifiedString];   //[u toSimplifiedString]];//and; changed f to u
        }
    }
    else
    {
        if(f.numerator == 0)
        {
            return @"0";
        }
        else
        {
            return f.simplifiedString;   //[f toSimplifiedString];
        }
    }
    //    return [NSString stringWithString:ret];
    return ret;
}

- (NSUInteger)hash
{
    return self.numerator << 16 | self.denominator;
}

- (void)set:(NSInteger)numerator and:(NSInteger)denominator
{
    self.numerator = numerator;
    self.denominator = denominator;
}

+ (MNRational*)simplify:(MNRational*)rational
{
    return [rational simplify];
}

- (MNRational*)simplify
{
    NSInteger u = self.numerator * (self.positive ? 1 : -1);
    NSInteger d = self.denominator;
    NSInteger gcd = [MNRational GCD:u and:d];
    u /= gcd;
    d /= gcd;

    //    if (d < 0) {
    //        d = -d;
    //        u = -u;
    //    }

    BOOL posTmp = self.positive;
    [self set:u and:d];
    self.positive = posTmp;
    return self;
}

#pragma mark Math Operations

+ (MNRational*)performOperation:(Operation)operation on:(MNRational*)param1 and:(MNRational*)param2
{
    if(!param1 || !param2)
    {
        //        MNLogError(@"MNrationalOperationError, can't perform operation with
        //        null params");
    }
    NSUInteger lcm = [MNRational LCM:param1.denominator and:param2.denominator];
    NSUInteger denominator1 = param1.denominator != 0 ? param1.denominator : 1;
    NSUInteger denominator2 = param2.denominator != 0 ? param2.denominator : 1;
    NSUInteger a = lcm / denominator1;
    NSUInteger b = lcm / denominator2;
    NSUInteger u = operation(param1.numerator * a, param2.numerator * b);
    return [[MNRational alloc] initWithNumerator:u andDenominator:lcm];
}

/*
 Vex.Flow.rational.prototype.add = function(param1, param2) {
 var otherNumerator;
 var otherDenominator;

 otherNumerator = 0;
 otherDenominator = param2; //4

 var lcm = Vex.Flow.rational.LCM(self.denominator, otherDenominator); LCM(1, 4) => 1
 var a = lcm / self.denominator; 1 / 1 => 1
 var b = lcm / otherDenominator; 1 / 4 => 1/4

 var u = self.numerator * a + otherNumerator * b;  16384 * 1 +
 return self.set(u, lcm);
 }
 */
/*
 .add = function(b, c) {
 var d;
 if (b instanceof Vex.Flow.rational) {
 d = b.numerator;
 b = b.denominator
 } else {
 d = b !== undefined ? b : 0;
 b = c !== undefined ? c : 1
 }
 c = Vex.Flow.rational.LCM(self.denominator, b);
 return self.set(self.numerator * (c / self.denominator) + d * (c / b), c)
 };
 */

- (MNRational*)performOperation:(Operation)operation on:(MNRational*)param1 and:(MNRational*)param2
{
    if(!param1 || !param2)
    {
        //        MNLogError(@"MNrationalOperationError, can't perform operation with
        //        null params");
    }
    NSUInteger lcm = [MNRational LCM:param1.denominator and:param2.denominator];
    NSUInteger denominator1 = param1.denominator != 0 ? param1.denominator : 1;
    NSUInteger denominator2 = param2.denominator != 0 ? param2.denominator : 1;
    NSUInteger a = lcm / denominator1;
    NSUInteger b = lcm / denominator2;
    NSUInteger u = operation(param1.numerator * a, param2.numerator * b);
    [self set:u and:lcm];
    return self;
}

+ (MNRational*)performOperation2:(Operation)operation on:(MNRational*)param1 and:(MNRational*)param2
{
    if(!param1 || !param2)
    {
        //        MNLogError(@"MNrationalOperationError, can't perform operation with
        //        null params");
    }
    MNRational* ret = [[MNRational alloc] initWithNumerator:1 andDenominator:1];
    [ret set:(param1.numerator * param2.numerator) and:(param1.denominator * param2.denominator)];
    [ret simplify];
    return ret;
}

- (MNRational*)performOperation2:(Operation)operation on:(MNRational*)param1 and:(MNRational*)param2
{
    if(!param1 || !param2)
    {
        //        MNLogError(@"MNrationalOperationError, can't perform operation with
        //        null params");
    }
    [self set:(param1.numerator * param2.numerator) and:(param1.denominator * param2.denominator)];
    return self;   //[self simplify];
}

+ (MNRational*)add:(MNRational*)param1 and:(MNRational*)param2
{
    return [MNRational performOperation:^(NSInteger a, NSInteger b) {
      return a + b;
    } on:param1 and:param2];
}

- (MNRational*)add:(MNRational*)other
{
    return [self performOperation:^(NSInteger a, NSInteger b) {
      return a + b;
    } on:self and:other];
}

- (MNRational*)addByValue:(NSUInteger)value
{
    return [self performOperation2:^(NSInteger a, NSInteger b) {
      return a + b;
    } on:self and:[MNRational rationalWithNumerator:value]];
}

- (MNRational*)addn:(NSUInteger)value
{
    return [self addByValue:value];
}

+ (MNRational*)subtract:(MNRational*)param1 and:(MNRational*)param2
{
    return [MNRational performOperation:^(NSInteger a, NSInteger b) {
      return a - b;
    } on:param1 and:param2];
}

- (MNRational*)subtract:(MNRational*)other
{
    return [self performOperation:^(NSInteger a, NSInteger b) {
      return a - b;
    } on:self and:other];
}

- (MNRational*)subtractByValue:(NSUInteger)value
{
    return [self performOperation2:^(NSInteger a, NSInteger b) {
      return a - b;
    } on:self and:[MNRational rationalWithNumerator:value]];
}

- (MNRational*)subt:(NSUInteger)value
{
    return [self subtractByValue:value];
}

+ (MNRational*)multiply:(MNRational*)param1 and:(MNRational*)param2
{
    return [MNRational performOperation2:^(NSInteger a, NSInteger b) {
      return a * b;
    } on:param1 and:param2];
}

- (MNRational*)multiply:(MNRational*)other
{
    return [self performOperation2:^(NSInteger a, NSInteger b) {
      return a * b;
    } on:self and:other];
}

- (MNRational*)multiplyByValue:(NSUInteger)value
{
    return [self performOperation2:^(NSInteger a, NSInteger b) {
      return a * b;
    } on:self and:[MNRational rationalWithNumerator:value]];
}

- (MNRational*)mult:(NSUInteger)value
{
    return [self multiplyByValue:value];
}

+ (MNRational*)divide:(MNRational*)param1 and:(MNRational*)param2
{
    return [MNRational performOperation2:^(NSInteger a, NSInteger b) {
      return a / b;
    } on:param1 and:param2];
}

- (MNRational*)divide:(MNRational*)other
{
    return [self performOperation2:^(NSInteger a, NSInteger b) {
      return a / b;
    } on:self and:other];
}

- (MNRational*)divideByValue:(NSUInteger)value
{
    return [self performOperation:^(NSInteger a, NSInteger b) {
      if(b == 0)
      {
          MNLogError(@"DivisionByZeroException");
          abort();
      }
      return a / b;
    } on:self and:[MNRational rationalWithNumerator:value]];
}

- (MNRational*)divn:(NSUInteger)value
{
    return [self divideByValue:value];
}

- (BOOL)equalsRational:(MNRational*)other
{
    /*
     // Temporary cached objects
     Vex.Flow.rational.__compareA = new Vex.Flow.rational();
     Vex.Flow.rational.__compareB = new Vex.Flow.rational();
     Vex.Flow.rational.__tmp = new Vex.Flow.rational();

     // Simplifies both sides and checks if they are equal
     Vex.Flow.rational.prototype.equals = function(compare) {
     var a = Vex.Flow.rational.__compareA.copy(compare).simplify();
     var b = Vex.Flow.rational.__compareB.copy(this).simplify();

     return (a.numerator === b.numerator) && (a.denominator === b.denominator);
     }
     */
    [self simplify];
    [other simplify];
    return self.numerator == other.numerator && self.denominator == other.denominator &&
           self.positive == other.positive;
}

- (BOOL)equalsFloat:(float)other
{
    return [self floatValue] == other;
}

+ (BOOL)equalsRational:(MNRational*)rat1 and:(MNRational*)rat2
{
    //    [param1 simplify];
    //    [param2 simplify];
    //    return param1.numerator == param2.numerator &&
    //    param1.denominator == param2.denominator;
    return [rat1 equalsRational:rat2];
}

- (BOOL)notEqualsRational:(MNRational*)other
{
    return ![self equalsRational:other];
}

- (MNRational*)copy:(MNRational*)sender
{
    /*
     // Copies value of another rational into itself
     Vex.Flow.rational.prototype.copy = function(copy) {
     return self.set(copy.numerator, copy.denominator);
     }
     */
    self.numerator = sender.numerator;
    self.denominator = sender.denominator;
    self.positive = sender.positive;
    return self;
}

- (BOOL)lt:(MNRational*)other
{
    if([self floatValue] < [other floatValue])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)gt:(MNRational*)other
{
    if([self floatValue] > [other floatValue])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)lte:(MNRational*)other
{
    if([self floatValue] <= [other floatValue])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)gte:(MNRational*)other
{
    if(self.floatValue >= other.floatValue)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)zero
{
    return self.numerator == 0;
}

- (NSInteger)quotient
{
    return (NSInteger)floorf(self.numerator / self.denominator);
}

- (NSInteger)rational
{
    return self.numerator % self.denominator;
}

- (MNRational*)abs
{
    self.positive = YES;
    return self;
}

+ (MNRational*)parse:(NSString*)numString
{
    MNRational* ret;
    @try
    {
        NSArray* i = [numString componentsSeparatedByString:@"/"];
        NSInteger n = [i[0] integerValue];
        NSInteger d = 0;
        if(i.count > 1)
        {
            d = [i[1] integerValue];
        }
        d = d ? d : 1;   // avoid divide by zero NaN
        ret = [MNRational rationalWithNumerator:n andDenominator:d];
    }
    @catch(NSException* exception)
    {
        NSLog(@"%@", [NSString stringWithFormat:@"ParserationalError, can't parse a rational from given string: %@.",
                                                numString]);
        ret = nil;
        ;
    }
    @finally
    {
        return ret;
    }
}

+ (NSInteger)GCD:(NSInteger)param1 and:(NSInteger)param2
{
    NSInteger a, b, t;
    a = param1;
    b = param2;
    while(b != 0)
    {
        t = b;
        b = a % b;
        a = t;
    }
    return a;
}

+ (NSInteger)LCM:(NSInteger)param1 and:(NSInteger)param2
{
    NSInteger a, b, ret;
    a = param1;
    b = param2;
    ret = ((a * b) / [MNRational GCD:a and:b]);
    return ret;
}

+ (NSInteger)LCMM:(NSInteger)params, ...
{
    va_list args;
    int ret = 0;
    int n;
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    va_start(args, params);
    while(1)
    {
        n = va_arg(args, int);
        [arr addObject:[NSNumber numberWithInteger:n]];
    }
    va_end(args);
    NSInteger prev = params;
    NSInteger curr = prev;
    for(NSUInteger i = 1; i < [arr count] - 1; ++i)
    {
        curr = [[arr objectAtIndex:i] integerValue];
        prev = [MNRational LCM:prev and:curr];
    }
    ret = curr;
    return ret;
}

@end
