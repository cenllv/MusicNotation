//
//  MNTremulo.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Mike Corrigan <corrigan@gmail.com>
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

#import "MNTremulo.h"
#import "MNUtils.h"
#import "MNStaffNote.h"
#import "MNGlyph.h"
#import "MNPoint.h"

@implementation MNTremulo

- (instancetype)initWithNum:(NSUInteger)num
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        self.num = num;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        self.index = -999;
        self.position = MNPositionCenter;
        self.code = @"v74";
        self.shift_right = -2;
        self.y_spacing = 4;
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

- (NSString*)category
{
    return @"tremolo";
}

- (void)draw:(CGContextRef)ctx
{
    if(!(self.note && (self.index)))
    {
        MNLogError(@"NoAttachedNote, Can't draw Tremolo without a note and index.");
    }

    MNPoint* start = [self.note getModifierstartXYforPosition:self.position andIndex:self.index];
    float x = start.x;
    float y = start.y;

    x += self.shift_right;
    for(NSUInteger i = 0; i < self.num; ++i)
    {
        [MNGlyph renderGlyph:ctx atX:x atY:y withScale:1 forGlyphCode:self.code];
        y += self.y_spacing;
    }
}

@end
