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
//#import "MNMacros.h"
//#import "MNLog.h"

typedef NSUInteger (^Operation)(NSUInteger operand1, NSUInteger operand2);

@implementation MNRational

- (instancetype)initWithNumerator:(NSUInteger)numerator andDenominator:(NSUInteger)denominator
{
    self = [super init];
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

+ (nonnull MNRational*)rationalWithNumerator:(NSUInteger)numerator andDenominator:(NSUInteger)denominator
{
    MNRational* ret = [[MNRational alloc] initWithNumerator:numerator andDenominator:denominator];
    //    [ret simplify];
    return ret;
}

+ (nonnull MNRational*)rationalWithNumerator:(NSUInteger)numerator
{
    MNRational* ret = [[MNRational alloc] initWithNumerator:numerator andDenominator:1];
    return ret;
}

+ (nonnull MNRational*)rationalWithRational:(nonnull MNRational*)otherrational
{
    MNRational* ret =
        [[MNRational alloc] initWithNumerator:otherrational.numerator andDenominator:otherrational.denominator];
    [ret simplify];
    return ret;
}

+ (nonnull MNRational*)zero
{
    return [[MNRational alloc] initWithNumerator:0 andDenominator:1];
}

+ (nonnull MNRational*)one
{
    return [[MNRational alloc] initWithNumerator:1 andDenominator:1];
}

#pragma mark - Properties

- (NSUInteger)multiplier
{
    return _multiplier;
}

- (nonnull id)setMultiplier:(NSUInteger)multiplier
{
    _multiplier = multiplier;
    return self;
}

- (NSUInteger)numerator
{
    return _numerator;
}

- (nonnull id)setNumerator:(NSUInteger)numerator
{
    _positive = ((numerator > 0) != (_numerator > 0)) ? (!_positive) : (_positive);
    if(numerator == 0)
    {
        _positive = YES;
    }
    _numerator = ABS(numerator);
    return self;
}

- (NSUInteger)denominator
{
    return _denominator;
}

- (nonnull id)setDenominator:(NSUInteger)denominator
{
    self.positive = ((denominator > 0) != (_denominator > 0)) ? (!self.positive) : (self.positive);
    _denominator = ABS(denominator);
    _denominator = _denominator != 0 ? _denominator : 1;
    return self;
}

- (BOOL)positive
{
    return _positive;
}

- (nonnull id)setPositive:(BOOL)positive
{
    _positive = positive;
    return self;
}

- (nonnull id)setWith:(nonnull MNRational*)other
{
    [self setNumerator:[other numerator]];
    [self setDenominator:[other denominator]];
    [self setPositive:[other positive]];
    [self setMultiplier:[other multiplier]];
    return self;
}

- (id)setNum:(NSUInteger)numerator andDen:(NSUInteger)denominator
{
    self.numerator = numerator;
    self.denominator = denominator;
    return self;
}

#pragma mark - Methods

- (id)copy
{
    MNRational* ret = [MNRational one];
    ret.numerator = self.numerator;
    ret.denominator = self.denominator;
    ret.positive = self.positive;
    return ret;
}

- (nonnull MNRational*)clone
{
    MNRational* ret = [MNRational one];
    ret.numerator = self.numerator;
    ret.denominator = self.denominator;
    ret.positive = self.positive;
    return ret;
}

- (float)floatValue
{
    float numFloat = self.numerator;
    float denFloat = self.denominator;
    float ret = ((float)numFloat) / ((float)denFloat);
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
    return [self simplifiedString];
}

- (NSString*)toString
{
    return self.description;
}

- (NSString*)simplifiedString
{
    MNRational* tmp = [[self copy] simplify];
    NSString* bit = tmp.positive ? @"+" : @"-";
    if(tmp.numerator == 0)
    {
        bit = @"";
    }
    return [NSString stringWithFormat:@"%@ %tu / %tu", bit, tmp.numerator, tmp.denominator];
}

- (NSString*)getMixedString
{
    NSUInteger t = 0;
    NSMutableString* ret = [[NSMutableString alloc] init];
    [ret appendFormat:@""];
    NSUInteger q = [self quotient];
    MNRational* f = [self clone];
    [ret appendFormat:@" %ti", [f quotient]];
    //    if(q < 0)
    //    {
    //        t = [[f abs] fraction];
    //    }
    //    else
    //    {
    t = [f fraction];
    //    }
    MNRational* u = [[MNRational alloc] init];
    u.denominator = [f denominator];
    u.numerator = t;
    if(q != 0)
    {
        if(f.numerator != 0)
        {
            [ret appendFormat:@" and %@", [u simplifiedString]];
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
            return [f simplifiedString];
        }
    }
    return ret;
}

- (NSUInteger)hash
{
    return self.numerator << 16 | self.denominator;
}

+ (nonnull MNRational*)simplify:(nonnull MNRational*)rational
{
    return [rational simplify];
}

- (nonnull MNRational*)simplify
{
    NSUInteger u = self.numerator * (self.positive ? 1 : -1);
    NSUInteger d = self.denominator;
    NSUInteger _gcd = gcd(u, d);   //[MNRational gcd:u right:d];
    u /= _gcd;
    d /= _gcd;

    //    if (d < 0) {
    //        d = -d;
    //        u = -u;
    //    }

    BOOL posTmp = self.positive;
    [self setNum:u andDen:d];   // set:u with:d];
    self.positive = posTmp;
    return self;
}

#pragma mark Math Operations

+ (nonnull MNRational*)expressionOperation:(Operation)operation
                                      left:(nonnull MNRational*)param1
                                     right:(nonnull MNRational*)param2
{
    MNRational *p1, *p2;
    p1 = [param1 copy];   // simplify];
    p2 = [param2 copy];   // simplify];
                          //    p1 = [[param1 copy]simplify];
                          //    p2 = [[param2 copy]simplify];

    NSUInteger _lcm = lcm(p1.denominator, p2.denominator);
    NSUInteger denominator1 = p1.denominator != 0 ? p1.denominator : 1;
    NSUInteger denominator2 = p2.denominator != 0 ? p2.denominator : 1;
    NSUInteger a = _lcm / denominator1;
    NSUInteger b = _lcm / denominator2;
    NSUInteger u = operation(p1.numerator * a, p2.numerator * b);

    return [[MNRational alloc] initWithNumerator:u andDenominator:_lcm];
}

+ (nonnull MNRational*)termOperation:(Operation)operation
                                left:(nonnull MNRational*)param1
                               right:(nonnull MNRational*)param2
{
    MNRational* ret = [[MNRational alloc] initWithNumerator:1 andDenominator:1];
    [ret setNumerator:(param1.numerator * param2.numerator)];
    [ret setDenominator:(param1.denominator * param2.denominator)];
    //    [ret simplify]; // NOTE: do not simplify
    return ret;
}

+ (nonnull MNRational*)add:(nonnull MNRational*)param1 right:(nonnull MNRational*)param2
{
    return [MNRational expressionOperation:^(NSUInteger a, NSUInteger b) {
      return a + b;
    } left:param1 right:param2];
}

- (nonnull MNRational*)add:(nonnull MNRational*)other
{
    MNRational* tmpRat = [[self class] expressionOperation:^(NSUInteger a, NSUInteger b) {
      return a + b;
    } left:self right:other];
    self.multiplier = tmpRat.multiplier;
    self.numerator = tmpRat.numerator;
    self.denominator = tmpRat.denominator;
    self.positive = tmpRat.positive;
    return self;
}

- (nonnull MNRational*)addValue:(NSUInteger)value
{
    return [[self class] termOperation:^(NSUInteger a, NSUInteger b) {
      return a + b;
    } left:self right:[MNRational rationalWithNumerator:value]];
}

+ (nonnull MNRational*)subtract:(nonnull MNRational*)param1 right:(nonnull MNRational*)param2
{
    return [[self class] expressionOperation:^(NSUInteger a, NSUInteger b) {
      return a - b;
    } left:param1 right:param2];
}

- (nonnull MNRational*)subtract:(nonnull MNRational*)other
{
    return [[self class] expressionOperation:^(NSUInteger a, NSUInteger b) {
      return a - b;
    } left:self right:other];
}

- (nonnull MNRational*)subtractValue:(NSUInteger)value
{
    return [[self class] termOperation:^(NSUInteger a, NSUInteger b) {
      return a - b;
    } left:self right:[MNRational rationalWithNumerator:value]];
}

+ (nonnull MNRational*)multiply:(nonnull MNRational*)param1 right:(nonnull MNRational*)param2
{
    MNRational* a = [param1 copy];
    MNRational* b = [param2 copy];
    return [a multiply:b];
}

- (nonnull MNRational*)multiply:(nonnull MNRational*)other
{
    MNRational* result = [[self class] termOperation:^(NSUInteger a, NSUInteger b) {
      return a * b;
    } left:self right:other];

    [self setWith:result];

    return self;
}

- (nonnull MNRational*)multiplyByValue:(NSUInteger)value
{
    return [[self class] termOperation:^(NSUInteger a, NSUInteger b) {
      return a * b;
    } left:self right:[MNRational rationalWithNumerator:value]];
}

+ (nonnull MNRational*)divide:(nonnull MNRational*)param1 right:(nonnull MNRational*)param2
{
    return [[self class] termOperation:^(NSUInteger a, NSUInteger b) {
      return a / b;
    } left:param1 right:param2];
}

- (nonnull MNRational*)divide:(nonnull MNRational*)other
{
    return [[self class] termOperation:^(NSUInteger a, NSUInteger b) {
      return a / b;
    } left:self right:[[other clone] invert]];
}

- (nonnull MNRational*)invert
{
    if(self.numerator == 0)
    {
        //  MNLogError(@"DivisionByZeroException");
        NSLog(@"DivisionByZeroException");
        self.denominator = 0;
        self.numerator = NSUIntegerMax;
        //  abort();
    }
    NSUInteger tmp = self.numerator;
    self.numerator = self.denominator;
    self.denominator = tmp;
    return self;
}

- (nonnull MNRational*)divideByValue:(NSUInteger)value
{
    if(value == 0)
    {
        //  MNLogError(@"DivisionByZeroException");
        NSLog(@"DivisionByZeroException");
        return [MNRational rationalWithNumerator:NSUIntegerMax andDenominator:1];
        //  abort();
    }

    return [[self class] termOperation:^(NSUInteger a, NSUInteger b) {
      // TODO: termOperation does NOTHING!!!
      return b / a;
    } left:self right:[MNRational rationalWithNumerator:1 andDenominator:value]];
}

//- (nonnull MNRational*)divn:(NSUInteger)value
//{
//    return [self divideByValue:value];
//}

- (BOOL)equals:(nonnull MNRational*)other
{
    MNRational *a, *b;
    a = [[self copy] simplify];
    b = [[other copy] simplify];

    return a.numerator == b.numerator && a.denominator == b.denominator && a.positive == b.positive;
}

+ (BOOL)equals:(nonnull MNRational*)r1 right:(nonnull MNRational*)r2
{
    return [r1 equals:r2];
}

- (BOOL)notEquals:(nonnull MNRational*)other
{
    return ![self equals:other];
}

- (BOOL)equalsFloat:(float)f
{
    return [self equalsFloat:f withAccuracy:0.0f];
}

- (BOOL)equalsFloat:(float)f withAccuracy:(float)accuracy
{
    return equalsWithAccuracy([self floatValue], f, accuracy);
}

static BOOL equalsWithAccuracy(float a, float b, float accuracy)
{
    if(fabsf(a - b) <= accuracy)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)lessThan:(nonnull MNRational*)other
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

- (BOOL)greaterThan:(nonnull MNRational*)other
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

- (BOOL)lessThanOrEquael:(nonnull MNRational*)other
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

- (BOOL)greaterThanOrEqual:(nonnull MNRational*)other
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

- (BOOL)isZero
{
    return self.numerator == 0;
}

- (NSUInteger)quotient
{
    return (NSUInteger)floorf(self.numerator / self.denominator);
}

- (NSUInteger)fraction
{
    return self.numerator % self.denominator;
}

- (nonnull MNRational*)abs
{
    self.positive = YES;
    return self;
}

+ (nonnull MNRational*)parse:(NSString*)numString
{
    MNRational* ret;
    @try
    {
        NSArray* i = [numString componentsSeparatedByString:@"/"];
        NSUInteger n = [i[0] integerValue];
        NSUInteger d = 0;
        if(i.count > 1)
        {
            d = [i[1] integerValue];
        }
        d = d ? d : 1;   // avoid divide by zero NaN
        ret = [MNRational rationalWithNumerator:n andDenominator:d];
    }
    @catch(NSException* exception)
    {
        NSLog(@"ParserationalError, can't parse a rational from given string: %@.", numString);
        ret = nil;
        ;
    }
    @finally
    {
        return ret;
    }
}

NSUInteger gcd(NSUInteger param1, NSUInteger param2)
{
    NSUInteger a, b, t;
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

NSUInteger lcm(NSUInteger param1, NSUInteger param2)
{
    NSUInteger a, b, ret;
    a = param1;
    b = param2;
    ret = (a * b) / gcd(a, b);
    return ret;
}

+ (NSUInteger)lcmm:(NSUInteger)params, ...
{
    va_list args;
    NSUInteger ret = 0;
    NSUInteger n;
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    va_start(args, params);
    while(1)
    {
        n = va_arg(args, int);
        [arr addObject:[NSNumber numberWithInteger:n]];
    }
    va_end(args);
    NSUInteger prev = params;
    NSUInteger curr = prev;
    for(NSUInteger i = 1; i < [arr count] - 1; ++i)
    {
        curr = [[arr objectAtIndex:i] integerValue];
        // prev = [MNRational LCM:prev right:curr];
        prev = lcm(prev, curr);
    }
    ret = curr;
    return ret;
}

@end
