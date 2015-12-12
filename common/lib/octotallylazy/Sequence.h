#import <Foundation/Foundation.h>
#import "Types.h"
#import "Mappable.h"
#import "Option.h"
#import "Enumerable.h"
#import "NSArray+OCTotallyLazy.h"

@interface Sequence : NSObject <NSFastEnumeration, Mappable, Enumerable>

- (Sequence*)initWith:(id<Enumerable>)enumerator;
- (Sequence*)oct_add:(id)value;
- (Sequence*)oct_cons:(id)value;
- (Sequence*)oct_cycle;
- (Sequence*)oct_drop:(int)toDrop;
- (Sequence*)oct_dropWhile:(PREDICATE)funcBlock;
- (Option*)oct_find:(PREDICATE)predicate;
- (id)oct_first;
- (Sequence*)oct_flatMap:(FUNCTION1)funcBlock;
- (id)oct_filter:(PREDICATE)filterBlock;
- (Sequence*)oct_flatten;
- (id)oct_fold:(id)value oct_with:(FUNCTION2)functorBlock;
- (void)oct_foreach:(void (^)(id, NSUInteger, BOOL*))funcBlock;
- (Sequence*)oct_grouped:(int)n;
- (Sequence*)oct_groupBy:(FUNCTION1)groupingBlock;
- (id)oct_head;
- (Option*)oct_headOption;
- (Sequence*)oct_join:(id<Enumerable>)toJoin;
- (Sequence*)oct_mapWithIndex:(id (^)(id, NSInteger))func;
- (Sequence*)oct_merge:(Sequence*)toMerge;
- (Pair*)oct_partition:(PREDICATE)predicate;
- (id)oct_reduce:(id (^)(id, id))functorBlock;
- (id)oct_second;
- (Pair*)oct_splitAt:(int)splitIndex;
- (Pair*)oct_splitOn:(id)splitItem;
- (Pair*)oct_splitWhen:(PREDICATE)predicate;
- (Sequence*)oct_tail;
- (Sequence*)oct_take:(int)n;
- (Sequence*)oct_takeWhile:(PREDICATE)funcBlock;
- (NSDictionary*)oct_toDictionary:(id (^)(id))valueBlock;
- (NSString*)oct_toString;
- (NSString*)oct_toString:(NSString*)separator;
- (NSString*)oct_toString:(NSString*)start separator:(NSString*)separator end:(NSString*)end;
- (Sequence*)oct_zip:(Sequence*)otherSequence;
- (Sequence*)oct_zipWithIndex;

- (NSArray*)oct_asArray;
- (NSSet*)oct_asSet;
- (NSDictionary*)oct_asDictionary;

+ (Sequence*)oct_with:(id<Enumerable>)enumerable;

@end

static Sequence* sequence(id items, ...)
{
    NSMutableArray* array = [NSMutableArray array];
    va_list args;
    va_start(args, items);
    for(id arg = items; arg != nil; arg = va_arg(args, id))
    {
        [array addObject:arg];
    }
    va_end(args);
    return [Sequence oct_with:array];
}