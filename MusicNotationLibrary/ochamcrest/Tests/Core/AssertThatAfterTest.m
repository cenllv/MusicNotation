//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2014 hamcrest.org. See LICENSE.txt
//  Contribution by Sergio Padrino

    // Class under test
#define HC_SHORTHAND
#import "HCAssertThat.h"

    // Collaborators
#import "HCIsEqual.h"

    // Test support
#import "SenTestingKit.h"


static NSTimeInterval const TIME_ERROR_MARGIN = 0.1f;

@interface AssertThatAfterTest : SenTestCase
@end

@implementation AssertThatAfterTest

- (void)testShouldBeSilentOnSuccessfulMatchWithTimeoutZero
{
    assertThatAfter(0, futureValueOf(@"foo"), equalTo(@"foo"));
}

- (void)testShouldBeSilentOnSuccessfulMatchWithTimeoutGreaterThanZero
{
    assertThatAfter(5, futureValueOf(@"foo"), equalTo(@"foo"));
}

- (void)testFailsImmediatelyWithTimeoutZero
{
    NSTimeInterval maxTime = 0;
    NSTimeInterval waitTime = [self timeExecutingBlock:^{
        @try
        {
            [self raiseAfterFailure];
            assertThatAfter(maxTime, futureValueOf(@"foo"), equalTo(@"bar"));
        }
        @catch (NSException *exception)
        {
            return;
        }
        STFail(@"should have failed");
    }];

    STAssertEqualsWithAccuracy(waitTime, maxTime, TIME_ERROR_MARGIN,
                            @"Assert should have failed immediately");
}

- (void)testFailsAfterTimeoutGreaterThanZero
{
    NSTimeInterval maxTime = 0.2;
    NSTimeInterval waitTime = [self timeExecutingBlock:^{
        @try
        {
            [self raiseAfterFailure];
            assertThatAfter(maxTime, futureValueOf(@"foo"), equalTo(@"bar"));
        }
        @catch (NSException *exception)
        {
            return;
        }
        STFail(@"should have failed");
    }];

    STAssertEqualsWithAccuracy(waitTime, maxTime, TIME_ERROR_MARGIN,
                            @"Assert should have failed after %f seconds", maxTime);
}

- (void)testAssertWithTimeoutGreaterThanZeroShouldSucceedNotImmediatelyButBeforeTimeout
{
    NSTimeInterval maxTime = 1.0;
    NSTimeInterval succeedTime = 0.2;

    __block NSString *futureBar = @"foo";

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(succeedTime * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        futureBar = @"bar";
    });

    NSTimeInterval waitTime = [self timeExecutingBlock:^{
        @try
        {
            [self raiseAfterFailure];
            assertThatAfter(maxTime, futureValueOf(futureBar), equalTo(@"bar"));
        }
        @catch (NSException *exception)
        {
            STFail(@"should have succeeded");
        }
    }];

    STAssertEqualsWithAccuracy(waitTime, succeedTime, TIME_ERROR_MARGIN,
                            @"Assert should have succeeded in approximately %f seconds", succeedTime);
}

- (NSTimeInterval)timeExecutingBlock:(void (^)())block
{
    NSDate *initialDate = [NSDate date];
    block();
    NSTimeInterval waitTime = -[initialDate timeIntervalSinceNow];
    return waitTime;
}

- (void)testAssertionErrorShouldDescribeExpectedAndActual
{
    NSString *expected = @"EXPECTED";
    NSString *actual = @"ACTUAL";
    NSString *expectedMessage = @"Expected \"EXPECTED\", but was \"ACTUAL\"";
    NSTimeInterval irrelevantMaxTime = 0;

    @try
    {
        [self raiseAfterFailure];
        assertThatAfter(irrelevantMaxTime, futureValueOf(actual), equalTo(expected));
    }
    @catch (NSException* exception)
    {
        STAssertTrue([[exception reason] rangeOfString:expectedMessage].location != NSNotFound, nil);
        return;
    }
    STFail(@"should have failed");
}

@end
