//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2014 hamcrest.org. See LICENSE.txt

    // Class under test
#define HC_SHORTHAND
#import "HCIsAnything.h"

    // Test support
#import "AbstractMatcherTest.h"


@interface IsAnythingTest : AbstractMatcherTest
@end

@implementation IsAnythingTest

- (void)testCopesWithNilsAndUnknownTypes
{
    id matcher = anything();

    assertNilSafe(matcher);
    assertUnknownTypeSafe(matcher);
}

- (void)testAlwaysEvaluatesToTrue
{
    assertMatches(@"nil", anything(), nil);
    assertMatches(@"object", anything(), [[NSObject alloc] init]);
    assertMatches(@"string", anything(), @"hi");
}

- (void)testHasUsefulDefaultDescription
{
    assertDescription(@"ANYTHING", anything());
}

- (void)testCanOverrideDescription
{
    NSString *description = @"DESCRIPTION";
    assertDescription(description, anythingWithDescription(description));
}

- (void)testMatchAlwaysSucceedsSoShouldNotGenerateMismatchDescription
{
    assertNoMismatchDescription(anything(), @"hi");
}

@end
