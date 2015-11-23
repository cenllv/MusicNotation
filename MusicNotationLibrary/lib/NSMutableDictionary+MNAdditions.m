//
//  NSMutableDictionary+MNAdditions.m
//  MusicNotation
//
//  Created by Scott on 5/14/15.
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

#import "NSMutableDictionary+MNAdditions.h"
#import "MNLog.h"

@implementation NSMutableDictionary (NSMutableDictionaryAdditions)

+ (NSDictionary*)dictionaryByMerging:(NSDictionary*)destination with:(NSDictionary*)source
{
    NSMutableDictionary* ret = [NSMutableDictionary dictionaryWithDictionary:destination];

    // FROM: http://stackoverflow.com/a/4028209/629014
    [source enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
      //      if(![destination objectForKey:key])
      //      {
      //          if([obj isKindOfClass:[NSDictionary class]])
      //          {
      //              NSDictionary* newVal = [[destination objectForKey:key]
      //              dictionaryByMergingWith:(NSDictionary*)obj];
      //              [ret setObject:newVal forKey:key];
      //          }
      //          else
      //          {
      [ret setObject:obj forKey:key];
      //                  }
      //      }
    }];

    return ret;
}

- (NSDictionary*)dictionaryByMergingWith:(NSDictionary*)dict
{
    return [[self class] dictionaryByMerging:self with:dict];
}

+ (NSDictionary*)merge:(NSDictionary*)destination with:(NSDictionary*)source;
{
    destination = [[self class] dictionaryByMerging:destination with:source];
    return destination;
}

- (NSDictionary*)mergeWith:(NSDictionary*)other
{
    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithDictionary:other];
    [other enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
      if(![other objectForKey:key])
      {
          if([obj isKindOfClass:[NSDictionary class]])
          {
              NSDictionary* newVal = [[self objectForKey:key] mergeWith:(NSDictionary*)obj];
              [self setObject:newVal forKey:key];
          }
          else
          {
              [self setObject:obj forKey:key];
          }
      }
    }];

    return (NSDictionary*)[result copy];
}

- (void)addObjectWithoutReplacing:(id)obj forKey:(id)key
{
    if([self objectForKey:key] == nil)
    {
        [self setObject:obj forKey:key];
    }
    else
    {
        MNLogError(@"attempting to add an already existing key");
    }
}

- (void)addEntriesFromDictionaryWithoutReplacing:(NSDictionary*)dictionary
{
    for(id key in dictionary.allKeys)
    {
        [self addObjectWithoutReplacing:dictionary[key] forKey:key];
    }
}

@end
