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
#import "MNText.h"
#import "MNGlyph.h"

@implementation MNPedalMarking

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
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
    _custom_depress_text = nil;
    _custom_release_text = nil;

    self.fontFamily = @"TimesNewRomanPSMT";
    self.fontSize = 12;
    self.fontBold = YES;
    self.fontItalic = YES;

    self.bracket_height = 10;
    self.text_margin_right = 6;
    self.bracket_line_width = 1;
    self.glyph_point_size = 40;
    self.color = (MNColor*)MNColor.blackColor;
}

+ (MNPedalMarking*)pedalMarkingWithNotes:(NSArray*)notes
{
    return [[MNPedalMarking alloc] initWithNotes:notes];
}

/*!
 *   Create a sustain pedal marking. Returns the defaults PedalMarking.
 *   Which uses the traditional "Ped" and "*"" markings.mn
 *  @param notes <#notes description#>
 *  @return <#return value description#>
 */
+ (MNPedalMarking*)createSustain:(NSArray*)notes
{
    return [[MNPedalMarking alloc] initWithNotes:notes];
}

/*!
 *  Create a sostenuto pedal marking
 *  @param notes <#notes description#>
 *  @return <#return value description#>
 */
+ (MNPedalMarking*)createSostenuto:(NSArray*)notes
{
    MNPedalMarking* pedal = [[MNPedalMarking alloc] initWithNotes:notes];
    [pedal setStyle:MNPedalMarkingMixed];
    [pedal setCustomTextDepress:@"Sost." release:@"Ped."];
    return pedal;
}

/*!
 *  Create an una corda pedal marking
 *  @param notes <#notes description#>
 *  @return <#return value description#>
 */
+ (MNPedalMarking*)createUnaCorda:(NSArray*)notes
{
    MNPedalMarking* pedal = [[MNPedalMarking alloc] initWithNotes:notes];
    [pedal setStyle:MNPedalMarkingText];
    [pedal setCustomTextDepress:@"una corda" release:@"tre corda"];
    return pedal;
}

static NSDictionary* _pedalMarkingDictionary;

+ (NSDictionary*)pedalMarkingDictionary
{
    if(!_pedalMarkingDictionary)
    {
        _pedalMarkingDictionary = @{
            @"pedal_depress" : @{@"code" : @"v36", @"x_shift" : @-10, @"y_shift" : @0},
            @"pedal_release" : @{@"code" : @"v5d", @"x_shift" : @-2, @"y_shift" : @3},
        };
    }
    return _pedalMarkingDictionary;
}

#pragma mark - properties

/*!
 *  Set custom text for the `depress`/`release` pedal markings. No text is
 *  set if the parameter is falsy.
 *  @param depressText the depress text
 */
- (id)setCustomText:(NSString*)depressText
{
    id ret = [self setCustomTextDepress:depressText release:nil];
    return ret;
}

/*!
 *  Set custom text for the `depress`/`release` pedal markings. No text is
 *  set if the parameter is falsy.
 *  @param depressText the depress text
 *  @param releaseText the release text
 */
- (id)setCustomTextDepress:(NSString*)depressText release:(NSString*)releaseText
{
    self.custom_depress_text = depressText == nil ? @"" : depressText;
    self.custom_release_text = releaseText == nil ? @"" : releaseText;
    return self;
}

/*!
 *  Set the pedal marking style
 *  @param style <#style description#>
 */
- (void)setStyle:(MNPedalMarkingType)style
{
    if(style < 1 && style > 3)
    {
        MNLogError(@"InvalidParameter, The style must be one found in PedalMarking.Styles");
    }
    _style = style;
}

/*!
 *  Set the staff line to render the markings on
 *  @param line <#line description#>
 */
- (void)setLine:(float)line
{
    _line = line;
}

- (MNFont*)font
{
    if(!_font)
    {
        self.font = [MNFont fontWithName:self.fontFamily size:self.fontSize];
    }
    return _font;
}

#pragma mark - methods

/*!
 *  Render the pedal marking in position on the rendering context
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)draw:(CGContextRef)ctx
{
    //        [super draw:ctx];

    CGContextSaveGState(ctx);
    //    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    //    CGContextSetFillColorWithColor(ctx, self.color.CGColor);

    //         ctx.setFont(self.font.family, self.font.size, self.font.weight);
    [self.font setFillColor:self.color];
    //    [MNText setFont:self.font];   //[MNFont fontWithName:self.fontFamily size:self.fontSize]];
    //    [MNText setBold:self.fontBold];
    [self.font setBold:self.fontBold];

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

#pragma mark private

/*!
 *  Draw the bracket based pedal markings
 *  @param ctx the core graphics opaque type drawing environment
 */
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
    [self.notes oct_foreach:^(MNStaffNote* note, NSUInteger index, BOOL* stop) {
      // Each note triggers the opposite pedal action
      is_pedal_depressed = !is_pedal_depressed;

      // Get the initial coordinates for the note
      float x = note.absoluteX;
      float y = [note.staff getYForBottomTextWithLine:pedal.line + 3];

      // Throw if current note is positioned before the previous note
      if(x < prev_x)
      {
          MNLogError(@"InvalidConfiguration, The notes provided must be in order of ascending x positions");
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
                  CGSize text_size = [MNText measureText:pedal.custom_depress_text withFont:self.font];
                  float text_width = text_size.width;
                  [MNText drawText:ctx atPoint:MNPointMake(x - (text_width / 2), y) withText:pedal.custom_depress_text];
                  x_shift = (text_width / 2) + pedal.text_margin_right;
              }
              else
              {
                  // Render the Ped glyph in position
                  [self drawPedalGlyph:ctx withName:@"pedal_depress" atX:x atY:y withPointSize:self.glyph_point_size];
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
              //              CGContextClosePath(ctx);
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
          //          CGContextClosePath(ctx);
      }

      // Store previous coordinates
      prev_x = x + x_shift;
      prev_y = y;
    }];
}

/*!
 *  Draw the text based pedal markings. This defaults to the traditional
 *  "Ped" and "*"" symbols if no custom text has been provided.
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)drawText:(CGContextRef)ctx
{
    if(ctx == NULL)
    {
        MNLogError(@"NoContext, Can't draw PedalMarking without a context.");
    }
    __block BOOL is_pedal_depressed = NO;
    MNPedalMarking* pedal = self;

    // The glyph point size
    float point = pedal.glyph_point_size;

    // Iterate through each note, placing glyphs or custom text accordingly
    [self.notes oct_foreach:^(MNStaffNote* note, NSUInteger index, BOOL* stop) {
      is_pedal_depressed = !is_pedal_depressed;
      MNStaff* stave = note.staff;
      float x = note.absoluteX;
      float y = [stave getYForBottomTextWithLine:pedal.line + 3];   // getYForBottomText(pedal.line + 3);

      float text_width = 0;
      if(is_pedal_depressed)
      {
          if(pedal.custom_depress_text)
          {
              CGSize text_size = [MNText measureText:pedal.custom_depress_text withFont:self.font];
              //              text_width = [MNText measureText:pedal.custom_depress_text].width;
              text_width = text_size.width;
              [MNText drawText:ctx atPoint:MNPointMake(x - (text_width / 2), y) withText:pedal.custom_depress_text];
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
              CGSize text_size = [MNText measureText:pedal.custom_release_text withFont:self.font];
              //              text_width = [MNText measureText:pedal.custom_release_text].width;
              text_width = text_size.width;
              [MNText drawText:ctx atPoint:MNPointMake(x - (text_width / 2), y) withText:pedal.custom_release_text];
          }
          else
          {
              [self drawPedalGlyph:ctx withName:@"pedal_release" atX:x atY:y withPointSize:point];
          }
      }
    }];
}

/*!
 *  Draws a pedal glyph with the provided `name` on a rendering `context`
 *  at the coordinates `x` and `y. Takes into account the glyph data
 *  coordinate shifts.
 *  @param ctx the core graphics opaque type drawing environment
 *  @param name <#name description#>
 *  @param x    <#x description#>
 *  @param y    <#y description#>
 *  @param pts  <#pts description#>
 */
- (void)drawPedalGlyph:(CGContextRef)ctx withName:(NSString*)name atX:(float)x atY:(float)y withPointSize:(float)pts
{
    NSDictionary* glyph_data = [[[self class] pedalMarkingDictionary] objectForKey:name];
    MNGlyph* glyph = [[MNGlyph alloc] initWithCode:glyph_data[@"code"]];
    //    glyph.point = MNPointMake(x, y);
    [glyph renderWithContext:ctx atX:x atY:y];
}

@end
