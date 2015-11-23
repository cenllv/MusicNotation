//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2014 hamcrest.org. See LICENSE.txt

    // Class under test
#define HC_SHORTHAND
#import "HCAnyOf.h"

    // Collaborators
#import "HCIsEqual.h"
#import "HCStringEndsWith.h"
#import "HCStringStartsWith.h"

    // Test support
#import "AbstractMatcherTest.h"


@interface AnyOfTest : AbstractMatcherTest
@end

@implementation AnyOfTest

- (void)testCopesWithNilsAndUnknownTypes
{
    id matcher = anyOf(equalTo(@"irrelevant"), nil);

    assertNilSafe(matcher);
    assertUnknownTypeSafe(matcher);
}

- (void)testEvaluatesToTheTheLogicalDisjunctionOfTwoOtherMatchers
{
    id matcher = anyOf(startsWith(@"goo"), endsWith(@"ood"), nil);

    assertMatches(@"didn't pass both sub-matchers", matcher, @"good");
    assertMatches(@"didn't pass second sub-matcher", matcher, @"mood");
    assertMatches(@"didn't pass first sub-matcher", matcher, @"goon");
    assertDoesNotMatch(@"didn't fail both sub-matchers", matcher, @"flan");
}

- (void)testEvaluatesToTheTheLogicalDisjunctionOfManyOtherMatchers
{
    id matcher = anyOf(startsWith(@"g"), startsWith(@"go"), endsWith(@"d"), startsWith(@"go"), startsWith(@"goo"), nil);

    assertMatches(@"didn't pass middle sub-matcher", matcher, @"vlad");
    assertDoesNotMatch(@"didn't fail all sub-matchers", matcher, @"flan");

}
- (void)testProvidesConvenientShortcutForMatchingWithEqualTo
{
    assertMatches(@"first matcher", anyOf(@"good", @"bad", nil), @"good");
    assertMatches(@"second matcher", anyOf(@"bad", @"good", nil), @"good");
    assertMatches(@"both matchers", anyOf(@"good", @"good", nil), @"good");
}

- (void)testHasAReadableDescription
{
    assertDescription(@"(\"good\" or \"bad\" or \"ugly\")",
                      anyOf(equalTo(@"good"), equalTo(@"bad"), equalTo(@"ugly"), nil));
}

- (void)testSuccessfulMatchDoesNotGenerateMismatchDescription
{
    assertNoMismatchDescription(anyOf(equalTo(@"good"), equalTo(@"good"), nil),
                                @"good");
}

- (void)testMismatchDescriptionDescribesFirstFailingMatch
{
    assertMismatchDescription(@"was \"ugly\"",
                              anyOf(equalTo(@"bad"), equalTo(@"good"), nil),
                              @"ugly");
}

- (void)testDescribeMismatch
{
    assertDescribeMismatch(@"was \"ugly\"",
                           anyOf(equalTo(@"bad"), equalTo(@"good"), nil),
                           @"ugly");
}

- (void)testMatcherCreationRequiresNonNilArgument
{
    STAssertThrows(anyOf(nil), @"Should require non-nil list");
}

@end
