//
//  MNTextNote.m
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

#import "MNTextNote.h"
#import "MNUtils.h"
#import "MNGlyph.h"
#import "MNTable.h"
#import "MNStaff.h"
#import "MNText.h"
#import "MNTextNoteStruct.h"

@interface MNTextNote ()

@property (strong, nonatomic) MNTextNoteStruct* glyphTextNoteStruct;

@end

@implementation MNTextNote

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        self.text = optionsDict[@"text"];
        self.glyph_type = optionsDict[@"glyph"];
        self.glyph = nil;
        if(self.glyph_type)
        {
            NSDictionary* glyphDict = [[self class] textNoteGlyphs][self.glyph_type];
            if(!glyphDict)
            {
                MNLogError(@"Invalid glyph type: %@", self.glyph_type);
            }

            self.glyphTextNoteStruct = [[MNTextNoteStruct alloc] initWithDictionary:glyphDict];
        }
        else
        {
            self.width = [MNText measureText:self.text withFont:self.font].width;
        }
        self.line = optionsDict[@"line"] ? [optionsDict[@"line"] floatValue] : 0;
        self.smooth = optionsDict[@"smooth"] ? [optionsDict[@"smooth"] boolValue] : NO;
        self.ignoreTicks = optionsDict[@"ignore_ticks"] ? [optionsDict[@"ignore_ticks"] boolValue] : NO;
        self.justification = MNJustifyLEFT;
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{
        @"superscript" : @"superScript",
        @"subscript" : @"subScript"
    }];
    return propertiesEntriesMapping;
}

- (MNFont*)font
{
    if(!_font)
    {
        _font = [MNFont fontWithName:@"Arial" size:16];
    }
    return _font;
}

- (id)setJustification:(MNJustiticationType)justification
{
    _justification = justification;
    return self;
}

- (void)setFont:(MNFont*)font
{
    _font = font;
}

// TODO: move to MNTables
static NSDictionary* _textNoteGlyphs;
+ (NSDictionary*)textNoteGlyphs
{
    if(!_textNoteGlyphs)
    {
        _textNoteGlyphs = @{
            @"segno" : @{@"code" : @"v8c", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @(-10)},
            @"tr" : @{@"code" : @"v1f", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @0},
            @"mordent_upper" : @{@"code" : @"v1e", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @0},
            @"mordent_lower" : @{@"code" : @"v45", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @0},
            @"f" : @{@"code" : @"vba", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @0},
            @"p" : @{@"code" : @"vbf", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @0},
            @"m" : @{@"code" : @"v62", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @0},
            @"s" : @{@"code" : @"v4a", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @0},
            @"z" : @{@"code" : @"v80", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @0},
            @"coda" : @{@"code" : @"v4d", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @(-8)},
            @"pedal_open" : @{@"code" : @"v36", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @0},
            @"pedal_close" : @{@"code" : @"v5d", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @3},
            @"caesura_straight" : @{@"code" : @"v34", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @2},
            @"caesura_curved" : @{@"code" : @"v4b", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @2},
            @"breath" : @{@"code" : @"v6c", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @0},
            @"tick" : @{@"code" : @"v6f", @"pointSize" : @(50. / 40.), @"x_shift" : @0, @"y_shift" : @0},
            @"turn" : @{@"code" : @"v72", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @0},
            @"turn_inverted" : @{@"code" : @"v33", @"pointSize" : @(40. / 40.), @"x_shift" : @0, @"y_shift" : @0},

            // DEPRECATED - please use "mordent_upper" or "mordent_lower"
            @"mordent" : @{
                @"code" : @"v1e",
                @"pointSize" : @(40. / 40.),
                @"x_shift" : @0,
                @"y_shift" : @0
                // width: 10 // optional
            },
        };
    }
    return _textNoteGlyphs;
}

// Pre-render formatting
- (BOOL)preFormat
{
    if(self.preFormatted)
    {
        return YES;
    }

    if(self.smooth)
    {
        self.width = 0;
    }
    else
    {
        if(self.glyph)
        {
            // Width already set.
        }
        else
        {
            self.width = (float)self.text.length;   // TODO: measure text properly
        }
    }

    if(_justification == MNJustifyCENTER)
    {
        self.extraLeftPx = self.width / 2;
    }
    else if(_justification == MNJustifyRIGHT)
    {
        self.extraLeftPx = self.width;
    }

    self.preFormatted = YES;
    return YES;
}

- (void)draw:(CGContextRef)ctx
{
    if(!self.staff)
    {
        MNLogError(@"NoStaff, Can't draw without a Staff.");
    }
    float x = self.absoluteX;

    if(_justification == MNJustifyCENTER)
    {
        x -= self.width / 2;
    }
    else if(_justification == MNJustifyRIGHT)
    {
        x -= self.width;
    }

    if(self.glyphTextNoteStruct)
    {
        MNTextNoteStruct* s = self.glyphTextNoteStruct;
        float y = [self.staff getYForLine:_line + (-3)];
        [MNGlyph renderGlyph:ctx atX:(x + s.x_shift)atY:(y + s.y_shift)withScale:s.pointSize forGlyphCode:s.code];
    }
    else
    {
        float y = [self.staff getYForLine:_line + (-3)];
        [MNText drawText:ctx withFont:self.font atPoint:MNPointMake(x, y) withText:self.text];

        // Get accurate width of text
        CGSize textSize = [MNText measureText:self.text withFont:self.font];
        float height = textSize.height;
        float width = textSize.width;

        // Write superscript
        if(self.superScript && self.superScript.length > 0)
        {
            MNFont* font = [MNFont fontWithName:self.font.family size:self.font.size / 1.3];
            [MNText drawText:ctx
                    withFont:font
                     atPoint:MNPointMake(x + width + 2, y - (height / 2.2))
                    withText:self.superScript];
        }

        // Write subscript
        if(self.subScript && self.subScript.length > 0)
        {
            MNFont* font = [MNFont fontWithName:self.font.family size:self.font.size / 1.3];
            [MNText drawText:ctx
                    withFont:font
                     atPoint:MNPointMake(x + width + 2, y + (height / 2.2) - 1)
                    withText:self.subScript];
        }
    }
}

@end
