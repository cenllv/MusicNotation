//
//  RationalTest.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 12/9/15.
//  Copyright © 2015 feedbacksoftware.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MNRational.h"

#define RationalParse(s) [MNRational parse:s]

#define Rational(p, q) [MNRational rationalWithNumerator:p andDenominator:q]

#define Rational1(p) Rational(p, 1)

#define RationalZero() Rational(0, 1)

#define RationalOne() Rational(1, 1)

@interface RationalTest : XCTestCase

@end

@implementation RationalTest

- (void)testBasic
{
    MNRational* r = RationalOne();
    XCTAssertEqualWithAccuracy([r floatValue], 1.f, 0.1f);
    r = Rational(2048, 3);
    XCTAssertEqualWithAccuracy([r floatValue], (2048. / 3.), 0.1f);
    r = [r multiplyByValue:2];
    XCTAssertEqualWithAccuracy([r floatValue], 2 * (2048. / 3.), 0.1f);
}

- (void)testSimplify
{
    MNRational* r = Rational(2048, 2);
    MNRational* q = Rational(1024, 1);
    XCTAssertEqualWithAccuracy([r floatValue], [q floatValue], 0.1f);
    XCTAssertTrue([r equals:q]);
}

- (void)testSetNumeratorDenominator
{
    MNRational* r = Rational(123, 2);
    r.numerator = 12;
    XCTAssertTrue(r.numerator == 12);
    [r simplify];
    XCTAssertTrue(r.numerator == 6);
    XCTAssertTrue(r.denominator == 1);
    
    r = Rational(12, 2);
    [r add:Rational(4, 2)];
    XCTAssertTrue(r.numerator == 16);
    XCTAssertTrue(r.denominator == 2);
}

- (void)testEqualityOperators
{
    MNRational* r = Rational(2048, 2);
    MNRational* q = Rational(1024, 1);
    XCTAssertTrue([r equals:q]);
    
    MNRational* m = Rational(1, 1);
    MNRational* n = Rational(2, 1);
    XCTAssertTrue(![m equals:n]);
}

- (void)testMultDiv
{
    MNRational* r = Rational(2048, 3);
    r = [r multiplyByValue:2];
    XCTAssertEqualWithAccuracy([r floatValue], 2 * (2048. / 3.), 0.1f);
    MNRational *q = Rational(4096, 1);
    q = [q divideByValue:2];
    XCTAssertTrue([q equals:Rational(2048, 1)]);
}

- (void)testAddSub
{
    MNRational* r = Rational(1, 2);
    MNRational* q = Rational(1, 2);
    [[[r add:q] add:q] add:q];
    XCTAssertEqual([r floatValue], [Rational(2, 1) floatValue]);
    
    MNRational* m = Rational(6, 2);
    MNRational* n = Rational(2, 2);
    m = [[m subtract:n] subtract:n];
    XCTAssertTrue([[m description] isEqualToString:[n description]]);
}

- (void)testLCM
{
}

@end
