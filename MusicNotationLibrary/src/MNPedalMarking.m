//
//  MNPedalMarking.m
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

#import "MNPedalMarking.h"
#import "MNUtils.h"
#import "MNStaffNote.h"
#import "MNColor.h"
#import "OCTotallyLazy.h"
#import "MNStaff.h"
#import "MNText.h"
#import "MNFont.h"
//#import "MNGlyph.h"
#import "MNTableTypes.h"

@implementation MNPedalMarking

static NSDictionary* _pedalMarkingDictionary;

+ (NSDictionary*)pedalMarkingDictionary
{
    if(!_pedalMarkingDictionary)
    {
        NSMutableDictionary* tmpDict = [[NSMutableDictionary alloc] init];
        MNTableGlyphStruct* tmp = [[MNTableGlyphStruct alloc] init];
        tmp.metrics.code = @"v36";
        tmp.metrics.name = @"pedal_depress";
        //        tmp.category = @"pedalmarking";
        //        tmp.metrics.shift =  [MNPoint pointWithX:-10 andY:0];
        [tmpDict setObject:tmp forKey:tmp.metrics.code];

        tmp = [[MNTableGlyphStruct alloc] init];
        tmp.metrics.code = @"v5d";
        tmp.metrics.name = @"pedal_release";
        //        tmp.category = @"pedalmarking";
        //        tmp.metrics.shift =  [MNPoint pointWithX:-2 andY:3];
        [tmpDict setObject:tmp forKey:tmp.metrics.code];

        _pedalMarkingDictionary = [NSDictionary dictionaryWithDictionary:tmpDict];
    }
    return _pedalMarkingDictionary;
}

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict;
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (instancetype)initWithNotes:(NSArray*)notes
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        self.notes = notes;
        [self setupPedalMarking];
    }
    return self;
}

- (void)setupPedalMarking
{
    self.style = MNPedalMarkingText;
    self.line = 0;

    // Custom text for the release/depress markings
    self.custom_depress_text = @"";
    self.custom_release_text = @"";

    self.fontFamily = @"Times New Roman";
    self.fontSize = 12;
    self.fontBold = YES;
    self.fontItalic = YES;

    self.bracket_height = 10;
    self.text_margin_right = 6;
    self.bracket_line_width = 1;
    self.glyph_point_size = 40;
    self.color = MNColor.blackColor;
}

+ (MNPedalMarking*)pedalMarkingWithNotes:(NSArray*)notes;
{
    return [[MNPedalMarking alloc] initWithNotes:notes];
}

// Create a sustain pedal marking. Returns the defaults PedalMarking.
// Which uses the traditional "Ped" and "*"" markings.
+ (MNPedalMarking*)createSustain:(NSArray*)notes
{
    return [[MNPedalMarking alloc] initWithNotes:notes];
}

// Create a sostenuto pedal marking
+ (MNPedalMarking*)createSostenuto:(NSArray*)notes
{
    MNPedalMarking* pedal = [[MNPedalMarking alloc] initWithNotes:notes];
    [pedal setStyle:MNPedalMarkingMixed];
    [pedal setCustomTextDepress:@"Sost." release:@"Ped."];
    return pedal;
}

// Create an una corda pedal marking
+ (MNPedalMarking*)createUnaCorda:(NSArray*)notes
{
    MNPedalMarking* pedal = [[MNPedalMarking alloc] initWithNotes:notes];
    [pedal setStyle:MNPedalMarkingText];
    [pedal setCustomTextDepress:@"una corda" release:@"tre corda"];
    return pedal;
}

- (void)setCustomText:(NSString*)text;
{
    [MNLog logNotYetImplementedForClass:self andSelector:_cmd];
    abort();
}

// Set custom text for the `depress`/`release` pedal markings. No text is
// set if the parameter is falsy.
- (void)setCustomTextDepress:(NSString*)depressText release:(NSString*)releaseText
{
    self.custom_depress_text = depressText == nil ? @"" : depressText;
    self.custom_release_text = releaseText == nil ? @"" : releaseText;
}

// Set the pedal marking style
- (void)setStyle:(MNPedalMarkingType)style
{
    if(style < 1 && style > 3)
    {
        [MNLog logError:@"InvalidParameter, The style must be one found in PedalMarking.Styles"];
    }
    _style = style;
}

// Set the staff line to render the markings on
- (void)setLine:(float)line
{
    _line = line;
}

// Set the rendering context
//- (void)setContext:(CGContextRef)ctx
//{
//    _graphicsContext = ctx;
//}

// Draw the bracket based pedal markings
- (void)drawBracketed:(CGContextRef)ctx
{
    //    if(ctx == NULL)
    //    {
    //         [MNLog logError:@"NoContext, Can't draw PedalMarking without a context."];
    //    }

    __block BOOL is_pedal_depressed = NO;
    __block float prev_x, prev_y;
    __block MNPedalMarking* pedal = self;

    // Iterate through each note
    //    __block NSUInteger index = 0;
    [self.notes foreach:^(MNStaffNote* note, NSUInteger index, BOOL* stop) {
      // Each note triggers the opposite pedal action
      is_pedal_depressed = !is_pedal_depressed;

      // Get the initial coordinates for the note
      float x = note.absoluteX;
      float y = [note.staff getYForBottomTextWithLine:pedal.line + 3];

      // Throw if current note is positioned before the previous note
      if(x < prev_x)
      {
          [MNLog logError:@"InvalidConfiguration, The notes provided must be in order of ascending x positions"];
      }

      // Determine if the previous or next note are the same
      // as the current note. We need to keep track of this for
      // when adjustments are made for the release+depress action
      BOOL next_is_same = (index < (self.notes.count - 1) && self.notes[index + 1] == note) ? YES : NO;
      BOOL prev_is_same = (index > 0 && self.notes[index - 1] == note) ? YES : NO;

      float x_shift = 0;
      if(is_pedal_depressed)
      {
          // Adjustment for release+depress
          x_shift = prev_is_same ? 5 : 0;

          if(pedal.style == MNPedalMarkingMixed && !prev_is_same)
          {
              // For MIXED style, start with text instead of bracket
              if(pedal.custom_depress_text)
              {
                  // If we have custom text, use instead of the default "Ped" glyph
                  float text_width = [MNText measureText:pedal.custom_depress_text].width;
                  [MNText drawSimpleText:ctx
                                 atPoint:MNPointMake(x - (text_width / 2), y)
                                withText:pedal.custom_depress_text];
                  x_shift = (text_width / 2) + pedal.text_margin_right;
              }
              else
              {
                  // Render the Ped glyph in position
                  [self drawPedalGlyph:ctx withName:@"pedal_dpress" atX:x atY:y withPointSize:self.glyph_point_size];
                  x_shift = 20 + pedal.text_margin_right;
              }
          }
          else
          {
              // Draw start bracket
              CGContextBeginPath(ctx);
              CGContextMoveToPoint(ctx, x, y - pedal.bracket_height);
              CGContextAddLineToPoint(ctx, x + x_shift, y);
              CGContextStrokePath(ctx);
              CGContextClosePath(ctx);
          }
      }
      else
      {
          // Adjustment for release+depress
          x_shift = next_is_same ? -5 : 0;

          // Draw end bracket
          CGContextBeginPath(ctx);
          CGContextMoveToPoint(ctx, prev_x, prev_y);
          CGContextAddLineToPoint(ctx, x + x_shift, y);
          CGContextAddLineToPoint(ctx, x, y - pedal.bracket_height);
          CGContextStrokePath(ctx);
          CGContextClosePath(ctx);
      }

      // Store previous coordinates
      prev_x = x + x_shift;
      prev_y = y;
    }];
}

// Draw the text based pedal markings. This defaults to the traditional
// "Ped" and "*"" symbols if no custom text has been provided.
- (void)drawText:(CGContextRef)ctx
{
    if(ctx == NULL)
    {
        [MNLog logError:@"NoContext, Can't draw PedalMarking without a context."];
    }
    __block BOOL is_pedal_depressed = NO;
    MNPedalMarking* pedal = self;

    // The glyph point size
    float point = pedal.glyph_point_size;

    // Iterate through each note, placing glyphs or custom text accordingly
    [self.notes foreach:^(MNStaffNote* note, NSUInteger index, BOOL* stop) {
      is_pedal_depressed = !is_pedal_depressed;
      MNStaff* stave = note.staff;
      float x = note.absoluteX;
      float y = [stave getYForBottomTextWithLine:pedal.line + 3];   // getYForBottomText(pedal.line + 3);

      float text_width = 0;
      if(is_pedal_depressed)
      {
          if(pedal.custom_depress_text)
          {
              text_width = [MNText measureText:pedal.custom_depress_text].width;
              [MNText drawSimpleText:ctx
                             atPoint:MNPointMake(x - (text_width / 2), y)
                            withText:pedal.custom_depress_text];
          }
          else
          {
              [self drawPedalGlyph:ctx withName:@"pedal_depress" atX:x atY:y withPointSize:point];
          }
      }
      else
      {
          if(pedal.custom_depress_text)
          {
              text_width = [MNText measureText:pedal.custom_release_text].width;
              [MNText drawSimpleText:ctx
                             atPoint:MNPointMake(x - (text_width / 2), y)
                            withText:pedal.custom_release_text];
          }
          else
          {
              [self drawPedalGlyph:ctx withName:@"pedal_release" atX:x atY:y withPointSize:point];
          }
      }
    }];
}

// Render the pedal marking in position on the rendering context
- (void)draw:(CGContextRef)ctx;
{
    //    [super draw:ctx];
    if(!ctx)
    {
        MNLogError(@"NoCanvasContext, Can't draw without a canvas context.");
    }

    CGContextSaveGState(ctx);
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    CGContextSetFillColorWithColor(ctx, self.color.CGColor);

    //         ctx.setFont(self.font.family, self.font.size, self.font.weight);
    [MNText setFont:[MNFont fontWithName:self.fontFamily size:self.fontSize]];
    [MNText setBold:self.fontBold];

    MNLogDebug(@"Rendering Pedal Marking");

    if(self.style == MNPedalMarkingBracket || self.style == MNPedalMarkingMixed)
    {
        CGContextSetLineWidth(ctx, self.bracket_line_width);
        [self drawBracketed:ctx];
    }
    else if(self.style == MNPedalMarkingText)
    {
        [self drawText:ctx];
    }

    CGContextRestoreGState(ctx);
}

// private

/*
    // ## Private Helper
    function drawPedalGlyph(name, context, x, y, point) {
        var glyph_data = PedalMarking.GLYPHS[name];
        var glyph = new Vex.Flow.Glyph(glyph_data.code, point);
        glyph.render(context, x + glyph_data.x_shift, y + glyph_data.y_shift);
    }

    return PedalMarking;
}());
*/

// Draws a pedal glyph with the provided `name` on a rendering `context`
// at the coordinates `x` and `y. Takes into account the glyph data
// coordinate shifts.
- (void)drawPedalGlyph:(CGContextRef)ctx withName:(NSString*)name atX:(float)x atY:(float)y withPointSize:(float)pts
{
    //     MNTablesGlyphStruct *glyph = [[MNPedalMarking pedalMarkingDictionary] objectForKey:name];
    //    glyph.metrics.point = [[MNPoint alloc]initWithX:x andY:y];
    //    [glyph renderWithMNKit];
}

@end
