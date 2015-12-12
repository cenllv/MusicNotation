#import "Option.h"
#import "None.h"
#import "Some.h"
#import "Sequence.h"

@implementation Option

- (Sequence*)oct_asSequence
{
    [NSException raise:@"Unsupported" format:@"Unsupported"];
    return nil;
}

+ (id)oct_option:(id)value
{
    return (value == nil) ? [None none] : [Some oct_some:value];
}

- (BOOL)oct_isEmpty
{
    [NSException raise:@"Unsupported" format:@"Unsupported"];
    return FALSE;
}

- (id)oct_flatMap:(id (^)(id))funcBlock
{
    [NSException raise:@"Unsupported" format:@"Unsupported"];
    return nil;
}

- (id)oct_fold:(id)value oct_with:(id (^)(id, id))functorBlock
{
    [NSException raise:@"Unsupported" format:@"Unsupported"];
    return nil;
}

- (id)oct_get
{
    [NSException raise:@"Unsupported" format:@"Unsupported"];
    return nil;
}

- (id)oct_getSafely
{
    [NSException raise:@"Unsupported" format:@"Unsupported"];
    return nil;
}

- (id)oct_getOrElse:(id)other
{
    [NSException raise:@"Unsupported" format:@"Unsupported"];
    return nil;
}

- (id)oct_getOrInvoke:(id (^)())funcBlock
{
    [NSException raise:@"Unsupported" format:@"Unsupported"];
    return nil;
}

- (id)oct_map:(id (^)(id))funcBlock
{
    [NSException raise:@"Unsupported" format:@"Unsupported"];
    return nil;
}

- (void)oct_maybe:(void (^)(id))invokeWhenSomeBlock
{
    [NSException raise:@"Unsupported" format:@"Unsupported"];
}

- (NSEnumerator*)oct_toEnumerator
{
    [NSException raise:@"Unsupported" format:@"Unsupported"];
    return nil;
}

- (Option*)oct_flatten
{
    return [self oct_isEmpty] ? [None none] : [[[self oct_asSequence] oct_flatten] oct_headOption];
}

- (id)copyWithZone:(NSZone*)zone
{
    [NSException raise:@"Unsupported" format:@"Unsupported"];
    return nil;
}

@end