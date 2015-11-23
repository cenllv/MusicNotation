//
//  MNOptions.m
//  MNCore
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

#import "MNColor.h"
#import "MNOptions.h"
#import "NSObject+MNAdditions.h"

@implementation MNOptions
{
    NSString* _font;
    NSString* _code;
    MNColor* _fillColor;
    MNColor* _strokeColor;
    NSMutableArray* _lineConfig;
    float _strokePoints;
}

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict;
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        [self setupOptions];
    }
    return self;
}

- (void)setupOptions
{
    _font = nil;
    _code = nil;
    _fillColor = MNColor.blackColor;
    _strokeColor = MNColor.blackColor;
    _lineConfig = [NSMutableArray array];
    //    _cache = YES;
    _visible = YES;
    _strokePoints = 3.0;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping;
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

#pragma mark - Properties

- (NSString*)font
{
    if(!_font)
    {
        return @"";
    }
    else
    {
        return _font;
    }
}

- (void)setFont:(NSString*)font
{
    // TODO: check that this is a valid font
}

- (NSString*)code
{
    if(!_code)
    {
        return @"";
    }
    else
    {
        return _code;
    }
}

- (void)setCode:(NSString*)code
{
    // TODO: check that this is a valid code
}

- (MNColor*)fillColor
{
    return _fillColor;
}

- (void)setFillColor:(MNColor*)fillColor
{
    // TODO: check that this is a valid color
}

- (MNColor*)strokeColor
{
    return _strokeColor;
}

- (void)setStrokeColor:(MNColor*)strokeColor
{
    // TODO: check that this is a valid color
}

- (void)setLineConfig:(NSMutableArray*)lineConfig
{
    _lineConfig = lineConfig;
}

- (float)strokePoints
{
    return _strokePoints;
}

- (void)setStrokePoints:(float)strokePoints
{
    _strokePoints = strokePoints;
}

#pragma mark - Methods
+ (MNOptions*)options
{
    return [[MNOptions alloc] init];
}

@end
