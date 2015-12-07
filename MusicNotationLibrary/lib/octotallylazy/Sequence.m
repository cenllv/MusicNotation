#define TL_COERCIONS

#import "NSEnumerator+OCTotallyLazy.h"
#import "PairEnumerator.h"
#import "MemoisedEnumerator.h"
#import "MemoisedSequence.h"
#import "RepeatEnumerator.h"
#import "EasyEnumerable.h"
#import "Callables.h"
#import "GroupedEnumerator.h"
#import "Pair.h"
#import "Range.h"
#import "PartitionEnumerator.h"
#import "MergeEnumerator.h"

@implementation Sequence
{
    id<Enumerable> enumerable;
    NSEnumerator* forwardOnlyEnumerator;
}

- (Sequence*)initWith:(id<Enumerable>)anEnumerable
{
    self = [super init];
    enumerable = anEnumerable;
    forwardOnlyEnumerator = [enumerable oct_toEnumerator];
    return self;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)state
                                  objects:(__unsafe_unretained id[])buffer
                                    count:(NSUInteger)len
{
    return [forwardOnlyEnumerator countByEnumeratingWithState:state objects:buffer count:len];
}

- (Sequence*)oct_add:(id)value
{
    return [self oct_join:sequence(value, nil)];
}

- (Sequence*)oct_cons:(id)value
{
    return [sequence(value, nil) oct_join:self];
}

- (Sequence*)oct_drop:(int)toDrop
{
    return [Sequence oct_with:[EasyEnumerable oct_with:^{
                       return [[self oct_toEnumerator] oct_drop:toDrop];
                     }]];
}

- (Sequence*)oct_dropWhile:(BOOL (^)(id))funcBlock
{
    return [Sequence oct_with:[EasyEnumerable oct_with:^{
                       return [[self oct_toEnumerator] oct_dropWhile:funcBlock];
                     }]];
}

- (id)first
{
    return [self oct_head];
}

- (Sequence*)oct_flatMap:(id (^)(id))funcBlock
{
    return [Sequence oct_with:[EasyEnumerable oct_with:^{
                       return [[[self oct_toEnumerator] oct_map:funcBlock] oct_flatten];
                     }]];
}

- (Sequence*)oct_filter:(BOOL (^)(id))predicate
{
    return [Sequence oct_with:[EasyEnumerable oct_with:^{
                       return [[self oct_toEnumerator] oct_filter:predicate];
                     }]];
}

- (Option*)oct_find:(BOOL (^)(id))predicate
{
    return [[self oct_toEnumerator] oct_find:predicate];
}

- (Sequence*)oct_flatten
{
    return [Sequence oct_with:[EasyEnumerable oct_with:^{
                       return [[self oct_toEnumerator] oct_flatten];
                     }]];
}

- (id)oct_fold:(id)value oct_with:(id (^)(id, id))functorBlock
{
    return [[self oct_asArray] oct_fold:value oct_with:functorBlock];
}

- (void)oct_foreach:(void (^)(id, NSUInteger, BOOL*))funcBlock
{
    [[self oct_asArray] oct_foreach:funcBlock];
}

- (Sequence*)oct_grouped:(int)n
{
    return [Sequence oct_with:[EasyEnumerable oct_with:^{
                       return [GroupedEnumerator oct_with:[self oct_toEnumerator] groupSize:n];
                     }]];
}

- (Sequence*)oct_groupBy:(FUNCTION1)groupingBlock
{
    return [[[self oct_asArray] oct_groupBy:groupingBlock] oct_asSequence];
}

- (id)head
{
    id item = [self oct_toEnumerator].nextObject;
    if(item == nil)
    {
        [NSException raise:@"NoSuchElementException"
                    format:@"Expected a sequence with at least one element, but sequence was empty."];
    }
    return item;
}

- (Option*)headOption
{
    return option([self oct_toEnumerator].nextObject);
}

- (Sequence*)oct_join:(id<Enumerable>)toJoin
{
    return [sequence(self, toJoin, nil) oct_flatten];
}

- (Sequence*)oct_map:(id (^)(id))funcBlock
{
    return [Sequence oct_with:[EasyEnumerable oct_with:^{
                       return [[self oct_toEnumerator] oct_map:funcBlock];
                     }]];
}

- (Sequence*)mapWithIndex:(id (^)(id, NSInteger))funcBlock
{
    return [[self oct_zipWithIndex] oct_map:^(Pair* itemAndIndex) {
      return funcBlock(itemAndIndex.left, [itemAndIndex.right intValue]);
    }];
}

- (Sequence*)merge:(Sequence*)toMerge
{
    return [[Sequence oct_with:[EasyEnumerable oct_with:^{
                        return [MergeEnumerator oct_with:[self oct_toEnumerator] toMerge:[toMerge oct_toEnumerator]];
                      }]] oct_flatten];
}

- (Pair*)partition:(BOOL (^)(id))predicate
{
    Queue* matched = [Queue queue];
    Queue* unmatched = [Queue queue];
    NSEnumerator* underlyingEnumerator = [self oct_toEnumerator];
    Sequence* leftSequence = memoiseSeq([EasyEnumerable oct_with:^{
      return
          [PartitionEnumerator oct_with:underlyingEnumerator predicate:predicate matched:matched unmatched:unmatched];
    }]);
    Sequence* rightSequence = memoiseSeq([EasyEnumerable oct_with:^{
      return [PartitionEnumerator oct_with:underlyingEnumerator
                                 predicate:TL_not(predicate)
                                   matched:unmatched
                                 unmatched:matched];
    }]);
    return [Pair left:leftSequence right:rightSequence];
}

- (id)oct_reduce:(id (^)(id, id))functorBlock
{
    return [[self oct_asArray] oct_reduce:functorBlock];
}

- (id)second
{
    return [[self oct_tail] oct_head];
}

- (Pair*)splitAt:(int)splitIndex
{
    return [self splitWhen:TL_not(TL_countTo(splitIndex))];
}

- (Pair*)splitOn:(id)splitItem
{
    return [self splitWhen:TL_equalTo(splitItem)];
}

- (Pair*)splitWhen:(BOOL (^)(id))predicate
{
    Pair* partitioned = [self partition:TL_whileTrue(TL_not(predicate))];
    return [Pair left:partitioned.left right:[partitioned.right oct_tail]];
}

- (Sequence*)tail
{
    return [Sequence oct_with:[EasyEnumerable oct_with:^{
                       NSEnumerator* const anEnumerator = [self oct_toEnumerator];
                       [anEnumerator nextObject];
                       return anEnumerator;
                     }]];
}

- (Sequence*)oct_take:(int)n
{
    return [Sequence oct_with:[EasyEnumerable oct_with:^{
                       return [[self oct_toEnumerator] oct_take:n];
                     }]];
}

- (Sequence*)oct_takeWhile:(BOOL (^)(id))funcBlock
{
    return [Sequence oct_with:[EasyEnumerable oct_with:^{
                       return [[self oct_toEnumerator] oct_takeWhile:funcBlock];
                     }]];
}

- (NSDictionary*)toDictionary:(id (^)(id))valueBlock
{
    return [self oct_fold:[NSMutableDictionary dictionary]
                 oct_with:^(NSMutableDictionary* accumulator, id item) {
                   if([accumulator objectForKey:item] == nil)
                   {
                       [accumulator setObject:valueBlock(item) forKey:item];
                   }
                   return accumulator;
                 }];
}

- (NSString*)oct_toString
{
    return [self oct_toString:@""];
}

- (NSString*)oct_toString:(NSString*)separator
{
    return [self oct_reduce:TL_appendWithSeparator(separator)];
}

- (NSString*)oct_toString:(NSString*)start separator:(NSString*)separator end:(NSString*)end
{
    return [[start stringByAppendingString:[self oct_toString:separator]] stringByAppendingString:end];
}

- (Sequence*)oct_zip:(Sequence*)otherSequence
{
    return [Sequence oct_with:[EasyEnumerable oct_with:^{
                       return [PairEnumerator withLeft:[self oct_toEnumerator] right:[otherSequence oct_toEnumerator]];
                     }]];
}

- (Sequence*)oct_zipWithIndex
{
    return [self oct_zip:[Range range:[NSNumber numberWithInt:0]]];
}

- (Sequence*)oct_cycle
{
    return [Sequence oct_with:[EasyEnumerable oct_with:^{
                       return [RepeatEnumerator oct_with:[MemoisedEnumerator oct_with:[self oct_toEnumerator]]];
                     }]];
}

+ (Sequence*)oct_with:(id<Enumerable>)enumerable
{
    return [[Sequence alloc] initWith:enumerable];
}

- (NSDictionary*)oct_asDictionary
{
    return [[self oct_asArray] oct_asDictionary];
}

- (NSArray*)oct_asArray
{
    NSEnumerator* itemsEnumerator = [self oct_toEnumerator];
    NSMutableArray* collect = [NSMutableArray array];
    id object;
    while((object = [itemsEnumerator nextObject]) != nil)
    {
        [collect addObject:object];
    }
    return collect;
}

- (NSSet*)oct_asSet
{
    return [NSSet setWithArray:[self oct_asArray]];
}

- (NSString*)description
{
    NSEnumerator* itemsEnumerator = [self oct_toEnumerator];
    NSString* description = @"Sequence [";
    int count = 3;
    id item;
    while(count > 0 && (item = itemsEnumerator.nextObject))
    {
        description = [description stringByAppendingFormat:@"%@, ", item];
        count--;
    }
    if([itemsEnumerator nextObject] != nil)
    {
        description = [description stringByAppendingString:@"..."];
    }
    return [description stringByAppendingString:@"]"];
}

- (NSEnumerator*)oct_toEnumerator
{
    return [enumerable oct_toEnumerator];
}

@end