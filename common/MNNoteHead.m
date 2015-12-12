//
//  MNNoteHead.m
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

#import "MNNoteHead.h"
#import "MNBoundingBox.h"
#import "MNUtils.h"
#import "MNRational.h"
#import "MNStaff.h"
#import "MNStaffNote.h"
#import "MNGlyph.h"
#import "MNTable.h"
#import "MNConstants.h"
#import "MNNoteHeadRenderOptions.h"

@implementation MNNoteHead

//+ (MNNoteHead *)noteHeadWithCustomGlyphCode:(NSString *)code {
//    return [[MNNoteHead alloc]initWithCustomGlyphCode:code];
//}

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        //    self.index = [optionsDict[@"index"] unsignedIntegerValue];
        self.x = 0;   // [optionsDict[@"x"]unsignedIntegerValue] || 0;
        self.y = 0;   //[optionsDict[@"y"] unsignedIntegerValue] || 0;

        if(![optionsDict.allKeys containsObject:@"displaced"])
        {
            self.displaced = NO;
        }

        // [optionsDict[@"stem_direction"] unsignedIntegerValue] ||  MNStemDirectionUp;
        //    self.line = [optionsDict[@"line"] unsignedIntegerValue];

        // Get glyph code based on duration and note type. This could be
        // regular notes, rests, or other custom codes.
        self.noteDurationType = [MNEnum typeNoteDurationTypeForString:self.durationString];
        //        self.noteNHMRSType = [MNEnum typeNoteNHMRSTypeForString:self.noteTypeString];
        if(optionsDict[@"noteNHMRSType"])
        {
            self.noteNHMRSType = [optionsDict[@"noteNHMRSType"] unsignedIntegerValue];
        }

        self.glyphStruct = [MNTable durationToGlyphStruct:self.noteDurationType withNHMRSType:self.noteNHMRSType];
        if(!self.glyphStruct)
        {
            MNLogError(@"BadArguments %@ %@ %@ %@", @"No glyph found for duration '%@'", self.durationString,
                       @" and type '%@'", self.noteName);
        }
        self.glyph_code = self.glyphStruct.codeHead;
        self.xShift = [optionsDict[@"x_shift"] floatValue];
        if(optionsDict[@"customGlyphCode"] && [optionsDict[@"customGlyphCode"] length] > 0)
        {
            self.custom_glyph = YES;
            self.glyph_code = optionsDict[@"customGlyphCode"];
        }

        self.style = optionsDict[@"style"];
        self.slashed = [optionsDict[@"slashed"] boolValue];

        MNNoteHeadRenderOptions* renderOptions = [[MNNoteHeadRenderOptions alloc] initWithDictionary:nil];
        [renderOptions merge:self->_renderOptions];
        self->_renderOptions = renderOptions;
        [renderOptions setGlyphFontScale:35.f / 35.f];   // font size for note heads
        [renderOptions setStrokePoints:3];               // number of stroke px to the left and right of head

        if(optionsDict[@"glyph_font_scale"])
        {
            [renderOptions setGlyphFontScale:[optionsDict[@"glyph_font_scale"] floatValue]];
        }

        // TODO: perhaps widths should be taken from calculated widths (MNGlyphList)
        //        self.width = self.glyphStruct.head_width;
        self.headWidth = self.glyphStruct.headWidth;
        self.width = self.headWidth;

        //        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

//- (instancetype)initWithCustomGlyphCode:(NSString *)code
//{
//    // TODO: might be necessary to use head_options as actual struct
//    self = [self initWithDictionary:nil];
//    if (self) {
//        self.customGlyphCode = code;
//        self.useCustomGlyph = YES;
//        [self setupNoteHeadWithOptions:nil];
//    }
//    return self;
//}

+ (MNNoteHead*)noteHeadWithOptionsDict:(NSDictionary*)optionsDict
{
    return [[MNNoteHead alloc] initWithDictionary:optionsDict];
}

- (void)setupNoteHeadWithOptions:(NSDictionary*)optionsDict
{
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{ @"note_type" : @"noteTypeString" }];
    return propertiesEntriesMapping;
}

/*

        // Set the Cavnas context for drawing
    setContext: function(context) { self.context = context; return this;},

        // Get the width of the notehead
    getWidth: function() { return self.width; },

        // Determine if the notehead is displaced
    isDisplaced: function() { return self.displaced === YES; },


    getStyle: function() { return self.style; },
    setStyle: function(style) { self.style = style; return this; },

        // Get the glyph data
    getGlyph: function(){ return self.glyph; },

        // Set the X coordinate
    setX: function(x){ self.x = x; return this; },

        // get/set the Y coordinate
    getY: function() { return self.y; },
    setY: function(y) { self.y = y;  return this; },

        // Get/set the stave line the notehead is placed on
    getLine: function() { return self.line; },
    setLine: function(line) { self.line = line; return this; },
     */

- (float)glyphFontScale
{
    return [self->_renderOptions glyphFontScale];
}

- (void)setGlyphFontScale:(float)glyphFontScale
{
    [self->_renderOptions setGlyphFontScale:glyphFontScale];
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);   // return @"notehead";
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

- (MNStaff*)staff
{
    if([self.parent isKindOfClass:[MNModifier class]])
    {
        return [((MNModifier*)self.parent)staff];
    }
    else
    {
        return super.staff;
    }
}

// Get the canvas `x` coordinate position of the notehead.
- (float)absoluteX
{
    // If the note has not been preformatted, then get the static x value
    // Otherwise, it's been formatted and we should use it's x value relative
    // to its tick context

    float x = !self.preFormatted ? self.x : super.absoluteX;

    return x + (self.displaced ? self.width * ((float)self.stemDirection) : 0.f);
}

- (void)setX:(float)x
{
    self.point.x = x;
}

- (float)x
{
    return self.point.x;
}

- (void)setY:(float)y
{
    self.point.y = y;
}

- (float)y
{
    return self.point.y;
}

- (void)setLine:(float)line
{
    super.line = line;
}

// Get the `BoundingBox` for the `NoteHead`
- (MNBoundingBox*)boundingBox
{
    if(!self.preFormatted)
    {
        MNLogError(@"UnformattedNote, Can't call getBoundingBox on an unformatted note.");
    }
    float spacing, half_spacing, min_y;
    spacing = self.staff.spacingBetweenLines;
    half_spacing = spacing / 2;
    min_y = self.y - half_spacing;

    return [MNBoundingBox boundingBoxAtX:self.absoluteX atY:min_y withWidth:self.width andHeight:spacing];
}

// Apply current style to Canvas `context`
- (void)applyStyle:(CGContextRef)ctx
{
    float blur = 0;
    if(self.style[@"shadowBlur"])
    {
        blur = [self.style[@"shadowBlur"] floatValue];
    }
    if(self.style[@"shadowColor"])
    {
        CGContextSetShadowWithColor(ctx, CGSizeMake(1, 1), blur, (CGColorRef)self.style[@"shadowColor"]);
    }
    if(self.style[@"fillStyle"])
    {
        CGContextSetFillColorWithColor(ctx, (CGColorRef)self.style[@"fillStyle"]);
    }
    if(self.style[@"strokeStyle"])
    {
        CGContextSetStrokeColorWithColor(ctx, (CGColorRef)self.style[@"strokeStyle"]);
    }
}

/*!
 *   Set notehead to a provided `stave`
 *  @param staff staff
 *  @return this object
 */
- (id)setStaff:(MNStaff*)staff
{
    [super setStaff:staff];
    //    super.staff = staff;
    //    _staff = staff;

    float line = _line;
    [self setY:[staff getYForNoteWithLine:line]];
    //    self.graphicsContext = self.staff.graphicsContext;
    return self;
}

// Pre-render formatting
- (BOOL)preFormat
{
    if(self.preFormatted)
    {
        return YES;
    }
    MNTableGlyphStruct* glyphStruct = self.glyphStruct;
    float width = glyphStruct.headWidth + self.extraLeftPx + self.extraRightPx;

    self.width = width;
    [self setPreFormatted:YES];
    return YES;
}

// Draw slashnote head manually. No glyph exists for self.
//
// Parameters:
// * `ctx`: the Canvas context
// * `duration`: the duration of the note. ex: "4"
// * `x`: the x coordinate to draw at
// * `y`: the y coordinate to draw at
// * `stem_direction`: the direction of the stem
- (void)drawSlashNoteHead:(CGContextRef)ctx
                 duration:(NSString*)duration
                        x:(float)x
                        y:(float)y
            stemDirection:(MNStemDirectionType)stemDirection
{
    float width = 15 + kSTEM_WIDTH / 2;
    CGContextSaveGState(ctx);
    CGContextSetLineWidth(ctx, kSTEM_WIDTH);

    BOOL fill = NO;

    if([[MNTable durationToNumber:duration] floatValue] > 2)
    {
        fill = YES;
    }

    if(fill == NO)
    {
        x -= (kSTEM_WIDTH / 2) * stemDirection;
    }

    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, x, y + 11);
    CGContextAddLineToPoint(ctx, x, y + 1);
    CGContextAddLineToPoint(ctx, x + width, y - 10);
    CGContextAddLineToPoint(ctx, x + width, y);
    CGContextAddLineToPoint(ctx, x, y + 11);
    CGContextClosePath(ctx);

    if(fill)
    {
        CGContextFillPath(ctx);
    }
    else
    {
        CGContextStrokePath(ctx);
    }

    if([[MNTable durationToFraction:duration] lessThanOrEquael:Rational(1,1)])
    {
        NSArray* breve_lines = @[ @(-3), @(-1), @(width + 1), @(width + 3) ];
        for(NSUInteger i = 0; i < breve_lines.count; ++i)
        {
            CGContextBeginPath(ctx);
            CGContextMoveToPoint(ctx, x + [breve_lines[i] floatValue], y - 10);
            CGContextAddLineToPoint(ctx, x + [breve_lines[i] floatValue], y + 11);
            CGContextStrokePath(ctx);
        }
    }

    CGContextRestoreGState(ctx);
}

// Draw the notehead
- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];

    float head_x = self.absoluteX;
    float y = self.y;

    MNLogDebug(@"%@", [NSString stringWithFormat:@"Drawing note head: '%@', '%@' at (%f, %f)", self.noteTypeString,
                                                 self.durationString, head_x, y]);

    // Begin and end positions for head.

    MNStemDirectionType stem_direction = self.stemDirection;
    //    float glyph_font_scale = [self->_renderOptions glyphFontScale];

    float line = _line;
    if(!self.staff)
    {
        self.staff = [MNStaff currentStaff];
    }
    y = [self.staff getYForNoteWithLine:_line];

    // If note above/below the staff, draw the small staff
    if(line <= 0 || line >= 6)
    {
        float line_y = y;
        float floor = floorf(line);
        if(line < 0 && floor - line == -0.5)
        {
            line_y -= 5;
        }
        else if(line > 6 && floor - line == -0.5)
        {
            line_y += 5;
        }
        if(self.noteNHMRSType != MNNoteRest)
        {
            CGContextFillRect(ctx,
                              CGRectMake(head_x - [self->_renderOptions strokePoints], line_y,
                                         (self.glyphStruct.headWidth) + ([self->_renderOptions strokePoints] * 2), 1));
        }
    }

    if(self.noteNHMRSType == MNNoteSlash)
    {
        [self drawSlashNoteHead:ctx duration:self.durationString x:head_x y:y stemDirection:stem_direction];
    }
    else
    {
        float glyphFontScale = [[self renderOptions] glyphFontScale];
        if(self.style)
        {
            CGContextSaveGState(ctx);
            [self applyStyle:ctx];
            // TODO: this needs updated to latest styling method. see:  MNStaffNote.m -
            // (void)drawModifiers:(CGContextRef)ctx

            [MNGlyph renderGlyph:ctx atX:head_x atY:y withScale:glyphFontScale forGlyphCode:self.glyph_code];
            CGContextRestoreGState(ctx);
        }
        else
        {
            [MNGlyph renderGlyph:ctx atX:head_x atY:y withScale:glyphFontScale forGlyphCode:self.glyph_code];
        }
    }
}

#pragma mark - CALayer methods

- (CGMutablePathRef)pathConvertPoint:(CGPoint)convertPoint
{
    //    convertPoint = CGCombinePoints(self.point.CGPoint, convertPoint);
    CGMutablePathRef path = [super pathConvertPoint:convertPoint];

    //    float head_x = self.absoluteX;
    //    float y = self.staff.y;
    float x = self.absoluteX;   // - convertPoint.x;
    float y = [[MNStaff currentStaff] getYForNoteWithLine:_line] - self.staff.y;

    CGPathRef subPath = [MNGlyph createPathwithCode:self.glyph_code withScale:1 atPoint:CGPointMake(x, y)];
    CGPathAddPath(path, NULL, subPath);
    return path;
}

@end
