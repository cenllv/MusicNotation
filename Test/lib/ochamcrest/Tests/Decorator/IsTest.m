//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2014 hamcrest.org. See LICENSE.txt

    // Class under test
#define HC_SHORTHAND
#import "HCIs.h"

    // Collaborators
#import "HCIsEqual.h"

    // Test support
#import "AbstractMatcherTest.h"
#import "NeverMatch.h"


@interface IsTest : AbstractMatcherTest
@end

@implementation IsTest

- (void)testCopesWithNilsAndUnknownTypes
{
    id matcher = is(@"irrelevant");

    assertNilSafe(matcher);
    assertUnknownTypeSafe(matcher);
}

- (void)testDelegatesMatchingToNestedMatcher
{
    assertMatches(@"should match", is(equalTo(@"A")), @"A");
    assertMatches(@"should match", is(equalTo(@"B")), @"B");
    assertDoesNotMatch(@"should not match", is(equalTo(@"A")), @"B");
    assertDoesNotMatch(@"should not match", is(equalTo(@"B")), @"A");
}

- (void)testDescriptionShouldPassThrough
{
    assertDescription(@"\"A\"", is(equalTo(@"A")));
}

- (void)testProvidesConvenientShortcutForIsEqualTo
{
    assertMatches(@"should match", is(@"A"), @"A");
    assertMatches(@"should match", is(@"B"), @"B");
    assertDoesNotMatch(@"should not match", is(@"A"), @"B");
    assertDoesNotMatch(@"should not match", is(@"B"), @"A");
    assertDescription(@"\"A\"", is(@"A"));
}

- (void)testSuccessfulMatchDoesNotGenerateMismatchDescription
{
    assertNoMismatchDescription(is(@"A"), @"A");
}

- (void)testDelegatesMismatchDescriptionToNestedMatcher
{
    assertMismatchDescription([NeverMatch mismatchDescription],
                              is([NeverMatch neverMatch]),
                              @"hi");
}

- (void)testDelegatesDescribeMismatchToNestedMatcher
{
    assertDescribeMismatch([NeverMatch mismatchDescription],
                           is([NeverMatch neverMatch]),
                           @"hi");
}

@end
