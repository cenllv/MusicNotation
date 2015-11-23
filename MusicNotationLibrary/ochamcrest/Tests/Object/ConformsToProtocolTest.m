//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2014 hamcrest.org. See LICENSE.txt
//  Contribution by Todd Farrell

    // Class under test
#define HC_SHORTHAND
#import "HCConformsToProtocol.h"

    // Test support
#import "AbstractMatcherTest.h"


@protocol TestProtocol
@end

@interface TestClass : NSObject <TestProtocol>
@end

@implementation TestClass

+ (instancetype)testClass
{
    return [[TestClass alloc] init];
}

@end

@interface ConformsToProtocolTest : AbstractMatcherTest
@end

@implementation ConformsToProtocolTest

- (void)testCopesWithNilsAndUnknownTypes
{
    id matcher = conformsTo(@protocol(TestProtocol));

    assertNilSafe(matcher);
    assertUnknownTypeSafe(matcher);
}

- (void)testEvaluatesToTrueIfArgumentConformsToASpecificProtocol
{
    TestClass *instance = [TestClass testClass];

    assertMatches(@"conforms to protocol", conformsTo(@protocol(TestProtocol)), instance);

    assertDoesNotMatch(@"does not conform to protocol", conformsTo(@protocol(TestProtocol)), @"hi");
    assertDoesNotMatch(@"nil", conformsTo(@protocol(TestProtocol)), nil);
}

- (void)testMatcherCreationRequiresNonNilArgument
{
    STAssertThrows(conformsTo(nil), @"Should require non-nil argument");
}

- (void)testHasAReadableDescription
{
    assertDescription(@"an object that conforms to TestProtocol", conformsTo(@protocol(TestProtocol)));
}

- (void)testSuccessfulMatchDoesNotGenerateMismatchDescription
{
    assertNoMismatchDescription(conformsTo(@protocol(NSObject)), @"hi");
}

- (void)testMismatchDescriptionShowsActualArgument
{
    assertMismatchDescription(@"was \"bad\"", conformsTo(@protocol(TestProtocol)), @"bad");
}

- (void)testDescribeMismatch
{
    assertDescribeMismatch(@"was \"bad\"", conformsTo(@protocol(TestProtocol)), @"bad");
}

@end
