#import <Foundation/Foundation.h>
#import "Option.h"
#import "Predicates.h"

@interface NSEnumerator (OCTotallyLazy)
- (NSEnumerator*)oct_drop:(int)toDrop;
- (NSEnumerator*)oct_dropWhile:(BOOL (^)(id))filterBlock;
- (NSEnumerator*)oct_filter:(BOOL (^)(id))filterBlock;
- (NSEnumerator*)oct_flatten;
- (NSEnumerator*)oct_map:(id (^)(id))func;

- (NSEnumerator*)oct_take:(int)n;
- (NSEnumerator*)oct_takeWhile:(BOOL (^)(id))predicate;
- (Option*)oct_find:(PREDICATE)predicate;

@end