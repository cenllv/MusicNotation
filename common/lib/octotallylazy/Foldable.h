@protocol Foldable
- (id)oct_fold:(id)value oct_with:(id (^)(id, id))functorBlock;
@end