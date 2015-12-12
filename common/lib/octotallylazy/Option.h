#import <Foundation/Foundation.h>
#import "Mappable.h"
#import "Foldable.h"
#import "Enumerable.h"
#import "Flattenable.h"
@class Sequence;

@interface Option : NSObject <NSCopying, Mappable, Foldable, Enumerable, Flattenable>
- (BOOL)oct_isEmpty;
- (id)oct_get;
- (id)oct_getSafely;
- (id)oct_getOrElse:(id)other;
- (id)oct_getOrInvoke:(id (^)())funcBlock;

- (id)oct_flatMap:(id (^)(id))funcBlock;

- (Sequence*)oct_asSequence;

- (void)oct_maybe:(void (^)(id))invokeWhenSomeBlock;

+ (id)oct_option:(id)value;
@end

static Option* option(id value)
{
    return [Option oct_option:value];
}