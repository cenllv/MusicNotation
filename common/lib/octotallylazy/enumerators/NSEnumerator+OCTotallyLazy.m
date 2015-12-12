#import "NSEnumerator+OCTotallyLazy.h"
#import "FlattenEnumerator.h"
#import "MapEnumerator.h"
#import "FilterEnumerator.h"
#import "Some.h"
#import "None.h"
#import "TakeWhileEnumerator.h"

@implementation NSEnumerator (OCTotallyLazy)

- (NSEnumerator*)oct_drop:(int)toDrop
{
    return [self oct_dropWhile:TL_countTo(toDrop)];
}

- (NSEnumerator*)oct_dropWhile:(PREDICATE)predicate
{
    return [self oct_filter:TL_not(TL_whileTrue(predicate))];
}

- (NSEnumerator*)oct_filter:(PREDICATE)predicate
{
    return [FilterEnumerator withEnumerator:self andFilter:predicate];
}

- (Option*)oct_find:(PREDICATE)predicate
{
    for(id item in self)
    {
        if(predicate(item))
        {
            return [Some oct_some:item];
        }
    }
    return [None none];
}

- (NSEnumerator*)oct_flatten
{
    return [FlattenEnumerator withEnumerator:self];
}

- (NSEnumerator*)oct_map:(id (^)(id))func
{
    return [MapEnumerator withEnumerator:self andFunction:func];
}

- (NSEnumerator*)oct_take:(int)n
{
    return [self oct_takeWhile:TL_countTo(n)];
}

- (NSEnumerator*)oct_takeWhile:(BOOL (^)(id))predicate
{
    return [TakeWhileEnumerator oct_with:self predicate:TL_whileTrue(predicate)];
}

@end