#import <objc/objc.h>
#import "Sequence.h"
#import "Group.h"
#import "Pair.h"
#import "Predicates.h"
#import "Callables.h"

@implementation NSArray (OCTotallyLazy)

- (NSArray*)oct_add:(id)value
{
    return [self oct_join:sequence(value, nil)];
}

- (NSArray*)oct_cons:(id)value
{
    return [array(value, nil) oct_join:self];
}

- (NSArray*)oct_drop:(int)n
{
    return [[[self oct_asSequence] oct_drop:n] oct_asArray];
}

- (NSArray*)oct_dropWhile:(BOOL (^)(id))funcBlock
{
    return [[[self oct_asSequence] oct_dropWhile:funcBlock] oct_asArray];
}

- (NSArray*)oct_filter:(BOOL (^)(id))filterBlock
{
    return [[[self oct_asSequence] oct_filter:filterBlock] oct_asArray];
}

- (NSArray*)oct_flatMap:(id (^)(id))functorBlock
{
    return [[[self oct_asSequence] oct_flatMap:functorBlock] oct_asArray];
}

- (NSArray*)oct_flatten
{
    return [[[self oct_asSequence] oct_flatten] oct_asArray];
}

- (Option*)oct_find:(BOOL (^)(id))filterBlock
{
    return [[self oct_asSequence] oct_find:filterBlock];
}

- (id)oct_fold:(id)value oct_with:(id (^)(id, id))functorBlock
{
    id accumulator = value;
    for(id item in self)
    {
        accumulator = functorBlock(accumulator, item);
    }
    return accumulator;
}

- (void)foreach:(void (^)(id))funcBlock
{
    for(id item in self)
    {
        funcBlock(item);
    }
}

- (void)oct_foreach:(void (^)(id, NSUInteger, BOOL*))funcBlock
{
    BOOL stop = NO;
    NSUInteger index = 0;
    for(id item in self)
    {
        funcBlock(item, index, &stop);
        if(stop)
        {
            break;
        }
        index++;
    }
}

- (BOOL)oct_isEmpty
{
    return self.count == 0;
}

- (NSArray*)oct_groupBy:(FUNCTION1)groupingBlock
{
    NSMutableDictionary* keysAndValues = [NSMutableDictionary dictionary];
    NSMutableArray* keys = [NSMutableArray array];
    NSMutableArray* nilKeyItems = [NSMutableArray array];
    [self foreach:^(id item) {
      id key = groupingBlock(item);
      if(key)
      {
          if(![keys containsObject:key])
          {
              [keys addObject:key];
              [keysAndValues setObject:[NSMutableArray array] forKey:key];
          }
          [[keysAndValues objectForKey:key] addObject:item];
      }
      else
      {
          [nilKeyItems addObject:item];
      }
    }];
    NSArray* keyedGroups = [keys oct_map:^(id key) {
      return [Group group:key enumerable:[keysAndValues objectForKey:key]];
    }];
    NSArray* unkeyedGroups = [nilKeyItems oct_map:^(id item) {
      return [Group group:nil enumerable:array(item, nil)];
    }];
    //    return keyedGroups;
    return [keyedGroups arrayByAddingObjectsFromArray:unkeyedGroups];
}

- (NSArray*)oct_grouped:(int)n
{
    return [[[self oct_asSequence] oct_grouped:n] oct_asArray];
}

- (id)oct_head
{
    return [[self oct_asSequence] oct_head];
}

- (Option*)oct_headOption
{
    return [[self oct_asSequence] oct_headOption];
}

- (NSArray*)oct_join:(id<Enumerable>)toJoin
{
    return [[[self oct_asSequence] oct_join:toJoin] oct_asArray];
}

- (id)oct_map:(id (^)(id))funcBlock
{
    return [[[self oct_asSequence] oct_map:funcBlock] oct_asArray];
}

- (id)oct_mapWithIndex:(id (^)(id, NSInteger))funcBlock
{
    return [[[self oct_asSequence] oct_mapWithIndex:funcBlock] oct_asArray];
}

- (NSArray*)oct_merge:(NSArray*)toMerge
{
    return [[[self oct_asSequence] oct_merge:[toMerge oct_asSequence]] oct_asArray];
}

- (Pair*)oct_partition:(BOOL (^)(id))filterBlock
{
    Pair* partitioned = [[self oct_asSequence] oct_partition:filterBlock];
    return [Pair left:[partitioned.left oct_asArray] right:[partitioned.right oct_asArray]];
}

- (id)oct_reduce:(id (^)(id, id))functorBlock
{
    return [self oct_isEmpty] ? nil : [[self oct_tail] oct_fold:[self oct_head] oct_with:functorBlock];
}

- (NSArray*)oct_reverse
{
    NSMutableArray* collectedArray = [[NSMutableArray alloc] init];
    NSEnumerator* reversed = [self reverseObjectEnumerator];
    id object;
    while((object = reversed.nextObject))
    {
        [collectedArray addObject:object];
    }
    return collectedArray;
}

- (Pair*)oct_splitAt:(int)splitIndex
{
    return [self oct_splitWhen:TL_not(TL_countTo(splitIndex))];
}

- (Pair*)oct_splitOn:(id)splitItem
{
    return [self oct_splitWhen:TL_equalTo(splitItem)];
}

- (Pair*)oct_splitWhen:(BOOL (^)(id))predicate
{
    Pair* partition = [self oct_partition:TL_whileTrue(TL_not(predicate))];
    return [Pair left:partition.left right:[partition.right oct_tail]];
}

- (NSArray*)oct_tail
{
    return [[[self oct_asSequence] oct_tail] oct_asArray];
    //    return [self takeRight:[self count] - 1];
}

- (NSArray*)oct_take:(int)n
{
    return [[[self oct_asSequence] oct_take:n] oct_asArray];
}

- (NSArray*)oct_takeWhile:(BOOL (^)(id))funcBlock
{
    return [[[self oct_asSequence] oct_takeWhile:funcBlock] oct_asArray];
}

- (NSArray*)takeRight:(int)n
{
    int toTake = (n > [self count]) ? [self count] : (NSUInteger)n;
    return [self subarrayWithRange:NSMakeRange([self count] - toTake, (NSUInteger)toTake)];
}

- (NSEnumerator*)oct_toEnumerator
{
    return [self objectEnumerator];
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

- (NSArray*)oct_zip:(NSArray*)otherArray
{
    return [[[self oct_asSequence] oct_zip:[otherArray oct_asSequence]] oct_asArray];
}

- (NSArray*)oct_zipWithIndex
{
    return [[[self oct_asSequence] oct_zipWithIndex] oct_asArray];
}

- (Sequence*)oct_asSequence
{
    return [Sequence oct_with:self];
}

- (NSSet*)oct_asSet
{
    return [[self oct_asSequence] oct_asSet];
}

- (NSArray*)oct_asArray
{
    return self;
}

- (NSDictionary*)oct_asDictionary
{
    Pair* keysAndValues = [self oct_partition:TL_alternate(YES)];
    NSArray* keys = keysAndValues.left;
    NSArray* values = keysAndValues.right;
    values = [values oct_take:[keys count]];
    keys = [keys oct_take:[values count]];
    NSEnumerator* valueEnumerator = [keysAndValues.right objectEnumerator];
    return [keys oct_fold:[NSMutableDictionary dictionary]
                 oct_with:^(NSMutableDictionary* accumulator, id key) {
                   [accumulator setObject:[valueEnumerator nextObject] forKey:key];
                   return accumulator;
                 }];
}
@end