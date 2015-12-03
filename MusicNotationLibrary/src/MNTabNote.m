//
//  MNTabNote.m
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

#import "MNTabNote.h"
#import "MNUtils.h"
#import "MNTable.h"
#import "MNGlyphTabStruct.h"
#import "MNDot.h"
#import "MNTabStaff.h"
#import "MNGlyph.h"
#import "MNTableGlyphStruct.h"
#import "MNPoint.h"
#import "MNExtentStruct.h"
#import "MNStem.h"
#import "MNAnnotation.h"
#import "MNStroke.h"
#import "MNConstants.h"
#import "MNText.h"

@implementation MNTabNote

/*!
 *  Initialize the TabNote with a `tabStruct` full of properties
 *  and whether to `draw_stem` when rendering the note
 *  @param optionsDict { draw_stem -> B, stem_direction -> B, positions -> { str: X, fret: X } }
 *  @return <#return value description#>
 */
- (instancetype)initWithDictionary:(NSDictionary*)tabStruct
{
    self = [super initWithDictionary:tabStruct];
    if(self)
    {
        MNTabNoteRenderOptions* renderOptions = self.renderOptions;
        renderOptions.glyph_font_scale = 30;
        //        renderOptions.draw_stem = [tabStruct[@"draw_stem"] boolValue];
        renderOptions.draw_dots = [tabStruct[@"draw_stem"] boolValue];
        renderOptions.draw_stem = [tabStruct[@"draw_stem"] boolValue];
        renderOptions.draw_stem_through_staff = NO;

        //        renderOptions.draw_stem

        self.glyphStruct = [MNTable durationToGlyphStruct:self.durationString withNHMRSNoteString:self.noteTypeString];
        if(!self.glyphStruct)
        {
            MNLogError(@"BadArguments, Invalid note initialization data (No glyph found): %@", tabStruct);
        }

        [self buildStem];

        if(tabStruct[@"stem_direction"])
        {
            [self setStemDirection:[tabStruct[@"stem_direction"] integerValue]];
        }
        else
        {
            [self setStemDirection:MNStemDirectionUp];
        }

        self.ghost = NO;   // Renders parenthesis around notes
        [self updateWidth];
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{
        @"draw_stem" : @"drawStem",

    }];
    return propertiesEntriesMapping;
}

- (NSMutableDictionary*)classesForArrayEntries
{
    NSMutableDictionary* classesForArrayEntries = [super classesForArrayEntries];
    [classesForArrayEntries addEntriesFromDictionaryWithoutReplacing:@{
        // The fret positions in the note. An array of `{ str: X, fret: X }`
        @"positions" : NSStringFromClass([MNTabNotePositionsStruct class])
    }];
    return classesForArrayEntries;
}

#pragma mark - Properties

- (MNTabNoteRenderOptions*)renderOptions
{
    if(!_renderOptions || ![_renderOptions isKindOfClass:[MNTabNoteRenderOptions class]])
    {
        _renderOptions = [[MNTabNoteRenderOptions alloc] init];
    }
    return _renderOptions;
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    //    return @"tabnotes";
    return NSStringFromClass([self class]);
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

/*!
 *  Set as ghost `MNTabNote`, surrounds the fret positions with parenthesis.
 *  Often used for indicating frets that are being bent to
 *  @param ghost <#ghost description#>
 */
- (void)setGhostNote:(MNGhostNote*)ghostNote
{
    _ghostNote = ghostNote;
    [self updateWidth];
    //    return this;
}

/*!
 *  Determine if the note has a stem
 *  @return YES if has a stem
 */
- (BOOL)hasStem
{
    return self.renderOptions.draw_stem;
}

/*!
 *  Get the default stem extension for the note
 *  @return stem extension
 */
- (float)getStemExtension
{
    MNTableGlyphStruct* glyph = self.glyphStruct;

    // TODO: 3value not used
    if(self.stem_extension_override)
    {
        return self.stem_extension_override;
    }

    if(glyph)
    {
        return self.stemDirection == MNStemDirectionUp ? glyph.tabnoteStemUpExtension : glyph.tabnoteStemDownExtension;
    }

    return 0;
}

- (MNFont*)font
{
    if(!_font)
    {
        self.font = [MNFont fontWithName:@"times" size:12];
    }
    return _font;
}

- (void)setFont:(MNFont*)font
{
    _font = font;
}

#pragma mark - Methods

/*!
 *  Add a dot to the note
 *  @return this object
 */
- (id)addDot
{
    MNDot* dot = [[MNDot alloc] init];
    self.dots++;
    return [self addModifier:dot atIndex:0];
}

// Helper function to add an annotation to a key
- (id)addAnnotation:(MNAnnotation*)annotation atIndex:(NSUInteger)index
{
    return [self addModifier:annotation atIndex:index];
}

- (id)addStroke:(MNStroke*)stroke atIndex:(NSUInteger)index
{
    return [self addModifier:stroke atIndex:index];
}

/*!
 *  Calculate and store the width of the note
 */
- (void)updateWidth
{
    self.glyphs = [NSMutableArray array];
    self.width = 0;
    for(NSUInteger i = 0; i < self.positions.count; ++i)
    {
        //                NSString* fret = ((NSDictionary*)self.positions[i])[@"fret"];
        NSString* fret = [[self.positions objectAtIndex:i] fret];
        if(self.ghost)
        {
            fret = [NSString stringWithFormat:@"(%@)", fret];
        }
        MNGlyphTabStruct* glyphTabStruct = [MNTable glyphForTab:fret];
        [self.glyphs push:glyphTabStruct];
        self.width = (glyphTabStruct.width > self.width) ? glyphTabStruct.width : self.width;
    }
}

/*!
 *  Set the `MNStaff` to the note
 *  @param staff the staff
 */
- (void)setStaff:(MNStaff*)staff
{
    super.staff = staff;
    self.width = 0;

    // Calculate the fret number width based on font used

    for(NSUInteger i = 0; i < self.glyphs.count; ++i)
    {
        MNGlyphTabStruct* glyph = self.glyphs[i];
        NSString* text = [NSString stringWithFormat:@"%@", glyph.text];
        if([[text uppercaseString] isNotEqualToString:@"X"])
        {
            CGSize size = [MNText measureText:text withFont:self.font];
            glyph.width = size.width;
        }
        // CHANGE:
        //        self.width = (glyph.width > self.width) ? glyph.width : self.width;
        self.width = glyph.width;
    }

    NSMutableArray* ys = [NSMutableArray array];

    // Setup y coordinates for score.
    for(NSUInteger i = 0; i < self.positions.count; ++i)
    {
        NSUInteger line = [self.positions[i] str];
        [ys push:@([self.staff getYForLine:(line - 1)])];
    }

    self.ys = ys;
}

/*!
 *  Get the fret positions for the note
 *  @return an array of positions
 */
- (NSArray*)getPositions
{
    return _positions;
}

/*!
 *  Add self to the provided modifier context `mc`
 *  @param mc a modifier context
 *  @return this object
 */
- (id)addToModifierContext:(MNModifierContext*)mc
{
    [self setModifierContext:mc];
    for(NSUInteger i = 0; i < self.modifiers.count; ++i)
    {
        [self.modifierContext addModifier:self.modifiers[i]];
    }
    [self.modifierContext addModifier:self];
    self.preFormatted = NO;
    return self;
}

/*!
 *  Get the `x` coordinate to the right of the note
 *  @return an x position
 */
- (float)tieRightX
{
    float tieStartX = self.absoluteX;
    float note_glyph_width = self.glyphStruct.headWidth;
    tieStartX += (note_glyph_width / 2);
    tieStartX += ((-self.width / 2) + self.width + 2);

    return tieStartX;
}

/*!
 *  Get the `x` coordinate to the left of the note
 *  @return an x position
 */
- (float)tieLeftX
{
    float tieEndX = self.absoluteX;
    float note_glyph_width = self.glyphStruct.headWidth;
    tieEndX += (note_glyph_width / 2);
    tieEndX -= ((self.width / 2) + 2);

    return tieEndX;
}

/*!
 *  gets the point to put modifier for this noteat a specific
 *  `position` at a fret position `index`
 *  @param position the `left`, `right`, `top`, or `bottom` position to put the modifier
 *  @param index    if there's more than one modifier, then which index to occupy
 *  @return an xy point
 */
- (MNPoint*)getModifierstartXYforPosition:(MNPositionType)position andIndex:(NSUInteger)index
{
    if(!self.preFormatted)
    {
        MNLogError(@"UnformattedNote, Can't call GetModifierStartXY on an unformatted note");
    }

    if(self.ys.count == 0)
    {
        MNLogError(@"NoYValues, No Y-Values calculated for this note.");
    }

    float x = 0;

    if(position == MNPositionLeft)
    {
        x = -1 * 2;   // extra_left_px
    }
    else if(position == MNPositionRight)
    {
        x = self.width + 2;   // extra_right_px
    }
    else if(position == MNPositionBelow || position == MNPositionAbove)
    {
        float note_glyph_width = self.glyphStruct.headWidth;
        x = note_glyph_width / 2;
    }

    return MNPointMake((self.absoluteX + x), [self.ys[index] floatValue]);
}

/*!
 *  Get the default line for rest
 *  @return line for rest
 */
- (float)getLineForRest
{
    return [self.positions[0] str];
}

/*!
 *  Pre-render formatting
 *  @return YES if successful
 */
- (BOOL)preFormat
{
    if(self.preFormatted)
    {
        return YES;
    }
    if(self.modifierContext)
    {
        [self.modifierContext preFormat];
    }
    self.preFormatted = YES;
    return YES;
}

/*!
 *  Get the x position for the stem
 *  @return x position
 */
- (float)getStemX
{
    return self.centerGlyphX;
}

/*!
 *  Get the y position for the stem
 *  @return y position
 */
- (float)getStemY
{
    float num_lines = self.staff.numberOfLines;

    // The decimal staff line amounts provide optimal spacing between the
    // fret number and the stem
    float stemUpLine = -0.5;
    float stemDownLine = ((float)num_lines) - 0.5;
    float stemStartLine = self.stemDirection == MNStemDirectionUp ? stemUpLine : stemDownLine;

    return [self.staff getYForLine:stemStartLine];
}

/*!
 *  Get the stem extents for the tabnote
 *  @return a struct of base and top
 */
- (MNExtentStruct*)stemExtents
{
    float stem_base_y = [self getStemY];
    float stem_top_y = stem_base_y + (kSTEM_HEIGHT * -self.stemDirection);

    MNExtentStruct* ret = [MNExtentStruct extentWithTopY:stem_top_y andBaseY:stem_base_y];
    return ret;
}

/*!
 *  draw the flag
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)drawFlag:(CGContextRef)ctx
{
    BOOL render_stem = self.beam == nil && self.renderOptions.draw_stem;
    BOOL render_flag = self.beam == nil && render_stem;

    if(self.glyphStruct.flag && render_flag)
    {
        float flag_x = self.stemX + 1;
        float flag_y = self.stemY - self.stem.height;
        NSString* flag_code;

        if(self.stemDirection == MNStemDirectionDown)
        {
            // Down stems have flags on the left.
            flag_code = self.glyphStruct.codeFlagDownstem;
        }
        else
        {
            // Up stems have flags on the left.
            flag_code = self.glyphStruct.codeFlagUpstem;
        }

        // Draw the Flag
        [MNGlyph renderGlyph:ctx
                         atX:flag_x
                         atY:flag_y
                   withScale:1 /*self.render_options.glyph_font_scale*/
                forGlyphCode:flag_code];
    }
}

/*!
 *  Render the modifiers onto the context
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)drawModifiers:(CGContextRef)ctx
{
    // Draw the modifiers
    [self.modifiers foreach:^(MNModifier* modifier, NSUInteger index, BOOL* stop) {
      // Only draw the dots if enabled
      //        if ([modifier.category isEqualToString:@"dots"]) {
      if([modifier isKindOfClass:[MNDot class]] && !self.renderOptions.draw_dots)
      {
          return;
      }
      [modifier draw:ctx];
    }];
}

/*!
 *  Render the stem extension through the fret positions
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)drawStemThrough:(CGContextRef)ctx
{
    float stem_x = self.stemX;
    float stem_y = self.stemY;

    BOOL stem_through = self.renderOptions.draw_stem_through_staff;
    BOOL draw_stem = self.renderOptions.draw_stem;
    if(draw_stem && stem_through)
    {
        NSUInteger total_lines = self.staff.numberOfLines;
        NSArray* strings_used = [self.positions oct_map:^NSNumber*(MNTabNotePositionsStruct* position) {
          return [NSNumber numberWithUnsignedInteger:position.str];
        }];

        NSArray* unused_strings = [self getUnusedStringGroups:total_lines stringsUsed:strings_used];
        NSArray* stem_lines = [self getPartialStemLines:stem_y
                                          unusedStrings:unused_strings
                                                  staff:self.staff
                                          stemDirection:self.stemDirection];

        // Fine tune x position to match default stem
        if(!self.beam || self.stemDirection == MNStemDirectionUp)
        {
            stem_x += (kSTEM_WIDTH / 2);
        }

        CGContextSaveGState(ctx);
        CGContextSetLineWidth(ctx, kSTEM_WIDTH);
        [stem_lines foreach:^(NSArray* bounds, NSUInteger index, BOOL* stop) {
          if([bounds isEmpty])
          {   // CHANGE:
              //                *stop = YES;
              return;
          }
          CGContextBeginPath(ctx);
          CGContextMoveToPoint(ctx, stem_x, [bounds[0] floatValue]);
          CGContextAddLineToPoint(ctx, stem_x, [bounds[bounds.count - 1] floatValue]);
          CGContextClosePath(ctx);
          CGContextStrokePath(ctx);
        }];

        CGContextRestoreGState(ctx);
    }
}

/*!
 *  Render the fret positions onto the context
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)drawPositions:(CGContextRef)ctx
{
    float x = self.absoluteX;
    NSArray* ys = self.ys;
    float y;

    for(NSUInteger i = 0; i < self.positions.count; ++i)
    {
        y = [ys[i] floatValue];

        MNGlyphTabStruct* glyph = self.glyphs[i];

        // Center the fret text beneath the notation note head
        float note_glyph_width = self.glyphStruct.headWidth;
        float tab_x = x + (note_glyph_width / 2) - (glyph.width / 2);

        CGContextClearRect(ctx, CGRectMake(tab_x - 2, y - 3, glyph.width + 4, 6));

        y += 5;
        if(![glyph.code isMemberOfClass:[NSNull class]] && glyph.code.length > 0)
        {
            [MNGlyph renderGlyph:ctx atX:tab_x atY:y withScale:1 forGlyphCode:glyph.code];
        }
        else
        {
            NSString* text = glyph.text;
            NSAttributedString* title =
                [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : self.font.font}];
            [MNText drawText:ctx
                    withFont:self.font
                     atPoint:MNPointMake(tab_x, y - title.size.height)
                    withText:title.string];
        }
    }
}

/*!
 *  The main rendering function for the entire note
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)draw:(CGContextRef)ctx
{
    if(self.ys.count == 0)
    {
        MNLogError(@"NoYValues, Can't draw note without Y values.");
    }

    [super draw:ctx];

    BOOL render_stem = self.beam == nil && self.renderOptions.draw_stem;

    [self drawPositions:ctx];
    [self drawStemThrough:ctx];

    float stem_x = self.stemX;
    float stem_y = self.stemY;
    if(render_stem)
    {
        MNStem* stem = [[MNStem alloc] initWithDictionary:@{
            @"x_begin" : @(stem_x),
            @"x_end" : @(stem_x),
            @"y_top" : @(stem_y),
            @"y_bottom" : @(stem_y),
            @"y_extend" : @(0),
            @"stem_extension" : @(self.stemExtension),
            @"stemDirection" : @(self.stemDirection)
        }];
        [self drawStem:ctx withStem:stem];
    }

    [self drawFlag:ctx];
    [self drawModifiers:ctx];
}

#pragma mark Private

/*!
 *  Gets the unused strings grouped together if consecutive.
 *  @param numLines    The number of lines
 *  @param stringsUsed An array of numbers representing which strings have fret positions
 *  @return an array of unused strings
 */
- (NSArray*)getUnusedStringGroups:(NSUInteger)numLines stringsUsed:(NSArray*)stringsUsed
{
    NSMutableArray* stem_through = [NSMutableArray array];
    NSMutableArray* group = [NSMutableArray array];
    for(NSUInteger string = 1; string <= numLines; ++string)
    {
        BOOL is_used = [stringsUsed containsObject:@(string)];
        if(!is_used)
        {
            [group push:@(string)];
        }
        else
        {
            [stem_through push:group];
            group = [NSMutableArray array];
        }
    }
    if(group.count > 0)
    {
        [stem_through push:group];
    }

    return stem_through;
}

/*!
 *  Gets groups of points that outline the partial stem lines
 *  between fret positions
 *  @param stemY          The `y` coordinate the stem is located on
 *  @param unusedStrings  An array of groups of unused strings
 *  @param staff          The staff to use for reference
 *  @param stem_direction The direction of the stem
 *  @return partial stem lines array
 */
- (NSArray*)getPartialStemLines:(float)stemY
                  unusedStrings:(NSArray*)unusedStrings
                          staff:(MNStaff*)staff
                  stemDirection:(MNStemDirectionType)stem_direction
{
    BOOL up_stem = stem_direction != MNStemDirectionUp;
    BOOL down_stem = stem_direction != MNStemDirectionDown;

    float line_spacing = staff.spacingBetweenLines;
    NSUInteger total_lines = staff.numberOfLines;

    NSMutableArray* stem_lines = [NSMutableArray array];

    [unusedStrings foreach:^(NSMutableArray* strings, NSUInteger index, BOOL* stop) {
      BOOL containsLastString =
          [strings containsObject:@(total_lines)];                // != NSNotFound;  // .indexOf(total_lines) > -1;
      BOOL containsFirstString = [strings containsObject:@(1)];   // != NSNotFound;   //.indexOf(1) > -1;

      if((up_stem && containsFirstString) || (down_stem && containsLastString))
      {
          return;
      }

      // If there's only one string in the group, push a duplicate value.
      // We do this because we need 2 strings to convert into upper/lower y
      // values.
      if(strings.count == 1)
      {
          [strings push:strings[0]];
      }

      NSMutableArray* line_ys = [NSMutableArray array];
      // Iterate through each group string and store it's y position
      [strings foreach:^(NSNumber* stringElement, NSUInteger index, BOOL* stop) {
        float string = [stringElement floatValue];

        BOOL isTopBound = string == 1;
        BOOL isBottomBound = string == total_lines;

        // Get the y value for the appropriate staff line,
        // we adjust for a 0 index array, since string numbers are index 1
        float y = [staff getYForLine:string - 1];

        // Unless the string is the first or last, add padding to each side
        // of the line
        if(index == 0 && !isTopBound)
        {
            y -= line_spacing / 2 - 1;
        }
        else if(index == strings.count - 1 && !isBottomBound)
        {
            y += line_spacing / 2 - 1;
        }

        // Store the y value
        [line_ys push:@(y)];

        // Store a subsequent y value connecting this group to the main
        // stem above/below the staff if it's the top/bottom string
        if(stem_direction == MNStemDirectionUp && isTopBound)
        {
            [line_ys push:@(stemY - 2)];
        }
        else if(stem_direction == MNStemDirectionDown && isBottomBound)
        {
            [line_ys push:@(stemY + 2)];
        }
      }];

      // Add the sorted y values to the
      [stem_lines push:[line_ys sortedArrayUsingComparator:^NSComparisonResult(NSNumber* obj1, NSNumber* obj2) {
                    NSUInteger a = [obj1 unsignedIntegerValue];
                    NSUInteger b = [obj2 unsignedIntegerValue];
                    if(a < b)
                    {
                        return NSOrderedAscending;
                    }
                    else if(a > b)
                    {
                        return NSOrderedDescending;
                    }
                    else
                    {
                        return NSOrderedSame;
                    }
                  }]];

    }];
    return stem_lines;
}

@end
