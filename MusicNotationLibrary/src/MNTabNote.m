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

@implementation TabNoteRenderOptions

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict;
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        [self setupTabNoteOptions];
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping;
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

- (void)setupTabNoteOptions
{
}

@end

@implementation TabNotePositionsStruct

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict;
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

@end


@implementation MNTabNote

/*!
 *  Initialize the TabNote with a `tab_struct` full of properties
 *  and whether to `draw_stem` when rendering the note
 *  @param optionsDict <#optionsDict description#>
 *  @return <#return value description#>
 */
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict;
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        /*

                self.ghost = NO; // Renders parenthesis around notes
                // Note properties
                //
                // The fret positions in the note. An array of `{ str: X, fret: X }`
                self.positions = tab_struct.positions;

                // Render Options
                Vex.Merge(self.render_options, {
                    // font size for note heads and rests
                glyph_font_scale: 30,
                    // Flag to draw a stem
                draw_stem: draw_stem,
                    // Flag to draw dot modifiers
                draw_dots: draw_stem,
                    // Flag to extend the main stem through the staff and fret positions
                draw_stem_through_staff: NO
                });

                self.glyph =
                Vex.Flow.durationToGlyph(self.duration, self.noteType);
                if (!self.glyph) {
                    throw new Vex.RuntimeError("BadArguments",
                                               "Invalid note initialization data (No glyph found): " +
                                               JSON.stringify(tab_struct));
                }

                self.buildStem();

                if (tab_struct.stem_direction){
                    self.setStemDirection(tab_struct.stem_direction);
                } else {
                    self.setStemDirection(Stem.UP);
                }

                // Renders parenthesis around notes
                self.ghost = NO;
                self.updateWidth();
            },
     */
        //        self.positions = self.positionsCollection;

        TabNoteRenderOptions* renderOptions = self.renderOptions;
        renderOptions.glyph_font_scale = 30;
        renderOptions.draw_stem_through_staff = NO;

        //        renderOptions.draw_stem

        self.glyphStruct = [MNTable durationToGlyphStruct:self.durationString withNHMRSNoteString:self.noteTypeString];

        [self buildStem];

        if(!optionsDict[@"stem_direction"])
        {
            [self setStemDirection:MNStemDirectionUp];
        }

        self.ghost = NO;
        [self updateWidth];
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping;
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    return propertiesEntriesMapping;
}

- (NSMutableDictionary*)classesForArrayEntries
{
    NSMutableDictionary* classesForArrayEntries = [super classesForArrayEntries];
    [classesForArrayEntries addEntriesFromDictionaryWithoutReplacing:@{
        @"positions" : NSStringFromClass([TabNotePositionsStruct class])
    }];
    return classesForArrayEntries;
}

#pragma mark - Properties

- (TabNoteRenderOptions*)renderOptions
{
    if(!_renderOptions || ![_renderOptions isKindOfClass:[TabNoteRenderOptions class]])
    {
        _renderOptions = [[TabNoteRenderOptions alloc] init];
    }
    return _renderOptions;
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return @"tabnotes";
}

/*!
 *  Set as ghost `TabNote`, surrounds the fret positions with parenthesis.
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
 *  @return <#return value description#>
 */
- (float)getStemExtension
{
    /*
          var glyph = self.getGlyph();

          if (self.stem_extension_override != nil) {
            return self.stem_extension_override;
          }

          if (glyph) {
            return self.getStemDirection() === 1 ? glyph.tabnote_stem_up_extension :
              glyph.tabnote_stem_down_extension;
          }

          return 0;
        },
     */

    MNTableGlyphStruct* glyph = self.glyphStruct;

    // TODO: not enabled, fix
    //    if(self.stem_extension_override != nil)
    //    {
    //        return self.stem_extension_override;
    //    }

    if(glyph)
    {
        return self.stemDirection == MNStemDirectionUp ? glyph.tabnoteStemUpExtension : glyph.tabnoteStemDownExtension;
    }

    return 0;
}

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
 *  Set the `staff` to the note
 *  @param staff the staff
 */
- (void)setStaff:(MNStaff*)staff
{
    /*

          var superclass = Vex.Flow.TabNote.superclass;
          superclass.setstaff.call(this, staff);
          self.context = staff.context;
          self.width = 0;

          // Calculate the fret number width based on font used
          var i;
          if (self.context) {
            for (i = 0; i < self.glyphs.length; ++i) {
              var text = "" + self.glyphs[i].text;
              if (text.toUpperCase() != "X")
                self.glyphs[i].width = self.context.measureText(text).width;
              self.width = (self.glyphs[i].width > self.width) ?
                self.glyphs[i].width : self.width;
            }
          }

          var ys = [];

          // Setup y coordinates for score.
          for (i = 0; i < self.positions.length; ++i) {
            var line = self.positions[i].str;
            ys.push(self.staff.getYForLine(line - 1));
          }

          return self.setYs(ys);
     */

    super.staff = staff;

    self.width = 0;

    // Calculate the fret number width based on font used

    for(NSUInteger i = 0; i < self.glyphs.count; ++i)
    {
        MNGlyphTabStruct* glyph = self.glyphs[i];
        NSString* text = [NSString stringWithFormat:@"%@", glyph.text];
        if([[text uppercaseString] isNotEqualToString:@"X"])
        {
            // TODO: measure text needs help
            glyph.width = [self measureText:text withFont:[MNFont fontWithName:@"Arial" size:12]].width;
        }
        self.width = (glyph.width > self.width) ? glyph.width : self.width;
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

- (CGSize)measureText:(NSString*)text withFont:(NSFont*)font
{
    NSAttributedString* attributedText =
        [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : font}];
    //    CGRect paragraphRect =
    //        [attributedText boundingRectWithSize:CGSizeMake(300.f, CGFLOAT_MAX)
    //                                     options:(NSStringDrawingUsesLineFragmentOrigin |
    //                                     NSStringDrawingUsesFontLeading)
    //                                     context:nil];
    //    return paragraphRect.size;
    return [attributedText size];
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
    /*

          self.setModifierContext(mc);
          for (NSUInteger i = 0; i < self.modifiers.length; ++i) {
            self.modifierContext.addModifier(self.modifiers[i]);
          }
          self.modifierContext.addModifier(this);
          self.preFormatted = false;
          return this;

     */

    [self setModifierContext:mc];
    for(NSUInteger i = 0; i < self.modifiers.count; ++i)
    {
        [self.modifierContext addModifier:self.modifiers[i]];
    }
    //    [self.modifierContext addModifier:self];
    self.preFormatted = NO;
    return self;
}

/*!
 *  Get the `x` coordinate to the right of the note
 *  @return an x position
 */
- (float)tieRightX
{
    /*

      var tieStartX = self.getAbsoluteX();
      var note_glyph_width = self.glyph.head_width;
      tieStartX += (note_glyph_width / 2);
      tieStartX += ((-self.width / 2) + self.width + 2);

      return tieStartX;
    },
     */

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
    /*

      var tieEndX = self.getAbsoluteX();
      var note_glyph_width = self.glyph.head_width;
      tieEndX += (note_glyph_width / 2);
      tieEndX -= ((self.width / 2) + 2);

      return tieEndX;
    },

     */

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
- (MNPoint*)getModifierstartXYforPosition:(MNPositionType)position andIndex:(NSUInteger)index;
{
    /*

          if (!self.preFormatted) throw new Vex.RERR("UnformattedNote",
              "Can't call GetModifierStartXY on an unformatted note");

          if (self.ys.length === 0) throw new Vex.RERR("NoYValues",
              "No Y-Values calculated for this note.");
     */

    /*
          var x = 0;
          if (position == Vex.Flow.Modifier.Position.LEFT) {
            x = -1 * 2;  // extra_left_px
          } else if (position == Vex.Flow.Modifier.Position.RIGHT) {
            x = self.width + 2; // extra_right_px
          } else if (position == Vex.Flow.Modifier.Position.BELOW ||
                     position == Vex.Flow.Modifier.Position.ABOVE) {
              var note_glyph_width = self.glyph.head_width;
              x = note_glyph_width / 2;
          }

          return {x: self.getAbsoluteX() + x, y: self.ys[index]};
        },
     */

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
    /*
        //
        preFormat: function() {
          if (self.preFormatted) return;
          if (self.modifierContext) self.modifierContext.preFormat();
          // width is already set during init()
          self.setPreFormatted(true);
        },

     */

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
    /*
            //
        getStemX: function() { return self.getCenterGlyphX(); },
     */

    return self.centerGlyphX;
}

/*!
 *  Get the y position for the stem
 *  @return y position
 */
- (float)getStemY
{
    /*

          var num_lines = self.staff.getNumLines();

          // The decimal staff line amounts provide optimal spacing between the
          // fret number and the stem
          var stemUpLine = -0.5;
          var stemDownLine = num_lines - 0.5;
          var stemStartLine = Stem.UP === self.stem_direction ? stemUpLine : stemDownLine;

          return self.staff.getYForLine(stemStartLine);
     */

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
    /*
            //
        getStemExtents: function() {
            var stem_base_y = self.getStemY();
            var stem_top_y = stem_base_y + (Stem.HEIGHT * -self.stem_direction);

            return { topY: stem_top_y , baseY: stem_base_y};
        },
     */

    float stem_base_y = [self getStemY];
    float stem_top_y = stem_base_y + (kSTEM_HEIGHT * -self.stemDirection);

    MNExtentStruct* ret = [MNExtentStruct extentWithTopY:stem_top_y andBaseY:stem_base_y];
    return ret;
}

/*!
 *  draw the flag
 *  @param ctx the graphics context
 */
- (void)drawFlag:(CGContextRef)ctx
{
    /*

          var render_stem = self.beam == nil && self.render_options.draw_stem;
          var render_flag = self.beam == nil && render_stem;

          // Now it's the flag's turn.
          if (self.glyph.flag && render_flag) {
            var flag_x = self.getStemX() + 1 ;
            var flag_y = self.getStemY() - (self.stem.getHeight());
            var flag_code;
     */
    BOOL render_stem = self.beam == nil && self.renderOptions.draw_stem;
    BOOL render_flag = self.beam == nil && render_stem;

    if(self.glyphStruct.flag && render_flag)
    {
        float flag_x = self.stemX + 1;
        float flag_y = self.stemY - self.stem.height;
        NSString* flag_code;
        /*
                if (self.stem_direction == Stem.DOWN) {
                  // Down stems have flags on the left.
                  flag_code = self.glyph.code_flag_downstem;
                } else {
                  // Up stems have flags on the left.
                  flag_code = self.glyph.code_flag_upstem;
                }

                // Draw the Flag
                Vex.Flow.renderGlyph(self.context, flag_x, flag_y,
                    self.render_options.glyph_font_scale, flag_code);
              }

         */
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
 *  @param ctx the graphics context
 */
- (void)drawModifiers:(CGContextRef)ctx
{
    /*

          // Draw the modifiers
          self.modifiers.forEach(function(modifier) {
            // Only draw the dots if enabled
            if (modifier.getCategory() === 'dots' && !self.render_options.draw_dots) return;

            modifier.setContext(self.context);
            modifier.draw();
          }, this);

     */
    // Draw the modifiers
    [self.modifiers foreach:^(MNModifier* modifier, NSUInteger index, BOOL* stop) {
      // Only draw the dots if enabled
      //        if ([modifier.category isEqualToString:@"dots"]) {
      if([modifier isKindOfClass:[MNDot class]] && self.renderOptions.draw_dots)
      {
          return;
      }
      [modifier draw:ctx];
    }];
}

/*!
 *  Render the stem extension through the fret positions
 *  @param ctx the graphics context
 */
- (void)drawStemThrough:(CGContextRef)ctx
{
    /*
          var stem_x = self.getStemX();
          var stem_y = self.getStemY();
          var ctx = self.context;
     */
    float stem_x = self.stemX;
    float stem_y = self.stemY;

    /*
          var stem_through = self.render_options.draw_stem_through_staff;
          var draw_stem = self.render_options.draw_stem;
          if (draw_stem && stem_through) {
            var total_lines = self.staff.getNumLines();
            var strings_used = self.positions.map(function(position) {
              return position.str;
            });

            var unused_strings = getUnusedStringGroups(total_lines, strings_used);
            var stem_lines = getPartialStemLines(stem_y, unused_strings,
                                  self.getstaff(), self.getStemDirection());

            // Fine tune x position to match default stem
            if (!self.beam || self.getStemDirection() === 1) {
              stem_x += (Stem.WIDTH / 2);
            }
     */
    BOOL stem_through = self.renderOptions.draw_stem_through_staff;
    BOOL draw_stem = self.renderOptions.draw_stem;
    if(draw_stem && stem_through)
    {
        NSUInteger total_lines = self.staff.numberOfLines;
        NSArray* strings_used = [self.positions oct_map:^NSNumber*(TabNotePositionsStruct* position) {
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

        /*
                ctx.save();
                ctx.setLineWidth(Stem.WIDTH);
                stem_lines.forEach(function(bounds) {
                  ctx.beginPath();
                  ctx.moveTo(stem_x, bounds[0]);
                  ctx.lineTo(stem_x, bounds[bounds.length - 1]);
                  ctx.stroke();
                  ctx.closePath();
                });
                ctx.restore();
              }
         */
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
 *  @param ctx the graphics context
 */
- (void)drawPositions:(CGContextRef)ctx
{
    /*

          var ctx = self.context;
          var x = self.getAbsoluteX();
          var ys = self.ys;
          var y;
     */

    /*
          for (NSUInteger i = 0; i < self.positions.length; ++i) {
            y = ys[i];

            var glyph = self.glyphs[i];

            // Center the fret text beneath the notation note head
            var note_glyph_width = self.glyph.head_width;
            var tab_x = x + (note_glyph_width / 2) - (glyph.width / 2);

            ctx.clearRect(tab_x - 2, y - 3, glyph.width + 4, 6);

            if (glyph.code) {
              Vex.Flow.renderGlyph(ctx, tab_x, y + 5 + glyph.shift_y,
                  self.render_options.glyph_font_scale, glyph.code);
            } else {
              var text = glyph.text.toString();
              ctx.fillText(text, tab_x, y + 5);
            }
          }
        },

     */

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

        if(![glyph.code isMemberOfClass:[NSNull class]] && glyph.code.length > 0)
        {
            //            Vex.Flow.renderGlyph(ctx, tab_x, y + 5 + glyph.shift_y,
            //                                 self.render_options.glyph_font_scale, glyph.code);
            [MNGlyph renderGlyph:ctx atX:tab_x atY:y + 5 withScale:1 forGlyphCode:glyph.code];
        }
        else
        {
            //            var text = glyph.text.toString();
            NSString* text = glyph.text;
            //            ctx.fillText(text, tab_x, y + 5);

            //            CTTextAlignment justification = kCTTextAlignmentLeft;
            NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentLeft;   // justification;
            MNFont* font1 = [MNFont fontWithName:@"times" /*self.fontFamily*/ size:12];
            NSAttributedString* title = [[NSAttributedString alloc]
                initWithString:text
                    attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1}];
            float h = title.size.height;
            //            float w = title.size.width;
            [title drawAtPoint:CGPointMake(tab_x, y + 5 - h)];

            // // uncomment to draw bounding box
            //            MNBoundingBox* bb = [MNBoundingBox boundingBoxAtX:tab_x
            //                                                          atY:y + 5 - h
            //                                                    withWidth:title.size.width
            //                                                    andHeight:title.size.height];
            //            [bb draw:ctx];
        }
    }
}

/*!
 *  The main rendering function for the entire note
 *  @param ctx the graphics context
 */
- (void)draw:(CGContextRef)ctx;
{
    /*

          if (!self.staff) throw new Vex.RERR("Nostaff", "Can't draw without a staff.");
          if (self.ys.length === 0) throw new Vex.RERR("NoYValues",
              "Can't draw note without Y values.");

          var render_stem = self.beam == nil && self.render_options.draw_stem;

          self.drawPositions();
          self.drawStemThrough();

          var stem_x = self.getStemX();
          var stem_y = self.getStemY();
          if (render_stem) {
            self.drawStem({
              x_begin: stem_x,
              x_end: stem_x,
              y_top: stem_y,
              y_bottom: stem_y,
              y_extend: 0,
              stem_extension: self.getStemExtension(),
              stem_direction: self.stem_direction
            });
          }

          self.drawFlag();
          self.drawModifiers();

     */

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

// private
//

/*!
 *  Gets the unused strings grouped together if consecutive.
 *  @param numLines    The number of lines
 *  @param stringsUsed An array of numbers representing which strings have fret positions
 *  @return an array of unused strings
 */
- (NSArray*)getUnusedStringGroups:(NSUInteger)numLines stringsUsed:(NSArray*)stringsUsed
{
    /*
    var stem_through = [];
    var group = [];
    for (var string = 1; string <= num_lines ; string++) {
      var is_used = strings_used.indexOf(string) > -1;

      if (!is_used) {
        group.push(string);
      } else {
        stem_through.push(group);
        group = [];
      }
    }
    if (group.length > 0) stem_through.push(group);

    return stem_through;
  }
     */

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
 *  @return <#return value description#>
 */
- (NSArray*)getPartialStemLines:(float)stemY
                  unusedStrings:(NSArray*)unusedStrings
                          staff:(MNStaff*)staff
                  stemDirection:(MNStemDirectionType)stem_direction
{
    /*
        var up_stem = stem_direction !== 1;
        var down_stem = stem_direction !== -1;

        var line_spacing = staff.getSpacingBetweenLines();
        var total_lines = staff.getNumLines();

        var stem_lines = [];
    */
    BOOL up_stem = stem_direction != MNStemDirectionUp;
    BOOL down_stem = stem_direction != MNStemDirectionDown;

    float line_spacing = staff.spacingBetweenLines;
    NSUInteger total_lines = staff.numberOfLines;

    NSMutableArray* stem_lines = [NSMutableArray array];

    /*
        unused_strings.forEach(function(strings) {
          var containsLastString = strings.indexOf(total_lines) > -1;
          var containsFirstString =  strings.indexOf(1) > -1;

          if ((up_stem && containsFirstString) ||
             (down_stem && containsLastString)) {
            return;
          }

          // If there's only one string in the group, push a duplicate value.
          // We do this because we need 2 strings to convert into upper/lower y
          // values.
          if (strings.length === 1) {
            strings.push(strings[0]);
          }
     */

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

      /*
            var line_ys = [];
            // Iterate through each group string and store it's y position
            strings.forEach(function(string, index, strings) {
              var isTopBound = string === 1;
              var isBottomBound = string === total_lines;

              // Get the y value for the appropriate staff line,
              // we adjust for a 0 index array, since string numbers are index 1
              var y = staff.getYForLine(string - 1);

              // Unless the string is the first or last, add padding to each side
              // of the line
              if (index === 0 && !isTopBound) {
                y -= line_spacing/2 - 1;
              } else if (index === strings.length - 1 && !isBottomBound){
                y += line_spacing/2 - 1;
              }

              // Store the y value
              line_ys.push(y);
       */
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

        /*
                // Store a subsequent y value connecting this group to the main
                // stem above/below the staff if it's the top/bottom string
                if (stem_direction === 1 && isTopBound) {
                  line_ys.push(stem_y - 2);
                } else if (stem_direction === -1 && isBottomBound) {
                  line_ys.push(stem_y + 2);
                }
              });
         */
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

      /*
            // Add the sorted y values to the
            stem_lines.push(line_ys.sort(function(a, b) {
              return a - b;
            }));
          });

      */
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
