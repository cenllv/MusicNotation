//
//  MNStaffLine.m
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

#import "MNStaffLine.h"
#import "MNUtils.h"
#import "MNPoint.h"
#import "MNStaffNote.h"
#import "MNKeyProperty.h"
#import "MNStaffLineRenderOptions.h"
#import "MNStaffLineNotesStruct.h"
#import "MNNoteMetrics.h"

@implementation MNStaffLine

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

// ## Prototype Methods
// StaveLine.prototype = {
// Initialize the StaveLine with the given `notes`.
//
// `notes` is a struct that has:
//
//  ```
//  {
//    first_note: Note,
//    last_note: Note,
//    first_indices: [n1, n2, n3],
//    last_indices: [n1, n2, n3]
//  }
//  ```
- (instancetype)initWithNotes:(MNStaffLineNotesStruct*)notes
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        /*

            init: function(notes) {
                self.notes = notes;
                self.context = null;


                self.font = {
                family: "Arial",
                size: 10,
                weight: ""
                };
            },
         */
        self.staff_line_notes = notes;

        self.text = @"";

        _renderOptions = [[MNStaffLineRenderOptions alloc] init];
        MNStaffLineRenderOptions* render_options = _renderOptions;
        render_options.padding_left = 4;
        render_options.padding_right = 3;

        // The width of the line in pixels
        render_options.lineWidth = 1;
        // An array of line/space lengths. Unsupported with Raphael (SVG)
        render_options.lineDash = NO;
        // Can draw rounded line end, instead of a square. Unsupported with Raphael (SVG)
        render_options.lineCap = kCGLineCapButt;
        // The color of the line and arrowheads
        render_options.fillColor = MNColor.blackColor;
        render_options.strokeColor = MNColor.blackColor;

        // Flags to draw arrows on each end of the line
        render_options.draw_start_arrow = NO;
        render_options.draw_end_arrow = NO;

        // The length of the arrowhead sides
        render_options.arrowhead_length = 10;
        // The angle of the arrowhead
        render_options.arrowhead_angle = M_PI / 8;

        // The position of the text
        render_options.text_position_vertical = MNStaffLineVerticalJustifyTOP;
        render_options.text_justification = MNStaffLineJustifyCENTER;

        [self setNotes:notes];
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

/*!
 *  Set the notes for the `StaveLine`
 *  @param notes a StaffLineNotesStruct obj
 *       first_note: Note,
 *       last_note: Note,
 *       first_indices: [n1, n2, n3],
 *       last_indices: [n1, n2, n3]
 *  @return this object
 */
- (id)setNotes:(MNStaffLineNotesStruct*)notes
{
    if(!notes.first_note && !notes.last_note)
    {
        MNLogError("BadArguments, Notes needs to have either first_note or last_note set.");
    }
    if(!notes.first_indices)
    {
        notes.first_indices = @[ @0 ];
    }
    if(!notes.last_indices)
    {
        notes.last_indices = @[ @0 ];
    }
    if(notes.first_indices.count != notes.last_indices.count)
    {
        MNLogError(@"BadArguments, Connected notes must have similar index sizes");
    }

    self.first_note = notes.first_note;
    self.first_indices = notes.first_indices;
    self.last_note = notes.last_note;
    self.last_indices = notes.last_indices;
    return self;
}

#pragma mark - Properties

- (NSString*)text
{
    if(!_text)
    {
        _text = @"";
    }
    return _text;
}

- (MNStaffLineRenderOptions*)renderOptions
{
    if(!_renderOptions)
    {
        _renderOptions = [[MNStaffLineRenderOptions alloc] init];
    }
    return _renderOptions;
}

- (id)setRenderOptions:(MNStaffLineRenderOptions*)renderOptions
{
    _renderOptions = renderOptions;
    return self;
}

/*!
 *  Apply the style of the `StaveLine` to the context
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)applyLineStyle:(CGContextRef)ctx
{
    MNStaffLineRenderOptions* render_options = [self renderOptions];

    if(render_options.lineDash)
    {
        if(render_options.lineDashLengths.count > 0)
        {
            CGFloat* lengths = nil;
            NSUInteger cnt = render_options.lineDashLengths.count;
            lengths = malloc(sizeof(CGFloat) * cnt);
            memset(lengths, 0, sizeof(CGFloat) * cnt);
            [render_options.lineDashLengths foreach:^(NSNumber* element, NSUInteger index, BOOL* stop) {
              lengths[index] = (CGFloat)[element floatValue];
            }];
            size_t count = (size_t)render_options.lineDashCount;
            CGContextSetLineDash(ctx, render_options.lineDashPhase, lengths, count);
            free(lengths);
        }
        else
        {
            CGContextSetLineDash(ctx, 0, NULL, 0);
        }
    }
    //    if (render_options.lineWidth) {
    CGContextSetLineWidth(ctx, render_options.lineWidth);
    //    }
    CGContextSetLineCap(ctx, render_options.lineCap);
}

/*!
 *  Apply the text styling to the context
 */
- (void)applyFontStyle
{
    /*

            if (self.font) {
                ctx.setFont(self.font.family, self.font.size, self.font.weight);
            }

            if (self.render_options.color) {
                ctx.setStrokeStyle(self.render_options.color);
                ctx.setFillStyle(self.render_options.color);
            }
        },
     */
}

/*!
 *  Renders the `StaveLine` on the context
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];

    MNStaffNote* first_note = self.first_note;
    MNStaffNote* last_note = self.last_note;
    MNStaffLineRenderOptions* render_options = self.renderOptions;
    CGContextSaveGState(ctx);
    [self applyLineStyle:ctx];

    // Cycle through each set of indices and draw lines

    CGContextRestoreGState(ctx);
    __block MNPoint* start_position;
    __block MNPoint* end_position;
    [self.first_indices foreach:^(NSNumber* first_index_number, NSUInteger i, BOOL* stop) {
      NSUInteger first_index = [first_index_number unsignedIntegerValue];
      NSUInteger last_index = [self.last_indices[i] unsignedIntegerValue];

      // Get initial coordinates for the start/end of the line
      start_position = [first_note getModifierstartXYforPosition:MNPositionRight andIndex:first_index];
      end_position = [last_note getModifierstartXYforPosition:MNPositionLeft andIndex:first_index];
      BOOL upwards_slope = start_position.y > end_position.y;

      // Adjust `x` coordinates for modifiers
      start_position.x += first_note.metrics.modRightPx + render_options.padding_left;
      end_position.x -= last_note.metrics.modLeftPx + render_options.padding_right;

      // Adjust first `x` coordinates for displacements
      float notehead_width = first_note.glyphStruct.headWidth;
      BOOL first_displaced = ((MNKeyProperty*)first_note.keyProps[first_index]).displaced;
      if(first_displaced && first_note.stemDirection == MNStemDirectionUp)
      {
          start_position.x += notehead_width + render_options.padding_left;
      }

      // Adjust last `x` coordinates for displacements
      BOOL last_displaced = ((MNKeyProperty*)last_note.keyProps[last_index]).displaced;
      if(last_displaced && last_note.stemDirection == MNStemDirectionDown)
      {
          end_position.x -= notehead_width + render_options.padding_right;
      }

      // Adjust y position better if it's not coming from the center of the note
      start_position.y += upwards_slope ? -3 : 1;
      end_position.y += upwards_slope ? 2 : 0;

      // drawArrowLine(ctx, start_position, end_position, self.render_options);
      [self drawArrowLine:ctx
                fromPoint:start_position
                  toPoint:end_position
           drawStartArrow:self.renderOptions.draw_start_arrow
             drawEndArrow:self.renderOptions.draw_end_arrow
          arrowheadLength:self.renderOptions.arrowhead_length
           arrowheadAngle:self.renderOptions.arrowhead_angle
                fillColor:self.renderOptions.fillColor
              strokeColor:self.renderOptions.strokeColor];
    }];

    // Determine the x coordinate where to start the text
    float text_width = self.text.length;   // TODO: measure text correctly //ctx.measureText(self.text).width;
    MNStaffLineJustiticationType justification = render_options.text_justification;
    float x = 0;
    if(justification == MNStaffLineJustifyLEFT)
    {
        x = start_position.x;
    }
    else if(justification == MNStaffLineJustifyCENTER)
    {
        float delta_x = (end_position.x - start_position.x);
        float center_x = (delta_x / 2) + start_position.x;
        x = center_x - (text_width / 2);
    }
    else if(justification == MNStaffLineJustifyRIGHT)
    {
        x = end_position.x - text_width;
    }

    // Determine the y value to start the text
    float y = 0;
    MNStaffLineVerticalJustifyType vertical_position = render_options.text_position_vertical;
    if(vertical_position == MNStaffLineVerticalJustifyTOP)
    {
        y = [first_note.staff getYForTopText];
    }
    else if(vertical_position == MNStaffLineVerticalJustifyBOTTOM)
    {
        y = [first_note.staff getYForBottomText];
    }

    /*
            // Draw the text
            ctx.save();
            self.applyFontStyle();
            ctx.fillText(self.text, x, y);
            ctx.restore();

     */

    // Draw the text
    CGContextSaveGState(ctx);
    [self applyFontStyle];

    MNFont* descriptionFont = [MNFont fontWithName:@"ArialMT" size:12];

    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = kCTTextAlignmentCenter;
    NSAttributedString* description;

    description = [[NSAttributedString alloc] initWithString:self.text
                                                  attributes:@{
                                                      NSParagraphStyleAttributeName : paragraphStyle,
                                                      NSFontAttributeName : descriptionFont.font,
                                                      NSForegroundColorAttributeName : MNColor.blueColor
                                                  }];

    [description drawAtPoint:CGPointMake(x, y)];

    CGContextRestoreGState(ctx);
}

#pragma mark - Private Helpers

/*!
 *  Draw an arrow head that connects between 3 coordinates
 *  @param ctx    the core graphics opaque type drawing environment
 *  @param points an array of 3 mnpoints
 *  @attribution  Arrow rendering implementations based off of
 *                  Patrick Horgan's article, "Drawing lines and arcs with
 *                  arrow heads on  HTML5 Canvas"
 */
- (void)drawArrowHead:(CGContextRef)ctx points:(NSArray*)points
{
    if(points.count != 3)
    {
        MNLogError(@"ArrowHeadError, arrowhead requires 3 points exactly.");
    }
    MNPoint* point0 = points[0];
    MNPoint* point1 = points[1];
    MNPoint* point2 = points[2];
    float x0, y0, x1, y1, x2, y2;
    x0 = point0.x;
    y0 = point0.y;
    x1 = point1.x;
    y1 = point1.y;
    x2 = point2.x;
    y2 = point2.y;
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, x0, y0);
    CGContextAddLineToPoint(ctx, x1, y1);
    CGContextAddLineToPoint(ctx, x2, y2);
    CGContextAddLineToPoint(ctx, x0, y0);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

// Helper function to draw a line with arrow heads
- (void)drawArrowLine:(CGContextRef)ctx
            fromPoint:(MNPoint*)point1
              toPoint:(MNPoint*)point2
       drawStartArrow:(BOOL)draw_start_arrow
         drawEndArrow:(BOOL)draw_end_arrow
      arrowheadLength:(float)arrowhead_length
       arrowheadAngle:(float)arrowhead_angle
            fillColor:(MNColor*)fillColor
          strokeColor:(MNColor*)strokeColor
{
    float (^Distance)(MNPoint*, MNPoint*) = ^float(MNPoint* point1, MNPoint* point2) {
      float x1 = point1.x;
      float y1 = point1.y;
      float x2 = point2.x;
      float y2 = point2.y;
      float ret = sqrtf((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
      return ret;
    };

    BOOL both_arrows = draw_start_arrow && draw_end_arrow;

    float x1 = point1.x;
    float y1 = point1.y;
    float x2 = point2.x;
    float y2 = point2.y;

    // For ends with arrow we actually want to stop before we get to the arrow
    // so that wide lines won't put a flat end on the arrow.
    float distance = Distance(point1, point2);
    float ratio = (distance - arrowhead_length / 3) / distance;
    float end_x = 0, end_y = 0, start_x = 0, start_y = 0;
    if(draw_end_arrow || both_arrows)
    {
        end_x = roundf(x1 + (x2 - x1) * ratio);
        end_y = roundf(y1 + (y2 - y1) * ratio);
    }
    else
    {
        end_x = x2;
        end_y = y2;
    }

    if(draw_start_arrow || both_arrows)
    {
        start_x = x1 + (x2 - x1) * (1 - ratio);
        start_y = y1 + (y2 - y1) * (1 - ratio);
    }
    else
    {
        start_x = x1;
        start_y = y1;
    }

    /*

     if (config.color) {
     ctx.setStrokeStyle(config.color);
     ctx.setFillStyle(config.color);
     }
     */
    if(fillColor)
    {
        CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    }
    else
    {
        CGContextSetFillColorWithColor(ctx, MNColor.blackColor.CGColor);
    }
    if(strokeColor)
    {
        CGContextSetStrokeColorWithColor(ctx, strokeColor.CGColor);
    }
    else
    {
        CGContextSetStrokeColorWithColor(ctx, MNColor.blackColor.CGColor);
    }

    // Draw the shaft of the arrow
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, start_x, start_y);
    CGContextAddLineToPoint(ctx, end_x, end_y);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);

    /*


     // calculate the angle of the line
     var line_angle = Math.atan2(y2 - y1, x2 - x1);
     // h is the line length of a side of the arrow head
     var h = Math.abs(config.arrowhead_length / Math.cos(config.arrowhead_angle));
     */

    // calculate the angle of the line
    float line_angle = atan2f(y2 - y1, x2 - x1);
    // h is the line length of a side of the arrow head
    float h = ABS(arrowhead_length / cosf(arrowhead_angle));

    float angle1, angle2;
    float top_x, top_y;
    float bottom_x, bottom_y;

    if(draw_end_arrow || both_arrows)
    {
        angle1 = line_angle + M_PI + arrowhead_angle;
        top_x = x2 + cosf(angle1) * h;
        top_y = y2 + sinf(angle1) * h;

        angle2 = line_angle + M_PI - arrowhead_angle;
        bottom_x = x2 + cosf(angle2) * h;
        bottom_y = y2 + sinf(angle2) * h;

        [self drawArrowHead:ctx
                     points:@[ MNPointMake(top_x, top_y), MNPointMake(x2, y2), MNPointMake(bottom_x, bottom_y) ]];
    }

    if(draw_start_arrow || both_arrows)
    {
        angle1 = line_angle + arrowhead_angle;
        top_x = x1 + cosf(angle1) * h;
        top_y = y1 + sinf(angle1) * h;

        angle2 = line_angle - arrowhead_angle;
        bottom_x = x1 + cosf(angle2) * h;
        bottom_y = y1 + sinf(angle2) * h;

        [self drawArrowHead:ctx
                     points:@[ MNPointMake(top_x, top_y), MNPointMake(x1, y1), MNPointMake(bottom_x, bottom_y) ]];
    }
}
@end
