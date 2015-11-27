//
//  MNMetrics.m
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

#import "MNMetrics.h"
#import "MNUtils.h"
#import "MNPadding.h"
#import "MNGlyphList.h"
#import "NSString+Ruby.h"
#import <objc/runtime.h>
#import "MNColor.h"
#import "MNPadding.h"
#import "MNPoint.h"
#import "MNBoundingBox.h"
#import "MNSize.h"
#import "MNTable.h"

@implementation MNMetrics
#pragma mark - Initialization
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        [self setupMetrics];
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithDictionary:nil];
    if(self)
    {
    }
    return self;
}

- (instancetype)initWithMetrics:(MNMetrics*)other
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        _xMin = other.xMin;
        _xMax = other.xMax;
        _width = other.width;
        _scale = other.scale;
        _length = other.length;

        _size = other.size;

        _parent = other.parent;
        _line = other.line;
        _lineAbove = other.lineAbove;
        _lineBelow = other.lineBelow;
        _textLine = other.textLine;
        _spacing = other.spacing;

        _cached = NO;
        //        _font = other.font;
        _code = other.code;
        //        _key = other.key;
        _name = other.name;
        _arrayOutline = other.arrayOutline;
        _stringOutline = other.stringOutline;

        _point = other.point;
        //        _shift = other.shift;
        _bounds = other.bounds;
        //        _padding = other.padding;

        //        _graphicsContext = other.graphicsContext;
    }
    return self;
}

- (void)setupMetrics
{
    _xMin = 0;
    _xMax = 0;
    _width = 0;
    _scale = 1;
    _length = 0;

    _size = [[MNFloatSize alloc] init];

    _parent = nil;
    _line = 0;
    _lineAbove = 0;
    _lineBelow = 0;
    _textLine = 0;
    _spacing = 0;

    _cached = NO;
    //    _font = @"";
    _code = @"";
    //    _key = @"";
    _name = @"";
    _arrayOutline = @[];
    _stringOutline = @"";

    _point = [MNPoint pointZero];
    _point.x = 0;
    //    _shift =  [MNPoint pointZero];
    _bounds = [MNBoundingBox boundingBoxZero];
    //    _padding =  [MNPadding paddingZero];

    //    _graphicsContext = nil;
}

#pragma mark - Properties

/*!
 *  gets a short description of this object
 *  @return a string showing properties of this object
 */
- (NSString*)description
{
    return [[NSString stringWithFormat:@"<%@:%p>\n", self.class, self]
        concat:[NSString stringWithFormat:@"%@", [self dictionarySerialization]]];
}

/*!
 *  helps create a debug description from the specified string to properties dictionary
 *  @return a dictionary of property names
 */
- (NSDictionary*)dictionarySerialization
{
    return [self dictionaryWithValuesForKeyPaths:@[
        @"name",
        @"scale",
        @"code",
        @"point",
        @"point",
    ]];
}

- (float)xMax
{
    return _xMin * self.scale;
}

- (float)xMin
{
    return _xMax * self.scale;
}

- (float)width
{
    // return (_xMax - _xMin) * _scale;
    return _width;
}

- (MNBoundingBox*)bounds
{
    if(!_bounds)
    {
        _bounds = [[MNBoundingBox alloc] initWithRect:CGRectMake(0, 0, 0, 0)];
    }
    return _bounds;
}

//- (NSString *)key {
//    return  _key;
//}
//
//- (void)setKey:(NSString *)key {
//    _key = key;
//
//    _code = _key;
//    _name = _key;

- (MNPoint*)point
{
    if(!_point)
    {
        _point = MNPointMake(0, 0);
    }
    return _point;
}

- (void)setCode:(NSString*)code
{
    _code = code;
    [self setOutline];
}

- (NSString*)code
{
    return _code;
}

- (void)setOutline
{
    if(self.cached)
    {
        [MNLog logInfo:@"MNMetricsSetOutlineAgain, already set the outline. Enable caching mechanism."];
        self.arrayOutline = [[[MNGlyphList sharedInstance] availableGlyphStructsDictionary] objectForKey:self.code];
    }

    if(!self.code)
    {
        MNLogError(@"EmptyCodeEception, no code set for this metrics object.");
    }

    if(!self.cached)
    {
        self.arrayOutline = [[[MNGlyphList sharedInstance] availableGlyphStructsDictionary] objectForKey:self.code];
    }

    self.cached = YES;
}

#pragma mark - Methods

/*!---------------------------------------------------------------------------------------------------------------------
 * @name Methods
 * ---------------------------------------------------------------------------------------------------------------------
*/

+ (MNMetrics*)metricsZero
{
    return [[MNMetrics alloc] init];
}

+ (MNMetrics*)standardMetrics
{
    MNMetrics* ret = [[MNMetrics alloc] init];
    ret.xMin = 0;
    ret.xMax = 600;
    ret.width = 10;
    //    ret.font = [NSString stringWithFormat:@""];
    ret.cached = NO;
    ret.length = 0.03;
    ret.scale = 1;
    return ret;
}

@end
