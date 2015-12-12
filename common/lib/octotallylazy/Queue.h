#import <Foundation/Foundation.h>

@interface Queue : NSObject
- (BOOL)oct_isEmpty;

- (id)oct_remove;

- (void)oct_add:(id)item;

+ (Queue*)queue;

@end