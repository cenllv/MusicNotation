#import "EasyEnumerable.h"

@implementation EasyEnumerable
{
    NSEnumerator* (^convertToEnumerator)();
}
- (EasyEnumerable*)initWith:(NSEnumerator* (^)())aConvertToEnumerator
{
    self = [super init];
    convertToEnumerator = [aConvertToEnumerator copy];
    return self;
}

+ (EasyEnumerable*)oct_with:(NSEnumerator* (^)())aConvertToEnumerator
{
    return [[EasyEnumerable alloc] initWith:aConvertToEnumerator];
}

- (NSEnumerator*)oct_toEnumerator
{
    return convertToEnumerator();
}

@end