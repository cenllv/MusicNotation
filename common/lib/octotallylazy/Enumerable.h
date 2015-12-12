#import <Foundation/Foundation.h>

@protocol Enumerable <NSObject>
- (NSEnumerator*)oct_toEnumerator;
@end