#import "Some.h"
#import "Sequence.h"
#import "SingleValueEnumerator.h"

@implementation Some
{
    id<NSObject> value;
}

- (Option*)initWithValue:(id<NSObject>)aValue
{
    self = [super init];
    value = aValue;
    return self;
}

+ (Option*)oct_some:(id)value
{
    return [[Some alloc] initWithValue:value];
}

- (BOOL)oct_isEmpty
{
    return FALSE;
}

- (BOOL)oct_isEqual:(id)otherObject
{
    if(![otherObject isKindOfClass:[Some class]])
    {
        return [self isEqual:[Some oct_some:otherObject]];
    }
    return [[otherObject oct_get] oct_isEqual:[self oct_get]];
}

- (id)oct_get
{
    return value;
}

- (id)oct_getSafely
{
    return value;
}

- (id)oct_getOrElse:(id)other
{
    return value;
}

- (id)getOrInvoke:(id (^)())funcBlock
{
    return value;
}

- (id)oct_map:(id (^)(id))funcBlock
{
    return [Some oct_some:funcBlock(value)];
}

- (id)oct_flatMap:(id (^)(id))funcBlock
{
    return [[self oct_flatten] oct_map:funcBlock];
}

- (id)oct_fold:(id)seed oct_with:(id (^)(id, id))functorBlock
{
    return [Some oct_some:functorBlock(seed, value)];
}

- (Sequence*)oct_asSequence
{
    return sequence(value, nil);
}

- (NSEnumerator*)oct_toEnumerator
{
    return [SingleValueEnumerator singleValue:value];
}

- (id)copyWithZone:(NSZone*)zone
{
    return [Some oct_some:value];
}

- (void)oct_maybe:(void (^)(id))invokeWhenSomeBlock
{
    invokeWhenSomeBlock(value);
}

@end