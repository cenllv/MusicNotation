#import <Foundation/Foundation.h>
#import "Predicates.h"
#import "Queue.h"

@interface PartitionEnumerator : NSEnumerator
+ (PartitionEnumerator*)oct_with:(NSEnumerator*)enumerator
                   predicate:(PREDICATE)predicate
                     matched:(Queue*)matched
                   unmatched:(Queue*)unmatched;

@end