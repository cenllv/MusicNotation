#import <Foundation/Foundation.h>
#import "Option.h"
#import "Sequence.h"

@interface NSDictionary (Functional)
- (NSDictionary*)oct_filterKeys:(BOOL (^)(id))functorBlock;
- (NSDictionary*)oct_filterValues:(BOOL (^)(id))functorBlock;
- (void)oct_foreach:(void (^)(id, id))funcBlock;
- (id)oct_map:(NSArray* (^)(id, id))funcBlock;
- (id)oct_mapValues:(id (^)(id))funcBlock;
- (Option*)oct_optionForKey:(id)key;
@end

static NSDictionary* dictionary(Sequence* keys, Sequence* values)
{
    return [NSDictionary dictionaryWithObjects:[values oct_asArray] forKeys:[keys oct_asArray]];
}
