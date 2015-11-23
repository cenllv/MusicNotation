//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2014 hamcrest.org. See LICENSE.txt

    // Class under test
#define HC_SHORTHAND
#import "HCIsDictionaryContainingKey.h"

    // Collaborators
#import "HCIsEqual.h"

    // Test support
#import "AbstractMatcherTest.h"


@interface IsDictionaryContainingKeyTest : AbstractMatcherTest
@end

@implementation IsDictionaryContainingKeyTest

- (void)testCopesWithNilsAndUnknownTypes
{
    id matcher = hasKey(@"irrelevant");

    assertNilSafe(matcher);
    assertUnknownTypeSafe(matcher);
}

- (void)testMatchesSingletonDictionaryContainingKey
{
    NSDictionary *dict = @{@"a": @1};

    assertMatches(@"Matches single key", hasKey(equalTo(@"a")), dict);
}

- (void)testMatchesDictionaryContainingKey
{
    NSDictionary *dict = @{@"a": @1,
                           @"b": @2,
                           @"c": @3};

    assertMatches(@"Matches a", hasKey(equalTo(@"a")), dict);
    assertMatches(@"Matches c", hasKey(equalTo(@"c")), dict);
}

- (void)testProvidesConvenientShortcutForMatchingWithEqualTo
{
    NSDictionary *dict = @{@"a": @1,
                           @"b": @2,
                           @"c": @3};

    assertMatches(@"Matches c", hasKey(@"c"), dict);
}

- (void)testDoesNotMatchEmptyDictionary
{
    assertDoesNotMatch(@"empty", hasKey(@"Foo"), @{});
}

- (void)testDoesNotMatchDictionaryMissingKey
{
    NSDictionary *dict = @{@"a": @1,
                           @"b": @2,
                           @"c": @3};

    assertDoesNotMatch(@"no matching key", hasKey(@"d"), dict);
}

- (void)testMatcherCreationRequiresNonNilArgument
{
    STAssertThrows(hasKey(nil), @"Should require non-nil argument");
}

- (void)testHasReadableDescription
{
    assertDescription(@"a dictionary containing key \"a\"", hasKey(@"a"));
}

- (void)testSuccessfulMatchDoesNotGenerateMismatchDescription
{
    NSDictionary *dict = @{@"a": @1};
    assertNoMismatchDescription(hasKey(@"a"), dict);
}

- (void)testMismatchDescriptionShowsActualArgument
{
    assertMismatchDescription(@"was \"bad\"", hasKey(@"a"), @"bad");
}

- (void)testDescribeMismatch
{
    assertDescribeMismatch(@"was \"bad\"", hasKey(@"a"), @"bad");
}

@end
