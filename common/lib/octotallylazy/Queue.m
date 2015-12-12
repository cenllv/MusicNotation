#import "Queue.h"
#import "NSArray+OCTotallyLazy.h"

@implementation Queue
{
    NSMutableArray* queue;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)oct_isEmpty
{
    return [queue oct_isEmpty];
}

- (id)oct_remove
{
    if([self oct_isEmpty])
    {
        return nil;
    }
    id item = [queue objectAtIndex:0];
    [queue removeObjectAtIndex:0];
    return item;
}

- (void)oct_add:(id)item
{
    [queue addObject:item];
}

+ (Queue*)queue
{
    return [[Queue alloc] init];
}

@end