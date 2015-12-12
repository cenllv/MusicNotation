#import <Foundation/Foundation.h>

@interface TakeWhileEnumerator : NSEnumerator
- (NSEnumerator*)initWith:(NSEnumerator*)anEnumerator predicate:(PREDICATE)aPredicate;

+ (NSEnumerator*)oct_with:(NSEnumerator*)anEnumerator predicate:(PREDICATE)predicate;
@end