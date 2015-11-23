@import Foundation;
#import "Types.h"
#import "Mappable.h"
#import "Option.h"
#import "Enumerable.h"
#import "NSArray+OCTotallyLazy.h"

@interface Sequence : NSObject <NSFastEnumeration, Mappable, Enumerable>

- (Sequence*)initWith:(id<Enumerable>)enumerator;
- (Sequence*)add:(id)value;
- (Sequence*)cons:(id)value;
- (Sequence*)cycle;
- (Sequence*)drop:(NSUInteger)toDrop;
- (Sequence*)dropWhile:(PREDICATE)funcBlock;
- (Option*)find:(PREDICATE)predicate;
- (id)first;
- (Sequence*)flatMap:(FUNCTION1)funcBlock;
- (id)filter:(PREDICATE)filterBlock;
- (Sequence*)flatten;
- (id)fold:(id)value with:(FUNCTION2)functorBlock;
- (void)foreach:(void (^)(id))funcBlock;
- (Sequence*)grouped:(NSUInteger)n;
- (Sequence*)groupBy:(FUNCTION1)groupingBlock;
- (id)head;
- (Option*)headOption;
- (Sequence*)join:(id<Enumerable>)toJoin;
- (Sequence*)oct_mapWithIndex:(id (^)(id, NSInteger))func;
- (Sequence*)merge:(Sequence*)toMerge;
- (Pair*)partition:(PREDICATE)predicate;
- (id)reduce:(id (^)(id, id))functorBlock;
- (id)second;
- (Pair*)splitAt:(NSUInteger)splitIndex;
- (Pair*)splitOn:(id)splitItem;
- (Pair*)splitWhen:(PREDICATE)predicate;
- (Sequence*)tail;
- (Sequence*)take:(NSUInteger)n;
- (Sequence*)takeWhile:(PREDICATE)funcBlock;
- (NSDictionary*)toDictionary:(id (^)(id))valueBlock;
- (NSString*)toString;
- (NSString*)toString:(NSString*)separator;
- (NSString*)toString:(NSString*)start separator:(NSString*)separator end:(NSString*)end;
- (Sequence*)zip:(Sequence*)otherSequence;
- (Sequence*)zipWithIndex;

- (NSArray*)asArray;
- (NSSet*)asSet;
- (NSDictionary*)asDictionary;

+ (Sequence*)with:(id<Enumerable>)enumerable;

@end

inline static Sequence* sequence(id items, ...)
{
    NSMutableArray* array = [NSMutableArray array];
    va_list args;
    va_start(args, items);
    for(id arg = items; arg != nil; arg = va_arg(args, id))
    {
        [array addObject:arg];
    }
    va_end(args);
    return [Sequence with:array];
}