#import "NSDictionary+OCTotallyLazy.h"
#import "Option.h"
#import "Sequence.h"

@implementation NSDictionary (Functional)

- (NSMutableDictionary* (^)(NSMutableDictionary*, id))addObjectForKey
{
    return [^(NSMutableDictionary* dict, id key) {
      [dict setObject:[self objectForKey:key] forKey:key];
      return dict;
    } copy];
}

- (NSDictionary*)oct_filterKeys:(BOOL (^)(id))filterBlock
{
    return [[[self allKeys] oct_filter:filterBlock] oct_fold:[NSMutableDictionary dictionary]
                                                    oct_with:[self addObjectForKey]];
}

- (NSDictionary*)oct_filterValues:(BOOL (^)(id))filterBlock
{
    return [[[self allValues] oct_filter:filterBlock]
        oct_fold:[NSMutableDictionary dictionary]
        oct_with:^(NSMutableDictionary* dict, id value) {
          [[self allKeysForObject:value] oct_fold:dict oct_with:[self addObjectForKey]];
          return dict;
        }];
}

- (void)oct_foreach:(void (^)(id, id))funcBlock
{
    //    NSUInteger i = 0;
    //    BOOL stop = NO;
    [[self allKeys] oct_foreach:^(id key, NSUInteger i, BOOL* b) {
      funcBlock(key, [self objectForKey:key]);
    }];
}

- (id)oct_map:(NSArray* (^)(id key, id value))funcBlock
{
    return [[[[self allKeys] oct_map:^(id key) {
      return funcBlock(key, [self objectForKey:key]);
    }] oct_flatten] oct_asDictionary];
}

- (id)oct_mapValues:(id (^)(id))funcBlock
{
    return dictionary([[self allKeys] oct_asSequence], [[[self allValues] oct_asSequence] oct_map:funcBlock]);
}

- (Option*)oct_optionForKey:(id)key
{
    return option([self objectForKey:key]);
}

@end