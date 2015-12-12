#import <Foundation/Foundation.h>
#import "Option.h"
#import "Mappable.h"
#import "Flattenable.h"
#import "Types.h"
@class Sequence;
@class Pair;

@interface NSArray (OCTotallyLazy) <Mappable, Foldable, Enumerable, Flattenable>
- (NSArray*)oct_add:(id)value;
- (NSArray*)oct_cons:(id)value;
- (NSArray*)oct_drop:(int)toDrop;
- (NSArray*)oct_dropWhile:(PREDICATE)funcBlock;
- (NSArray*)oct_filter:(PREDICATE)filterBlock;
- (Option*)oct_find:(PREDICATE)filterBlock;
- (NSArray*)oct_flatMap:(FUNCTION1)functorBlock;
- (NSArray*)oct_flatten;
- (id)oct_fold:(id)value oct_with:(id (^)(id accumulator, id item))functorBlock;
- (void)oct_foreach:(void (^)(id, NSUInteger, BOOL*))funcBlock;
- (BOOL)oct_isEmpty;
- (NSArray*)oct_groupBy:(FUNCTION1)groupingBlock;
- (NSArray*)oct_grouped:(int)n;
- (id)oct_head;
- (Option*)oct_headOption;
- (NSArray*)oct_join:(id<Enumerable>)toJoin;
- (id)oct_mapWithIndex:(id (^)(id, NSInteger))funcBlock;
- (Pair*)oct_partition:(PREDICATE)toJoin;
- (id)oct_reduce:(id (^)(id, id))functorBlock;
- (NSArray*)oct_reverse;
- (Pair*)oct_splitAt:(int)splitIndex;
- (Pair*)oct_splitOn:(id)splitItem;
- (Pair*)oct_splitWhen:(PREDICATE)predicate;
- (NSArray*)oct_tail;
- (NSArray*)oct_take:(int)n;
- (NSArray*)oct_takeWhile:(PREDICATE)funcBlock;
- (NSArray*)oct_takeRight:(int)n;
- (NSString*)oct_toString;
- (NSString*)oct_toString:(NSString*)separator;
- (NSString*)oct_toString:(NSString*)start separator:(NSString*)separator end:(NSString*)end;
- (NSArray*)oct_zip:(NSArray*)otherSequence;
- (NSArray*)oct_zipWithIndex;

- (Sequence*)oct_asSequence;
- (NSSet*)oct_asSet;
- (NSArray*)oct_asArray;
- (NSDictionary*)oct_asDictionary;

@end

static NSArray* array(id items, ...)
{
    NSMutableArray* array = [NSMutableArray array];
    va_list args;
    va_start(args, items);
    for(id arg = items; arg != nil; arg = va_arg(args, id))
    {
        [array addObject:arg];
    }
    va_end(args);
    return array;
}
