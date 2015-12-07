#import "None.h"
#import "NoSuchElementException.h"
#import "Some.h"
#import "Sequence.h"
#import "EmptyEnumerator.h"

@implementation None
+ (Option*)none
{
    return [[None alloc] init];
}

- (BOOL)isEmpty
{
    return TRUE;
}

- (id)get
{
    return nil;
}

- (id)getSafely
{
    [NoSuchElementException raise:@"Cannot get value of None" format:@"Cannot get value of None"];
    return nil;
}

- (id)getOrElse:(id)other
{
    return other;
}

- (id)getOrInvoke:(id (^)())funcBlock
{
    return funcBlock();
}

- (BOOL)isEqual:(id)otherObject
{
    return [otherObject isKindOfClass:[None class]];
}

- (id)oct_flatMap:(id (^)(id))funcBlock
{
    return [None none];
}

- (void)maybe:(void (^)(id))invokeWhenSomeBlock
{
    // Do nothing
}

- (id)oct_map:(id (^)(id))funcBlock
{
    return [None none];
}

- (id)oct_fold:(id)seed oct_with:(id (^)(id, id))functorBlock
{
    return [Some oct_some:seed];
}

- (id)copyWithZone:(NSZone*)zone
{
    return [None none];
}

- (NSEnumerator*)oct_toEnumerator
{
    return [EmptyEnumerator emptyEnumerator];
}

- (Sequence*)asSequence
{
    return sequence(nil);
}

@end