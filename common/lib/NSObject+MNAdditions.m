//
//  NSObject+MNAdditions.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
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

#import "NSObject+MNAdditions.h"

@implementation NSObject (MNAdditions)

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [self init];
    if(self)
    {
        //        if (![self canMergeWithOptionsDict:optionsDict]) {
        //             [MNLog LogFatal:@"Invalid options dictionary."];
        //            NSLog(@"Invalid options dictionary.");
        //        }
        //        [self setValuesForKeysWithDictionary:optionsDict];

        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (void)setValuesForKeyPathsWithDictionary:(NSDictionary*)keyedValues
{
    for(NSString* key_keyPath in keyedValues.allKeys)
    {
        id object = [keyedValues objectForKey:key_keyPath];
        [self setValue:object forKeyPath:key_keyPath];
    }
}

- (NSDictionary*)dictionaryWithValuesForKeyPaths:(NSArray*)keyPaths
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    for(NSString* keyPath in keyPaths)
    {
        [dict setObject:[self valueForKeyPath:keyPath] forKey:keyPath];
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
