#import "Sequence.h"

@interface MemoisedSequence : Sequence
@end

static Sequence* memoiseSeq(id<Enumerable> underlying)
{
    return [MemoisedSequence oct_with:underlying];
}
