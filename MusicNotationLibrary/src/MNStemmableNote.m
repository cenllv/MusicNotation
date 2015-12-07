#import "MNStaff.h"//
//  MNStemmableNote.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15.
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

#import "MNStemmableNote.h"
#import "MNStem.h"
#import "MNBeam.h"
#import "MNTable.h"
#import "MNGlyph.h"
#import "MNExtentStruct.h"
#import "MNUtils.h"
#import "MNMath.h"
#import "MNTableTypes.h"
#import "MNRational.h"
#import "MNConstants.h"
#import "MNStaff.h"

@implementation MNStemmableNote

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        self.postFormatted = NO;
        _stem = nil;
        _stem_extension_override = -1;
        _beam = nil;
        //        [self setValuesForKeyPathsWithDictionary:optionsDict];
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

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{ @"stem_direction" : @"stemDirection" }];
    return propertiesEntriesMapping;
}

/*!
 *  hhelps create a debug description from the specified string to properties dictionary
 *  @return a dictionary of property names
 */
- (NSDictionary*)dictionarySerialization
{
    return [self dictionaryWithValuesForKeyPaths:@[]];
}

#pragma mark - Methods

/*!
 *  gets the stem
 *  @return stem
 */
- (MNStem*)stem
{
    return _stem;
}

/*!
 *  sets the stem
 *  @param stem the stem of this note
 *  @return this object
 */
- (id)setStem:(MNStem*)stem
{
    _stem = stem;
    return self;
}

/*!
 *  Builds and sets a new stem
 */
- (void)buildStem
{
    self.stem = [[MNStem alloc] init];
}

/*!
 *  Get the full length of stem
 *  @return length of stem in pixels
 */
- (float)stemLength
{
    return kSTEM_HEIGHT + self.stemExtension;
}

/*!
 *  Get the count of beams for this duration
 *  @return number of beams
 */
- (NSUInteger)beamCount
{
    //     MNGlyph* glyph = self.glyph;
    MNTableGlyphStruct* glyphStruct = self.glyphStruct;
    if(glyphStruct)
    {
        return glyphStruct.beamCount;
    }
    else
    {
        return 0;
    }
}

/*!
 *  Get the minimum length of stem
 *  @return length in pixels
 */
- (float)stemMinLength
{
    MNRational* frac = [MNTable durationToFraction:self.durationString];
    //    __block float length = (frac.floatValue <= 1) ? 0 : 20;
    //    // if note is flagged, cannot shorten beam
    //    NSString* lookup = self.durationString;
    //    typedef void (^CaseBlock)();
    //    if(!_stemMinimumLengthsDictionary)
    //    {
    //        _stemMinimumLengthsDictionary = @{
    //            @"8" : ^{
    //              if(self.beam == nil)
    //                  length = 35;
    //            },
    //            @"16" : ^{
    //              if(self.beam == nil)
    //                  length = 35;
    //              else
    //                  length = 25;
    //            },
    //            @"32" : ^{
    //              if(self.beam == nil)
    //                  length = 45;
    //              else
    //                  length = 35;
    //            },
    //            @"64" : ^{
    //              if(self.beam == nil)
    //                  length = 50;
    //              else
    //                  length = 40;
    //            },
    //            @"128" : ^{
    //              if(self.beam == nil)
    //                  length = 55;
    //              else
    //                  length = 45;
    //            }
    //        };
    //    }
    //
    //    ((CaseBlock)_stemMinimumLengthsDictionary[lookup])();   // invoke block

    float length = ([frac floatValue] <= 1) ? 0 : 20;
    // if note is flagged, cannot shorten beam
    switch([self.duration integerValue])
    {
        case 8:
            if(!self.beam)
                length = 35;
            break;
        case 16:
            if(!self.beam)
                length = 35;
            else
                length = 25;
            break;
        case 32:
            if(!self.beam)
                length = 45;
            else
                length = 35;
            break;
        case 64:
            if(!self.beam)
                length = 50;
            else
                length = 40;
            break;
        case 128:
            if(!self.beam)
                length = 55;
            else
                length = 45;
    }

    return length;
}

/*!
 *  Get the direction of the stem
 *  @return +1 is up -1 is down 0 is undecided
 */
- (MNStemDirectionType)stemDirection
{
    return _stemDirection;
}

/*!
 *  Set the direction of the stem
 *  @param stemDirection +1 is up -1 is down 0 is undecided
 */
- (void)setStemDirection:(MNStemDirectionType)stemDirection
{
    if(stemDirection == MNStemDirectionNone)
    {
        stemDirection = MNStemDirectionUp;
    }
    if(stemDirection != MNStemDirectionUp && stemDirection != MNStemDirectionDown)
    {
        MNLogError(@"BadArgument, Invalid stem direction: %ti", stemDirection);
    }
    _stemDirection = stemDirection;
    if(self.stem != nil)
    {
        self.stem.stemDirection = stemDirection;
        self.stem.extension = self.stemExtension;
    }

    self.beam = nil;
    if(self.preFormatted)
    {
        [self preFormat];
    }
}

/*!
 *  Get the `x` coordinate of the stem
 *  @return x pixel coord
 */
- (float)stemX
{
    float x_begin, x_end;

    x_begin = self.absoluteX + self.xShift;
    x_end = x_begin + self.glyphStruct.headWidth;

    float stem_x = self.stemDirection == MNStemDirectionDown ? x_begin : x_end;

    stem_x -= ((kSTEM_WIDTH / 2) * ((float)self.stemDirection));

    return stem_x;
}

// Get the `x` coordinate for the center of the glyph.
// Used for `MNTabNote` stems and stemlets over rests
- (float)centerGlyphX
{
    return self.absoluteX + self.xShift + self.glyphStruct.headWidth / 2;
}

// Get the stem extension for the current duration
- (float)stemExtension
{
    MNTableGlyphStruct* glyphStruct = self.glyphStruct;
    if(self.stem_extension_override != -1)
    {
        return self.stem_extension_override;
    }

    if(glyphStruct != nil)
    {
        return self.stemDirection == 1 ? glyphStruct.stemUpExtension : glyphStruct.stemDownExtension;
    }

    return 0;
}

/*!
 *  Set the stem length to a specific. Will override the default length.
 *  @param height stem height in pixels
 */
- (void)setStemLength:(float)height
{
    self.stem_extension_override = height - kSTEM_HEIGHT;
}

/*!
 *  Get the top and bottom `y` values of the stem.
 *  @return pixels struct
 */
- (MNExtentStruct*)stemExtents
{
    if(self.ys == nil || self.ys.count == 0)
    {
        MNLogError(@"NoYValues, Can't get top stem Y when note has no Y values.");
        return nil;
    }

    float top_pixel = [self.ys[0] floatValue];
    float base_pixel = [self.ys[0] floatValue];
    float stem_height = kSTEM_HEIGHT + self.stemExtension;

    for(NSUInteger i = 0; i < self.ys.count; ++i)
    {
        float stem_top;
        stem_top = [self.ys[i] floatValue] + (stem_height * -((float)self.stemDirection));

        if(self.stemDirection == MNStemDirectionDown)
        {
            top_pixel = (top_pixel > stem_top) ? top_pixel : stem_top;
            base_pixel = (base_pixel < [self.ys[i] floatValue]) ? base_pixel : [self.ys[i] floatValue];
        }
        else
        {
            top_pixel = (top_pixel < stem_top) ? top_pixel : stem_top;
            base_pixel = (base_pixel > [self.ys[i] floatValue]) ? base_pixel : [self.ys[i] floatValue];
        }

        if(self.noteNHMRSType == MNNoteSlash || self.noteNHMRSType == MNNoteX)
        {
            top_pixel -= ((float)self.stemDirection) * 7;
            base_pixel -= ((float)self.stemDirection) * 7;
        }
    }
    //    MNLogInfo(@"Stem extents: (top:%f base:%f)", top_pixel, base_pixel);
    return [MNExtentStruct extentWithTopY:top_pixel andBaseY:base_pixel];
}

/*!
 *  Sets the current note's beam
 *  @param beam the beam for this note
 *  @return this object
 */
- (id)setBeam:(MNBeam*)beam
{
    _beam = beam;
    return self;
}
- (MNBeam*)beam
{
    return _beam;
}

- (MNNoteRenderOptions*)renderOptions
{
    return [super renderOptions];
}

/*!
 *  Get the `y` value for the top modifiers at a specific `text_line`
 *  @param textLine line number on staff for text
 *  @return y position on canvas
 */
- (float)getYForTopTextWithLine:(float)textLine
{
    MNExtentStruct* extents = self.stemExtents;
    if(self.hasStem)
    {
        float a, b;
        a = [self.staff getYForTopTextWithLine:textLine];
        b = extents.topY - (self.renderOptions.annotation_spacing * (textLine + 1));
        return MIN(a, b);
    }
    else
    {
        return [self.staff getYForTopTextWithLine:textLine];
    }
}
/*!
 *  Get the `y` value for the bottom modifiers at a specific `text_line`
 *  @param textLine line number on staff for text
 *  @return y position on canvas
 */
- (float)yForBottomText:(float)textLine
{
    MNExtentStruct* extents = self.stemExtents;
    if(self.hasStem)
    {
        float a, b;
        a = [self.staff getYForTopTextWithLine:textLine];
        b = extents.baseY + (self.renderOptions.annotation_spacing * textLine);
        return MAX(a, b);
    }
    else
    {
        return [self.staff getYForTopTextWithLine:textLine];
    }
}

/*!
 *  Post format the note
 *  @return YES if successful
 */
- (BOOL)postFormat
{
    if(self.beam != nil)
    {
        [self.beam postFormat];
    }
    self.postFormatted = YES;
    return YES;
}

/*!
 *  Render the stem onto the canvas
 *  @param ctx  the core graphics opaque type drawing environment
 *  @param stem stem object to draw
 */
- (void)drawStem:(CGContextRef)ctx withStem:(MNStem*)stem
{
    [super draw:ctx];

    self.stem = stem;
    //    if(self.drawStem)
    //    {
    [self.stem draw:ctx];
    //    }
}

@end
