//
//  MNVex.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "MNUtils.h"
#import <objc/runtime.h>

@implementation MNUtils

/*!
 *   Take 'arr' and return a new list consisting of the sorted, unique,
 *    contents of arr.
 *  @param arr input array
 *  @param cmp comparator
 *  @param eq  equality compare
 *  @return sorted and uniqued 'arr'
 */
+ (NSArray*)sortAndUnique:(NSArray*)arr withCmp:(NSComparator)cmp andEq:(EqualBlock)eq
{
    if(arr.count > 1)
    {
        NSMutableArray* newArr = [NSMutableArray array];
        NSNumber* last;
        arr = [arr sortedArrayUsingComparator:cmp];
        for(NSUInteger i = 0; i < arr.count; ++i)
        {
            if(i == 0 || !eq(arr[i], last))
            {
                [newArr addObject:arr[i]];
            }
            last = arr[i];
        }
        return newArr;
    }
    else
    {
        return arr;
    }
}

+ (void)RaiseException:(NSString* const)exception withFormat:(NSString*)aFormat, ...
{
    [NSException raise:exception format:aFormat, nil];
}

#pragma mark - Options

@end

// http://stackoverflow.com/a/16045504/629014
@implementation NSObject (MyPrettyPrint)
- (NSString*)prettyPrint
{
    BOOL isColl;
    return [self prettyPrintAtLevel:0 isCollection:&isColl];
}

- (NSString*)prettyPrintAtLevel:(int)level isCollection:(BOOL*)isCollection
{
    if([self respondsToSelector:@selector(toDictionary)])
    {
        NSDictionary* dict = [(id<ObjectToDictionary>)self toDictionary];
        return [dict prettyPrintAtLevel:level isCollection:isCollection];
    }

    NSString* padding = [@"" stringByPaddingToLength:level withString:@" " startingAtIndex:0];
    NSMutableString* desc = [NSMutableString string];

    if([self isKindOfClass:[NSArray class]])
    {
        NSArray* array = (NSArray*)self;
        NSUInteger cnt = [array count];
        [desc appendFormat:@"%@(\n", padding];
        for(id elem in array)
        {
            BOOL isColl;
            NSString* s = [elem prettyPrintAtLevel:(level + 3)isCollection:&isColl];
            if(isColl)
            {
                [desc appendFormat:@"%@", s];
            }
            else
            {
                [desc appendFormat:@"%@   %@", padding, s];
            }
            if(--cnt > 0)
                [desc appendString:@","];
            [desc appendString:@"\n"];
        }
        [desc appendFormat:@"%@)", padding];
        *isCollection = YES;
    }
    else if([self isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dict = (NSDictionary*)self;
        [desc appendFormat:@"%@{\n", padding];
        for(id key in dict)
        {
            BOOL isColl;
            id value = dict[key];
            NSString* s = [value prettyPrintAtLevel:(level + 3)isCollection:&isColl];
            if(isColl)
            {
                [desc appendFormat:@"   %@%@ =\n%@\n", padding, key, s];
            }
            else
            {
                [desc appendFormat:@"   %@%@ = %@\n", padding, key, s];
            }
        }
        [desc appendFormat:@"%@}", padding];
        *isCollection = YES;

    } /*else {
       [desc appendFormat:@"%@", self];
       *isCollection = NO;
       }*/
    else
    {
        NSString* className = [NSString stringWithCString:class_getName([self class]) encoding:NSASCIIStringEncoding];
        if(!className)
        {
            className = @"unknownName";
        }
        [desc appendFormat:@"<%p> %@ %@", self, className, [self description]];
    }

    return desc;
}
@end

@implementation NSString (NSStringEnumerator)

- (NSArray*)enumerateEachCharacterWithOptions:(NSStringEnumerationEachCharOptions)options
                                   UsingBlock:(CodeConverter)operation
{
    NSMutableArray* ret = [NSMutableArray array];
    switch(options)
    {
        case NSStringEnumerationEachChar:
            for(NSUInteger charIndex = 0; charIndex < self.length; ++charIndex)
            {
                [ret addObject:operation([self substringWithRange:NSMakeRange(charIndex, 1)])];
            }
            break;
        case NSStringEnumerationEachCharReversed:
            for(NSUInteger charIndex = self.length - 1; charIndex > -1; --charIndex)
            {
                [ret addObject:operation([self substringWithRange:NSMakeRange(charIndex, 1)])];
            }
            break;
        case NSStringEnumerationEachCharCamelCase:
            //            for (NSUInteger charIndex = 0; charIndex < self.count; ++charIndex) {
            //                [ret addObject:operation([self substringWithRange:NSMakeRange(charIndex, 1)])];
            //            }
            [MNLog logNotYetImplementedForClass:self andSelector:_cmd];
            abort();
            break;
        default:
            break;
    }

    return [NSArray arrayWithArray:ret];
}
@end
