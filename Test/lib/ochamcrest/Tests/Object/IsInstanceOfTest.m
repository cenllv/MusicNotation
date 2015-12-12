//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2014 hamcrest.org. See LICENSE.txt

    // Class under test
#define HC_SHORTHAND
#import "HCIsInstanceOf.h"

    // Test support
#import "AbstractMatcherTest.h"
#import "SomeClassAndSubclass.h"


@interface IsInstanceOfTest : AbstractMatcherTest
@end

@implementation IsInstanceOfTest

- (void)testCopesWithNilsAndUnknownTypes
{
    id matcher = instanceOf([SomeClass class]);

    assertNilSafe(matcher);
    assertUnknownTypeSafe(matcher);
}

- (void)testEvaluatesToTrueIfArgumentIsInstanceOfGivenClass
{
    SomeClass *obj = [[SomeClass alloc] init];
    assertMatches(@"same class", instanceOf([SomeClass class]), obj);
}

- (void)testEvaluatesToTrueIfArgumentIsSubclassOfGivenClass
{
    SomeSubclass *sub = [[SomeSubclass alloc] init];
    assertMatches(@"subclass", instanceOf([SomeClass class]), sub);
}

- (void)testEvaluatesToFalseIfArgumentIsInstanceOfDifferentClass
{
    assertDoesNotMatch(@"different class", instanceOf([SomeClass class]), @"hi");
}

- (void)testEvaluatesToFalseIfArgumentIsNil
{
    assertDoesNotMatch(@"nil", instanceOf([NSNumber class]), nil);
}

- (void)testMatcherCreationRequiresNonNilArgument
{
    STAssertThrows(instanceOf(nil), @"Should require non-nil argument");
}

- (void)testHasAReadableDescription
{
    assertDescription(@"an instance of SomeClass", instanceOf([SomeClass class]));
}

- (void)testSuccessfulMatchDoesNotGenerateMismatchDescription
{
    assertNoMismatchDescription(instanceOf([SomeClass class]), [[SomeClass alloc] init]);
}

- (void)testMismatchDescriptionShowsClassOfActualArgument
{
    assertMismatchDescription(@"was SomeClass instance <SOME_CLASS>",
                              instanceOf([NSValue class]), [[SomeClass alloc] init]);
}

- (void)testMismatchDescriptionHandlesNilArgument
{
    assertMismatchDescription(@"was nil", instanceOf([NSValue class]), nil);
}

- (void)testDescribeMismatch
{
    assertDescribeMismatch(@"was SomeClass instance <SOME_CLASS>",
                           instanceOf([NSValue class]), [[SomeClass alloc] init]);
}

@end
