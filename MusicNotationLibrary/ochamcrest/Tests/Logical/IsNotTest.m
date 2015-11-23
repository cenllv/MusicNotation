//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2014 hamcrest.org. See LICENSE.txt

    // Class under test
#define HC_SHORTHAND
#import "HCIsNot.h"

    // Collaborators
#import "HCIsEqual.h"
#import "HCHasCount.h"

    // Test support
#import "AbstractMatcherTest.h"
#import "HCIsInstanceOf.h"


@interface IsNotTest : AbstractMatcherTest
@end

@implementation IsNotTest

- (void)testCopesWithNilsAndUnknownTypes
{
    id matcher = isNot(@"irrelevant");

    assertNilSafe(matcher);
    assertUnknownTypeSafe(matcher);
}

- (void)testEvaluatesToTheTheLogicalNegationOfAnotherMatcher
{
    id matcher = isNot(equalTo(@"A"));

    assertMatches(@"invert mismatch", matcher, @"B");
    assertDoesNotMatch(@"invert match", matcher, @"A");
}

- (void)testProvidesConvenientShortcutForNotEqualTo
{
    id matcher = isNot(@"A");

    assertMatches(@"invert mismatch", matcher, @"B");
    assertDoesNotMatch(@"invert match", matcher, @"A");
}

- (void)testUsesDescriptionOfNegatedMatcherWithPrefix
{
    assertDescription(@"not an instance of NSString", isNot(instanceOf([NSString class])));
    assertDescription(@"not \"A\"", isNot(@"A"));
}

- (void)testSuccessfulMatchDoesNotGenerateMismatchDescription
{
    assertNoMismatchDescription(isNot(@"A"), @"B");
}

- (void)testMismatchDescriptionShowsActualArgument
{
    assertMismatchDescription(@"was \"A\"", isNot(@"A"), @"A");
}

- (void)testMismatchDescriptionShowsActualSubMatcherDescription
{
    NSArray *item = @[@"A", @"B"];
    NSString *expected = [NSString stringWithFormat:@"was count of <2> with <%@>", item];
    assertMismatchDescription(expected, isNot(hasCountOf(item.count)), item);
}

- (void)testDescribeMismatch
{
    assertDescribeMismatch(@"was \"A\"", isNot(@"A"), @"A");
}

@end
