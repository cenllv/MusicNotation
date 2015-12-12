//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2014 hamcrest.org. See LICENSE.txt

    // Class under test
#import "HCDiagnosingMatcher.h"

    // Test support
#import "AbstractMatcherTest.h"


@interface IncompleteDiagnosingMatcher : HCDiagnosingMatcher
@end

@implementation IncompleteDiagnosingMatcher

// Let's say we mistakenly implemented -matches: instead of -matches:describingMismatchTo:
- (BOOL)matches:(id)item
{
    return YES;
}

@end


@interface IncompleteDiagnosingMatcherTest : AbstractMatcherTest
@end

@implementation IncompleteDiagnosingMatcherTest

- (void)testSubclassShouldBeRequiredToDefineMatchesDescribingMismatchToMethod
{
    id matcher = [[IncompleteDiagnosingMatcher alloc] init];

    STAssertThrows([matcher matches:nil describingMismatchTo:nil], nil);
}

@end
