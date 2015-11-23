#import "MemoisedSequence.h"

@implementation MemoisedSequence
{
    NSMutableArray* memory;
}

+ (Sequence*)with:(id<Enumerable>)enumerable
{
    return [[MemoisedSequence alloc] initWith:enumerable];
}

- (Sequence*)initWith:(id<Enumerable>)enumerator
{
    self = [super initWith:enumerator];
    if(self)
    {
        memory = [NSMutableArray array];
    }
    return self;
}

- (NSEnumerator*)oct_toEnumerator
{
    return [MemoisedEnumerator with:[super oct_toEnumerator] memory:memory];
}

@end