#import <Foundation/Foundation.h>
#import "Some.h"
#import "None.h"
#import "Sequence.h"

@interface NSSet (Functional) <Mappable, Foldable, Enumerable>
- (Option*)oct_find:(PREDICATE)filterBlock;
- (NSSet*)oct_filter:(PREDICATE)filterBlock;
- (NSSet*)oct_groupBy:(FUNCTION1)groupingBlock;
- (id)head;
- (Option*)headOption;
- (NSSet*)oct_join:(NSSet*)toJoin;
- (id)oct_reduce:(FUNCTION2)functorBlock;

- (Sequence*)oct_asSequence;
- (NSArray*)oct_asArray;
@end

static NSSet* set()
{
    return [NSSet set];
}