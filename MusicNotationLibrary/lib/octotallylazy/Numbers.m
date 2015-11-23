#import "Numbers.h"

@implementation Numbers
+ (FUNCTION2)min {
    return [^(NSNumber *a, NSNumber *b) {
        return a.doubleValue < b.doubleValue ? a : b;
    } copy];
}

+ (FUNCTION2)max {
    return [^(NSNumber *a, NSNumber *b) {
        return a.doubleValue > b.doubleValue ? a : b;
    } copy];
}

+ (FUNCTION2)sum {
    return [^(NSNumber *a, NSNumber *b) {
        return [NSNumber numberWithDouble:a.doubleValue + b.doubleValue];
    } copy];
}

+ (FUNCTION2)average {
    __block NSUInteger count = 1;
    return [^(NSNumber *previousAverage, NSNumber *number) {
        count++;
        return [NSNumber numberWithDouble:previousAverage.doubleValue + ((number.doubleValue - previousAverage.doubleValue)/count)];
    } copy];
}

+ (FUNCTION2)multiplyBy {
    return [^(NSNumber *a, NSNumber *b) {
        return [NSNumber numberWithDouble:a.doubleValue * b.doubleValue];
    } copy];
}

+ (FUNCTION1)multiplyBy:(NSNumber *)multiplier {
    return [^(NSNumber *number) {
        return [NSNumber numberWithDouble:number.doubleValue * multiplier.doubleValue];
    } copy];

}

+ (FUNCTION2)divideBy {
    return [^(NSNumber *a, NSNumber *b) {
        return [NSNumber numberWithDouble:a.doubleValue / b.doubleValue];
    } copy];
}

+ (FUNCTION1)divideBy:(NSNumber *)divisor {
    return [^(NSNumber *number) {
        return [NSNumber numberWithDouble:number.doubleValue / divisor.doubleValue];
    } copy];
}

+ (FUNCTION2)add {
    return [^(NSNumber *a, NSNumber *b) {
        return [NSNumber numberWithDouble:a.doubleValue + b.doubleValue];
    } copy];
}

+ (FUNCTION1)add:(NSNumber *)addition {
    return [^(NSNumber *number) {
        return [NSNumber numberWithDouble:number.doubleValue + addition.doubleValue];
    } copy];
}

+ (FUNCTION2)subtract {
    return [^(NSNumber *a, NSNumber *b) {
        return [NSNumber numberWithDouble:a.doubleValue - b.doubleValue];
    } copy];
}

+ (FUNCTION1)substract:(NSNumber *)subtractor {
    return [^(NSNumber *number) {
        return [NSNumber numberWithDouble:number.doubleValue - subtractor.doubleValue];
    } copy];
}
@end