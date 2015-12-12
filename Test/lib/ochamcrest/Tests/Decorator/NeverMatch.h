//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2014 hamcrest.org. See LICENSE.txt

#import "HCBaseMatcher.h"


@interface NeverMatch : HCBaseMatcher

+ (id)neverMatch;
+ (NSString *)mismatchDescription;
- (BOOL)matches:(id)item;
- (void)describeMismatchOf:(id)item to:(id<HCDescription>)mismatchDescription;

@end
