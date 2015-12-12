#import <Foundation/Foundation.h>

@interface MergeEnumerator : NSEnumerator
- (MergeEnumerator*)initWith:(NSEnumerator*)leftEnumerator toMerge:(NSEnumerator*)rightEnumerator;

+ (MergeEnumerator*)oct_with:(NSEnumerator*)leftEnumerator toMerge:(NSEnumerator*)rightEnumerator;
@end