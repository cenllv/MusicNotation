#import "NSSet+OCTotallyLazy.h"
#import "Sequence.h"

@implementation NSSet (Functional)

- (Option*)oct_find:(PREDICATE)filterBlock
{
    return [[self oct_asSequence] oct_find:filterBlock];
}

- (NSSet*)oct_filter:(BOOL (^)(id))filterBlock
{
    return [[[self oct_asSequence] oct_filter:filterBlock] oct_asSet];
}

- (id)oct_fold:(id)value oct_with:(id (^)(id, id))functorBlock
{
    return [[self oct_asSequence] oct_fold:value oct_with:functorBlock];
}

- (NSSet*)oct_groupBy:(FUNCTION1)groupingBlock
{
    return [[[self oct_asSequence] oct_groupBy:groupingBlock] oct_asSet];
}

- (id)head
{
    return [[self oct_asSequence] oct_head];
}

- (Option*)headOption
{
    return [[self oct_asSequence] oct_headOption];
}

- (NSSet*)oct_join:(NSSet*)toJoin
{
    return [[[self oct_asSequence] oct_join:[toJoin oct_asSequence]] oct_asSet];
}

- (id)oct_map:(id (^)(id))funcBlock
{
    return [[[self oct_asSequence] oct_map:funcBlock] oct_asSet];
}

- (id)oct_reduce:(id (^)(id, id))functorBlock
{
    return [[self oct_asSequence] oct_reduce:functorBlock];
}

- (Sequence*)oct_asSequence
{
    return [Sequence oct_with:self];
}

- (NSArray*)oct_asArray
{
    return [[self oct_asSequence] oct_asArray];
}

- (NSEnumerator*)oct_toEnumerator
{
    return [self objectEnumerator];
}

@end