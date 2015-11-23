@protocol Foldable
- (id)oct_fold:(id)value with:(id (^)(id, id))functorBlock;
@end