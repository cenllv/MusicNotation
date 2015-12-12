//
//  MNGlyphList.m
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

#import "MNGlyphList.h"
//#if TARGET_OS_MAC
//#import "JSONKit.h"
//#endif
#import "MNGlyph.h"
#import "MNUtils.h"
#import "MNSize.h"
#import "MNPoint.h"
#import "MNTable.h"
#import "MNConstants.h"

@implementation MNGlyphStruct

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (MNFloatSize*)size
{
    return [[MNGlyphList sharedInstance] sizeForName:self.name];
}

@end

@implementation MNGlyphList
#pragma mark - Initialization
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static MNGlyphList* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedInstance = [[MNGlyphList alloc] init];
      // Do any other initialisation stuff here
    });
    return sharedInstance;
}

#pragma mark - Class methods


static NSMutableDictionary* _dimensionsDictionary;
static NSMutableDictionary* _anchorPointForGlyphNameDictionary;
- (NSDictionary*)dimensionsDictionary
{
    if(!_dimensionsDictionary)
    {
        NSUInteger capacity = self.numberOfAvailableGlpyhStucts;
        _dimensionsDictionary = [NSMutableDictionary dictionaryWithCapacity:capacity];
        _anchorPointForGlyphNameDictionary = [NSMutableDictionary dictionaryWithCapacity:capacity];

        for(MNGlyphStruct* glyphStruct in self.availableGlyphStructsArray)
        {
            // record dimensions
            float x = 0, y = 0;
            float left = FLT_MAX, right = FLT_MIN, top = FLT_MAX, bottom = FLT_MIN;
            float scale = kSCALE;

            NSArray* outline = glyphStruct.arrayOutline;

            if(outline.count == 0)
            {
                [MNLog logInfo:@"EmptyOutlineException, outline for self symbol was not initialized."];
                [MNLog logInfo:@"Attempting to look up outline before rendering blockscope proceeds."];
                // attempt to lookup name
                if(glyphStruct.name.length == 0)
                {
                    MNLogError(@"SymbolnameEmptyException, name for symbol is empty.");
                }
                glyphStruct.arrayOutline = [self.availableGlyphStructsDictionary objectForKey:glyphStruct.name];
            }

            // TODO: loops twice the number of glyphs, needs fixed

            for(NSUInteger i = 0; i < outline.count;)
            {
                CGPoint pt = CGPointZero;
                NSString* action = (NSString*)[outline objectAtIndex:i++];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunsequenced"

                if([action isEqual:@"m"])
                {
                    pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
                }
                else if([action isEqual:@"l"])
                {
                    pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
                }
                else if([action isEqual:@"q"])
                {
                    i += 2;
                    pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
                }
                else if([action isEqual:@"b"])
                {
                    pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
                    i += 4;
                }
                else
                {
                    //[MNLog LogError:@"draw symbol error."];
                }
                left = pt.x < left ? pt.x : left;
                right = pt.x > right ? pt.x : right;
                top = pt.y < top ? pt.y : top;
                bottom = pt.y > bottom ? pt.y : bottom;

#pragma clang diagnostic pop
            }

            MNFloatSize* size = [[MNFloatSize alloc] init];
            size.width = ABS(left - right);
            size.height = ABS(top - bottom);
            [_dimensionsDictionary setObject:size forKey:glyphStruct.name];

            glyphStruct.anchorPoint = MNPointMake(left, top);
            glyphStruct.size = size;
        }
    }
    return _dimensionsDictionary;
}

- (NSDictionary*)anchorPointForGlyphNameDictionary
{
    if(!_anchorPointForGlyphNameDictionary)
    {
        [self dimensionsDictionary];
    }
    return _anchorPointForGlyphNameDictionary;
}

static NSUInteger _numberOfGlyphStructs = 0;
- (NSUInteger)numberOfAvailableGlpyhStucts
{
    if(_numberOfGlyphStructs == 0)
    {
        _numberOfGlyphStructs = self.availableGlyphStructsArray.count;
    }
    return _numberOfGlyphStructs;
}

static NSArray* _availableGlyphStructsArray = nil;
- (NSArray*)availableGlyphStructsArray
{
    if(!_availableGlyphStructsArray)
    {
        NSError* error;
        NSString* path = [[NSBundle mainBundle] pathForResource:@"gonville_all" ofType:@"js"];
        NSData* jsonData =
            [NSData dataWithContentsOfFile:path /*@"gonville_all.js"*/ options:NSDataReadingUncached error:&error];
        if(error)
        {
            MNLogError(@"%@", [error localizedDescription]);
            _availableGlyphStructsArray = nil;
        }
        else
        {
// http://www.14oranges.com/2011/08/how-to-use-jsonkit-for-ios-and-the-rotten-tomatoes-api/
// https://github.com/johnezang/JSONKit

#if TARGET_OS_IPHONE
            NSError* error = [[NSError alloc] init];
            NSDictionary* resultsDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
#elif TARGET_OS_MAC
            // TODO: the following line broke in MusicNotationLibrary app
//            NSDictionary* resultsDictionary = [jsonData objectFromJSONData];
            NSError *errorJson=nil;
            NSDictionary* resultsDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions
            error:&errorJson];

#endif

            NSDictionary* allJSONGlyphs = [[resultsDictionary objectForKey:@"Vex"] objectForKey:@"glyphs"];
            NSMutableArray* tmpArr = [[NSMutableArray alloc] initWithCapacity:allJSONGlyphs.count];
            for(NSString* key in allJSONGlyphs)
            {
                NSString* pathString = [[allJSONGlyphs objectForKey:key] objectForKey:@"o"];
                if(pathString)
                {
                    MNGlyphStruct* glyphStruct = [[MNGlyphStruct alloc] init];
                    glyphStruct.stringOutline = pathString;
                    glyphStruct.arrayOutline =
                        [NSArray arrayWithArray:[glyphStruct.stringOutline componentsSeparatedByString:@" "]];
                    glyphStruct.name = key;
                    [tmpArr addObject:glyphStruct];
                }
            }
            // http://stackoverflow.com/questions/3648411/objective-c-parse-hex-string-to-integer
            NSArray* sortedArray = [tmpArr sortedArrayUsingComparator:^(MNGlyphStruct* a, MNGlyphStruct* b) {
              unsigned int first = 0;
              unsigned int second = 0;

              NSScanner* scanner = [NSScanner scannerWithString:a.name];
              [scanner setScanLocation:1];
              [scanner scanHexInt:&first];

              scanner = [NSScanner scannerWithString:b.name];
              [scanner setScanLocation:1];
              [scanner scanHexInt:&second];

              if(first < second)
              {
                  return (NSComparisonResult)NSOrderedAscending;
              }
              else if(first > second)
              {
                  return (NSComparisonResult)NSOrderedDescending;
              }
              else
              {
                  return (NSComparisonResult)NSOrderedSame;
              }
            }];
            _availableGlyphStructsArray = [NSArray arrayWithArray:sortedArray];
        }
    }
    return _availableGlyphStructsArray;
}

- (MNFloatSize*)sizeForName:(NSString*)name
{
    return self.dimensionsDictionary[name];
}

static NSDictionary* _availableGlyphsDictionary = nil;
- (NSDictionary*)availableGlyphStructsDictionary
{
    // http://stackoverflow.com/q/3199194/629014
    if(!_availableGlyphsDictionary)
    {
        NSMutableDictionary* tempDict =
            [[NSMutableDictionary alloc] initWithCapacity:self.numberOfAvailableGlpyhStucts];
        for(MNGlyphStruct* glyphStruct in self.availableGlyphStructsArray)
        {
            [tempDict setValue:glyphStruct forKey:glyphStruct.name];
        }
        _availableGlyphsDictionary = [NSDictionary dictionaryWithDictionary:tempDict];
    }
    return _availableGlyphsDictionary;
}

- (NSUInteger)indexForName:(NSString*)name
{
    unsigned int retIndex = 0;
    NSScanner* scanner = [NSScanner scannerWithString:name];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&retIndex];
    return retIndex;
}

- (NSArray*)getOutlineForName:(NSString*)name
{
    if(!name || name.length == 0)
    {
        MNLogError(@"EmptyNameForOutlineError");
    }
    return [self.availableGlyphStructsDictionary[name] arrayOutline];
}

@end
