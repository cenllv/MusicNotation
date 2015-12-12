#import <Foundation/Foundation.h>
#import "Enumerable.h"

@interface EasyEnumerable : NSObject <Enumerable>
+ (EasyEnumerable*)oct_with:(NSEnumerator* (^)())aConvertToEnumerator;
@end