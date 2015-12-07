#import <Foundation/Foundation.h>
#import "MemoisedEnumerator.h"

@interface RepeatEnumerator : NSEnumerator
- (RepeatEnumerator*)initWith:(MemoisedEnumerator*)enumerator;

+ (RepeatEnumerator*)oct_with:(MemoisedEnumerator*)anEnumerator;
@end