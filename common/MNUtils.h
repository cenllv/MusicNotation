//
//  MNVex.h
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

// #import "MNLog.h"
#import "MNMacros.h"
#import "MNMath.h"
#import "MNPropertyUtil.h"
//#import "NSString+MNAdditions.h"
#import "NSMutableArray+MNAdditions.h"
#import "NSMutableDictionary+MNAdditions.h"
#import "OCTotallyLazy.h"
#import "MNFont.h"

/*!
 *  The `MNUtils` class
 */
@interface MNUtils : NSObject

typedef BOOL (^EqualBlock)(NSNumber*, NSNumber*);

+ (void)RaiseException:(NSString* const)exception withFormat:(NSString*)aFormat, ...;

+ (NSArray*)sortAndUnique:(NSArray*)arr withCmp:(NSComparator)cmp andEq:(EqualBlock)eq;

@end

typedef enum _NSStringEnumerationEachCharOptions : NSUInteger
{
    NSStringEnumerationEachChar = 0,
    NSStringEnumerationEachCharReversed = 1,
    NSStringEnumerationEachCharCamelCase = 2,
} NSStringEnumerationEachCharOptions;

typedef NSString* (^CodeConverter)(NSString* inputString);

@interface NSString (NSStringEnumerator)
- (NSArray*)enumerateEachCharacterWithOptions:(NSStringEnumerationEachCharOptions)options
                                   UsingBlock:(CodeConverter)operation;
@end

@protocol ObjectToDictionary <NSObject>
- (NSDictionary*)toDictionary;
@end

@interface NSObject (MyPrettyPrint)
- (NSString*)prettyPrint;
@end
