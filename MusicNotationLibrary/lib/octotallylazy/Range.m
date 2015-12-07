#import "Range.h"
#import "EasyEnumerable.h"
#import "EnumerateEnumerator.h"
#import "Callables.h"
#import "Predicates.h"

@implementation Range

+ (EasyEnumerable*)incrementingEnumerator:(NSNumber*)start
{
    return [EasyEnumerable oct_with:^{
      return [EnumerateEnumerator withCallable:TL_increment() seed:start];
    }];
}

+ (Sequence*)range:(NSNumber*)start
{
    return [Sequence oct_with:[self incrementingEnumerator:start]];
}

+ (Sequence*)range:(NSNumber*)start end:(NSNumber*)end
{
    return [[Sequence oct_with:[self incrementingEnumerator:start]] oct_takeWhile:TL_lessThanOrEqualTo(end)];
}

@end